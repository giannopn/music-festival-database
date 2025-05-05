CREATE TABLE continent (
    continent_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE location (
    location_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    address VARCHAR(255) NOT NULL,
    city VARCHAR(255) NOT NULL,
    country VARCHAR(255) NOT NULL,
    continent INT NOT NULL,
    coordinates POINT NULL,
    FOREIGN KEY (continent) REFERENCES continent(continent_id)
);

CREATE TABLE festival (
    festival_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    location_id INT NOT NULL,
    UNIQUE (location_id),
    year INT GENERATED ALWAYS AS (EXTRACT(YEAR FROM start_date)::INT) STORED,
    UNIQUE (year),
    FOREIGN KEY (location_id) REFERENCES location(location_id)
);

/* 1. Trigger function */
CREATE OR REPLACE FUNCTION prevent_festival_deletion()
RETURNS TRIGGER AS $$
BEGIN
  IF TRUE THEN
    RAISE EXCEPTION 'Festival cannot be deleted!';
  END IF;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

/* 2. Attach the trigger */
DROP TRIGGER IF EXISTS trg_block_festival_delete ON festival;

CREATE TRIGGER trg_block_festival_delete
BEFORE DELETE ON festival
FOR EACH ROW
EXECUTE FUNCTION prevent_festival_deletion();

CREATE TABLE stage (
    stage_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    max_capacity INT NOT NULL CHECK (max_capacity > 0)
);

CREATE TABLE equipment (
    equipment_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT
);

CREATE TABLE stage_equipment (
    stage_id INT NOT NULL,
    equipment_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity >= 0),
    PRIMARY KEY (stage_id, equipment_id),
    FOREIGN KEY (stage_id) REFERENCES stage(stage_id) ON DELETE CASCADE,
    FOREIGN KEY (equipment_id) REFERENCES equipment(equipment_id) ON DELETE CASCADE
);

CREATE TABLE staff_category (
    staff_category_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT
);

CREATE TABLE staff_type (
    staff_type_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    staff_category_id INT NOT NULL,
    FOREIGN KEY (staff_category_id) REFERENCES staff_category(staff_category_id) ON DELETE CASCADE
);

CREATE TABLE experience_level (
    experience_level_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    level INT NOT NULL
);

CREATE TABLE staff (
    staff_id SERIAL PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    date_of_birth DATE NOT NULL,
    staff_category_id INT NOT NULL,
    staff_type_id INT,
    experience_level_id INT NOT NULL,
    FOREIGN KEY (staff_category_id) REFERENCES staff_category(staff_category_id),
    FOREIGN KEY (staff_type_id) REFERENCES staff_type(staff_type_id),
    FOREIGN KEY (experience_level_id) REFERENCES experience_level(experience_level_id)
);

-- 1. Trigger function: ensure staff_type’s category matches staff_category
CREATE OR REPLACE FUNCTION check_staff_type_category()
RETURNS TRIGGER AS $$
DECLARE
  st_cat INT;
BEGIN
  -- Only check when a staff_type is assigned
  IF NEW.staff_type_id IS NOT NULL THEN
    -- Lookup the category of that staff_type
    SELECT staff_category_id
      INTO st_cat
    FROM staff_type
    WHERE staff_type_id = NEW.staff_type_id;

    -- If it doesn’t match the staff’s category, block the change
    IF st_cat <> NEW.staff_category_id THEN
      RAISE EXCEPTION
        'Staff type % belongs to category %, but staff has category %',
        NEW.staff_type_id, st_cat, NEW.staff_category_id;
    END IF;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 2. Attach the trigger to fire before INSERT or UPDATE on staff
DROP TRIGGER IF EXISTS trg_check_staff_type_category ON staff;

CREATE TRIGGER trg_check_staff_type_category
BEFORE INSERT OR UPDATE ON staff
FOR EACH ROW
EXECUTE FUNCTION check_staff_type_category();


CREATE TABLE event (
    event_id SERIAL PRIMARY KEY,
    festival_id INT NOT NULL,
    name VARCHAR(255) NOT NULL,
    start_timestamp TIMESTAMP NOT NULL,
    end_timestamp TIMESTAMP NOT NULL,
    stage_id INT NOT NULL,
    sold_out BOOLEAN,
    FOREIGN KEY (festival_id) REFERENCES festival(festival_id),
    FOREIGN KEY (stage_id) REFERENCES stage(stage_id)
);

/*───────────────────────────────────────────────────────────────────
  Trigger function
  Ensures every event’s time window fits completely inside the
  date range of its parent festival.
     • festival.start_date   is taken as 00:00:00 of that day
     • festival.end_date     is taken as 23:59:59 of that day
  Any insert or update that violates the rule is rejected.
───────────────────────────────────────────────────────────────────*/
CREATE OR REPLACE FUNCTION check_event_within_festival_dates()
RETURNS TRIGGER AS $$
DECLARE
    fest_start_ts TIMESTAMP;   -- festival start at 00:00
    fest_end_ts   TIMESTAMP;   -- festival end   at 23:59:59
BEGIN
    /* 1 ── Fetch the festival’s date range */
    SELECT  start_date,
            end_date + INTERVAL '1 day' - INTERVAL '1 second'   -- 23:59:59
      INTO  fest_start_ts,
            fest_end_ts
    FROM festival
    WHERE festival_id = NEW.festival_id;

    IF fest_start_ts IS NULL OR fest_end_ts IS NULL THEN
        RAISE EXCEPTION
          'Festival % has NULL start or end dates – set them before adding events.',
          NEW.festival_id;
    END IF;

    /* 2 ── Validate the event window */
    IF NEW.start_timestamp < fest_start_ts
       OR NEW.end_timestamp   > fest_end_ts
    THEN
        RAISE EXCEPTION
          'Event [%→%] falls outside festival % window [%→%]',
          NEW.start_timestamp, NEW.end_timestamp,
          NEW.festival_id,     fest_start_ts, fest_end_ts;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_check_event_festival_range ON event;

CREATE TRIGGER trg_check_event_festival_range
BEFORE INSERT OR UPDATE ON event
FOR EACH ROW
EXECUTE FUNCTION check_event_within_festival_dates();

/* 1. Trigger function for event deletion prevention */
CREATE OR REPLACE FUNCTION prevent_event_deletion()
RETURNS TRIGGER AS $$
BEGIN
  IF TRUE THEN
    RAISE EXCEPTION 'Event cannot be deleted!';
  END IF;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

/* 2. Attach the trigger to the event table */
DROP TRIGGER IF EXISTS trg_block_event_delete ON event;

CREATE TRIGGER trg_block_event_delete
BEFORE DELETE ON event
FOR EACH ROW
EXECUTE FUNCTION prevent_event_deletion();

-- Check for event overlap on the same stage
CREATE OR REPLACE FUNCTION check_event_overlap_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM event e
        WHERE e.stage_id = NEW.stage_id
          AND (
                NEW.start_timestamp < e.end_timestamp
                AND NEW.end_timestamp > e.start_timestamp
              )
          AND e.event_id <> NEW.event_id
    ) THEN
        RAISE EXCEPTION 'Stage % is already booked in the given time range.', NEW.stage_id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_check_overlap_timestamp ON event;

CREATE TRIGGER trg_check_overlap_timestamp
BEFORE INSERT OR UPDATE ON event
FOR EACH ROW
EXECUTE FUNCTION check_event_overlap_timestamp();

CREATE TABLE event_staff (
    event_id INT NOT NULL,
    staff_id INT NOT NULL,
    PRIMARY KEY (event_id, staff_id),
    FOREIGN KEY (event_id) REFERENCES event(event_id) ON DELETE CASCADE,
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id) ON DELETE CASCADE
);

CREATE OR REPLACE FUNCTION check_staff_event_overlap()
RETURNS TRIGGER AS $$
DECLARE
    new_event RECORD;
BEGIN
    -- Get the start and end timestamps for the new event from the event table
    SELECT start_timestamp, end_timestamp
      INTO new_event
      FROM event
     WHERE event_id = NEW.event_id;

    -- Check if there exists any event already assigned to this staff that overlaps in time
    IF EXISTS (
        SELECT 1
          FROM event_staff es
          JOIN event e ON es.event_id = e.event_id
         WHERE es.staff_id = NEW.staff_id
           -- Exclude the current event in case of an update
           AND e.event_id <> NEW.event_id
           AND new_event.start_timestamp < e.end_timestamp
           AND new_event.end_timestamp > e.start_timestamp
    ) THEN
        RAISE EXCEPTION 'Staff member % is already assigned to an overlapping event.', NEW.staff_id;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_check_staff_overlap ON event_staff;

CREATE TRIGGER trg_check_staff_overlap
BEFORE INSERT OR UPDATE ON event_staff
FOR EACH ROW
EXECUTE FUNCTION check_staff_event_overlap();


-- USE IT AS CONSTRAINT TRIGGER, DEFERRABLE INITIALLY DEFERRED
/*───────────────────────────────────────────────────────────────────
  Callable procedure:
  Ensures an event has at least
     • security staff = 5 % of stage capacity   (rounded up)
     • support  staff = 2 % of stage capacity   (rounded up)
  Call it like:
     SELECT check_event_staff_coverage(42);   -- where 42 = event_id
───────────────────────────────────────────────────────────────────*/
CREATE OR REPLACE FUNCTION check_event_staff_coverage(p_event_id INT)
RETURNS VOID AS $$
DECLARE
    cap        INT;
    sec_req    INT;
    sup_req    INT;
    sec_count  INT;
    sup_count  INT;
BEGIN
    /* 1. Get stage capacity for this event */
    SELECT s.max_capacity
      INTO cap
    FROM event  e
    JOIN stage  s ON s.stage_id = e.stage_id
    WHERE e.event_id = p_event_id;

    /* 2. Required head-counts (ceiling) */
    sec_req := CEIL(cap * 0.05)::INT;
    sup_req := CEIL(cap * 0.02)::INT;

    /* 3. Count assigned SECURITY staff */
    SELECT COUNT(*)
      INTO sec_count
    FROM event_staff es
    JOIN staff st  ON st.staff_id  = es.staff_id
    WHERE es.event_id           = p_event_id
      AND st.staff_category_id = 2;

    /* 4. Count assigned SUPPORT staff */
    SELECT COUNT(*)
      INTO sup_count
    FROM event_staff es
    JOIN staff st  ON st.staff_id  = es.staff_id
    WHERE es.event_id           = p_event_id
      AND st.staff_category_id = 3;

    /* 5. Enforce */
    IF sec_count < sec_req THEN
        RAISE EXCEPTION
          'Event %: % security staff assigned, minimum % (5%% of % capacity).',
          p_event_id, sec_count, sec_req, cap;
    END IF;

    IF sup_count < sup_req THEN
        RAISE EXCEPTION
          'Event %: % support staff assigned, minimum % (2%% of % capacity).',
          p_event_id, sup_count, sup_req, cap;
    END IF;
END;
$$ LANGUAGE plpgsql;

--sources
--https://neon.tech/postgresql/postgresql-tutorial/postgresql-time
--https://www.geeksforgeeks.org/how-to-design-er-diagrams-for-online-ticketing-and-event-management/
--https://vertabelo.com/blog/er-diagram-movie-database/

CREATE TABLE genre (
    genre_id serial PRIMARY KEY,
    name varchar(255) NOT NULL
);

CREATE TABLE subgenre(
  subgenre_id serial PRIMARY KEY,
  name varchar(255) NOT NULL,
  genre_id integer NOT null,
  FOREIGN KEY (genre_id) references genre (genre_id) ON DELETE CASCADE
);

CREATE SEQUENCE artist_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

CREATE SEQUENCE band_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--sources
--date_of_birth: https://dev.to/insolita/postgres-and-birthday-dates-3ji4 and age https://stackoverflow.com/questions/40072914/postgresql-age-calculation-from-date-type
--website https://stackoverflow.com/questions/41633436/datatype-for-a-url-in-postgresql
--insta https://www.geeksforgeeks.org/how-to-design-a-database-for-instagram/
CREATE TABLE artist(
  artist_id integer DEFAULT nextval('artist_id_seq'::regclass) PRIMARY KEY,
  real_name varchar(255) NOT NULL,
  stage_name varchar(255),
  date_of_birth date NOT NULL,
  website text,
  instagram_profile varchar(255) UNIQUE
);

CREATE TABLE band(
  band_id integer DEFAULT nextval('band_id_seq'::regclass) PRIMARY KEY,
  name varchar(255),
  date_created date NOT NULL,
  website text,
  instagram_profile varchar(255) UNIQUE
);

CREATE TABLE artist_genre (
    artist_id INTEGER NOT NULL,
    genre_id INTEGER NOT NULL,
    subgenre_id INTEGER,
    PRIMARY KEY (artist_id, genre_id, subgenre_id),
    FOREIGN KEY (artist_id) REFERENCES artist (artist_id) ON DELETE CASCADE,
    FOREIGN KEY (genre_id) REFERENCES genre (genre_id) ON DELETE CASCADE,
    FOREIGN KEY (subgenre_id) REFERENCES subgenre (subgenre_id)
);

CREATE TABLE band_genre (
    band_id INTEGER NOT NULL,
    genre_id INTEGER NOT NULL,
    subgenre_id INTEGER,
    PRIMARY KEY (band_id, genre_id, subgenre_id),
    FOREIGN KEY (band_id) REFERENCES band (band_id) ON DELETE CASCADE,
    FOREIGN KEY (genre_id) REFERENCES genre (genre_id) ON DELETE CASCADE,
    FOREIGN KEY (subgenre_id) REFERENCES subgenre (subgenre_id)
);

CREATE TABLE band_membership (
    artist_id INTEGER NOT NULL,
    band_id INTEGER NOT NULL,
    PRIMARY KEY (artist_id, band_id),
    FOREIGN KEY (artist_id) REFERENCES artist (artist_id) ON DELETE CASCADE,
    FOREIGN KEY (band_id) REFERENCES band (band_id) ON DELETE CASCADE
);


CREATE SEQUENCE performance_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--sources:
-- nextval instead of serial  https://stackoverflow.com/questions/34034702/postgresql-sequence-vs-serial
-- Primary Key and Foreign key https://www.postgresql.org/docs/current/ddl-constraints.html
--time to check if timezone is needed?
--Ensure sequential performances within an event

CREATE TABLE performance (
    performance_id integer DEFAULT nextval('performance_id_seq'::regclass) PRIMARY KEY,
    name varchar(255) NOT NULL,
    event_id integer NOT NULL,
    artist_id integer,
    band_id integer,
    performance_type varchar(255) NOT NULL,
    start_time timestamp NOT NULL,
    end_time timestamp NOT NULL,
    duration integer GENERATED ALWAYS AS ((EXTRACT(EPOCH FROM end_time - start_time) / 60)::integer) STORED, --in minutes
    FOREIGN KEY (artist_id) references artist (artist_id),
    FOREIGN KEY (band_id) references band (band_id),
    CHECK (start_time < end_time),
    CHECK (end_time - start_time <= INTERVAL '3 hours'),
    CHECK (
        (artist_id IS NOT NULL AND band_id IS NULL) OR
        (band_id IS NOT NULL AND artist_id IS NULL)
    )
);


CREATE OR REPLACE FUNCTION validate_artist_genre_subgenre()
RETURNS TRIGGER AS $$
DECLARE
    valid_match INTEGER;
BEGIN
    IF NEW.subgenre_id IS NOT NULL THEN
        SELECT COUNT(*) INTO valid_match
        FROM subgenre
        WHERE subgenre_id = NEW.subgenre_id
          AND genre_id = NEW.genre_id;

        IF valid_match = 0 THEN
            RAISE EXCEPTION 'Subgenre % does not belong to Genre % in artist_genre.', NEW.subgenre_id, NEW.genre_id;
        END IF;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_validate_artist_genre ON artist_genre;

CREATE TRIGGER trg_validate_artist_genre
BEFORE INSERT OR UPDATE ON artist_genre
FOR EACH ROW
EXECUTE FUNCTION validate_artist_genre_subgenre();

CREATE OR REPLACE FUNCTION validate_band_genre_subgenre()
RETURNS TRIGGER AS $$
DECLARE
    valid_match INTEGER;
BEGIN
    IF NEW.subgenre_id IS NOT NULL THEN
        SELECT COUNT(*) INTO valid_match
        FROM subgenre
        WHERE subgenre_id = NEW.subgenre_id
          AND genre_id = NEW.genre_id;

        IF valid_match = 0 THEN
            RAISE EXCEPTION 'Subgenre % does not belong to Genre % in band_genre.', NEW.subgenre_id, NEW.genre_id;
        END IF;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_validate_band_genre ON band_genre;

CREATE TRIGGER trg_validate_band_genre
BEFORE INSERT OR UPDATE ON band_genre
FOR EACH ROW
EXECUTE FUNCTION validate_band_genre_subgenre();


CREATE OR REPLACE FUNCTION prevent_performance_deletion()
RETURNS TRIGGER AS $$
BEGIN
  IF TRUE THEN
    RAISE EXCEPTION 'Performance cannot be deleted!';
  END IF;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS prevent_delete_performance ON performance;

CREATE TRIGGER prevent_delete_performance
BEFORE DELETE ON performance
FOR EACH ROW
EXECUTE FUNCTION prevent_performance_deletion();


-- Check if artist/band perform on the same time
CREATE OR REPLACE FUNCTION prevent_performer_double_booking()
RETURNS TRIGGER AS $$
BEGIN
    /* ─────────────────────────────────────────────────────────────
       Check overlap for an ARTIST
    ───────────────────────────────────────────────────────────── */
    IF NEW.artist_id IS NOT NULL THEN
        IF EXISTS (
            SELECT 1
              FROM performance p
             WHERE p.artist_id       = NEW.artist_id
               AND p.performance_id <> NEW.performance_id           -- exclude self
               AND p.event_id       <> NEW.event_id                -- different event
               AND p.start_time <  NEW.end_time         -- time ranges overlap
               AND p.end_time   >  NEW.start_time
        ) THEN
            RAISE EXCEPTION
              'Artist % is already scheduled in another event at the same time.',
              NEW.artist_id;
        END IF;

    /* ─────────────────────────────────────────────────────────────
       Check overlap for a BAND
    ───────────────────────────────────────────────────────────── */
    ELSIF NEW.band_id IS NOT NULL THEN
        IF EXISTS (
            SELECT 1
              FROM performance p
             WHERE p.band_id         = NEW.band_id
               AND p.performance_id <> NEW.performance_id
               AND p.event_id       <> NEW.event_id
               AND p.start_time <  NEW.end_time
               AND p.end_time   >  NEW.start_time
        ) THEN
            RAISE EXCEPTION
              'Band % is already scheduled in another event at the same time.',
              NEW.band_id;
        END IF;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_performer_double_booking ON performance;

CREATE TRIGGER trg_performer_double_booking
BEFORE INSERT OR UPDATE ON performance
FOR EACH ROW
EXECUTE FUNCTION prevent_performer_double_booking();

CREATE OR REPLACE FUNCTION check_performance_overlap_and_breaks()
RETURNS TRIGGER AS $$
DECLARE
  prev_end   TIMESTAMP;
  next_start TIMESTAMP;
  ev_start   TIMESTAMP;
  ev_end     TIMESTAMP;
BEGIN
  /* ------------------------------------------------------------------
     0)  Make sure the performance window is inside the event window
  ------------------------------------------------------------------ */
  SELECT start_timestamp, end_timestamp
    INTO ev_start, ev_end
  FROM event
  WHERE event_id = NEW.event_id;

  IF NEW.start_time < ev_start OR NEW.end_time   > ev_end THEN
    RAISE EXCEPTION
      'Performance "%" [%→%] falls outside event % window [%→%]',
      NEW.name, NEW.start_time, NEW.end_time, NEW.event_id, ev_start, ev_end;
  END IF;

  -- Check for performances overlap on the same event
  IF EXISTS (
    SELECT 1
    FROM performance p
    WHERE p.event_id = NEW.event_id
      AND p.performance_id <> NEW.performance_id
      AND p.start_time <  NEW.end_time
      AND p.end_time   >  NEW.start_time
  ) THEN
    RAISE EXCEPTION
      'Performance "%" [%→%] overlaps with existing slot on event %',
      NEW.name, NEW.start_time, NEW.end_time, NEW.event_id;
  END IF;

  -- 1) Find the previous performance’s end_time (exclude self)
  SELECT end_time
    INTO prev_end
  FROM performance
  WHERE event_id     = NEW.event_id
    AND performance_id <> NEW.performance_id
    AND end_time    <= NEW.start_time
  ORDER BY end_time DESC
  LIMIT 1;

  IF prev_end IS NOT NULL THEN
    IF NEW.start_time - prev_end < INTERVAL '5 minutes' THEN
      RAISE EXCEPTION 'Break too short: % to % is under 5 minutes',
        prev_end, NEW.start_time;
    ELSIF NEW.start_time - prev_end > INTERVAL '30 minutes' THEN
      RAISE EXCEPTION 'Break too long: % to % exceeds 30 minutes',
        prev_end, NEW.start_time;
    END IF;
  END IF;

  -- 2) Find the next performance’s start_time (exclude self)
  SELECT start_time
    INTO next_start
  FROM performance
  WHERE event_id      = NEW.event_id
    AND performance_id <> NEW.performance_id
    AND start_time   >= NEW.end_time
  ORDER BY start_time
  LIMIT 1;

  IF next_start IS NOT NULL THEN
    IF next_start - NEW.end_time < INTERVAL '5 minutes' THEN
      RAISE EXCEPTION 'Break too short: % to % is under 5 minutes',
        NEW.end_time, next_start;
    ELSIF next_start - NEW.end_time > INTERVAL '30 minutes' THEN
      RAISE EXCEPTION 'Break too long: % to % exceeds 30 minutes',
        NEW.end_time, next_start;
    END IF;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_check_overlap_and_breaks ON performance;

CREATE TRIGGER trg_check_overlap_and_breaks
BEFORE INSERT OR UPDATE ON performance
FOR EACH ROW
EXECUTE FUNCTION check_performance_overlap_and_breaks();


/* ---------------------------------------------------------------
   Block an artist or band that has already performed
   in each of the three immediately-preceding festival years
   from being booked again this year.
---------------------------------------------------------------- */
CREATE OR REPLACE FUNCTION check_performer_fourth_consecutive_year()
RETURNS TRIGGER AS $$
DECLARE
    curr_year  INT;
    prev_count INT;
BEGIN
    /*-----------------------------------------------------------
      1.  Determine the festival year of the performance
    -----------------------------------------------------------*/
    SELECT f.year
      INTO curr_year
    FROM event     e
    JOIN festival  f ON f.festival_id = e.festival_id
    WHERE e.event_id = NEW.event_id;

    /*-----------------------------------------------------------
      2.  Decide whether the performer is an artist or a band
    -----------------------------------------------------------*/
    IF NEW.artist_id IS NOT NULL THEN
        /* Count distinct years (current_year-1 .. -3)
           where THIS artist has already performed               */
        SELECT COUNT(DISTINCT f.year)
          INTO prev_count
        FROM performance p
        JOIN event      e ON p.event_id = e.event_id
        JOIN festival   f ON e.festival_id = f.festival_id
        WHERE p.artist_id = NEW.artist_id
          AND f.year      IN (curr_year-1, curr_year-2, curr_year-3)
          AND p.performance_id <> NEW.performance_id;  -- exclude self on UPDATE

        IF prev_count = 3 THEN
            RAISE EXCEPTION
              'Artist % has already performed in the last three consecutive festival years; cannot book a fourth (%).',
              NEW.artist_id, curr_year;
        END IF;

    ELSIF NEW.band_id IS NOT NULL THEN
        /* Same logic for a band */
        SELECT COUNT(DISTINCT f.year)
          INTO prev_count
        FROM performance p
        JOIN event      e ON p.event_id = e.event_id
        JOIN festival   f ON e.festival_id = f.festival_id
        WHERE p.band_id = NEW.band_id
          AND f.year    IN (curr_year-1, curr_year-2, curr_year-3)
          AND p.performance_id <> NEW.performance_id;

        IF prev_count = 3 THEN
            RAISE EXCEPTION
              'Band % has already performed in the last three consecutive festival years; cannot book a fourth (%).',
              NEW.band_id, curr_year;
        END IF;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_check_performer_years ON performance;

CREATE TRIGGER trg_check_performer_years
BEFORE INSERT OR UPDATE ON performance
FOR EACH ROW
EXECUTE FUNCTION check_performer_fourth_consecutive_year();


--


CREATE INDEX idx_artist_stage_name ON artist USING btree (stage_name);
CREATE UNIQUE INDEX idx_artist_instagram ON artist USING btree (instagram_profile);
CREATE INDEX idx_band_name ON band USING btree (name);
CREATE UNIQUE INDEX idx_band_instagram ON band USING btree (instagram_profile);
CREATE INDEX idx_performance_event ON performance USING btree (event_id);
CREATE INDEX idx_performance_time ON performance USING btree (start_time, end_time);
CREATE INDEX idx_band_membership_artist ON band_membership USING btree (artist_id);
CREATE INDEX idx_band_membership_band ON band_membership USING btree (band_id);
CREATE INDEX idx_genre_name ON genre USING btree (name);
CREATE INDEX idx_subgenre_name ON subgenre USING btree (name);
CREATE INDEX idx_subgenre_genre ON subgenre USING btree (genre_id);
CREATE INDEX idx_artist_genre_artist ON artist_genre (artist_id);
CREATE INDEX idx_artist_genre_genre ON artist_genre (genre_id);
CREATE INDEX idx_artist_genre_subgenre ON artist_genre (subgenre_id);
CREATE INDEX idx_band_genre_band ON band_genre (band_id);
CREATE INDEX idx_band_genre_genre ON band_genre (genre_id);
CREATE INDEX idx_band_genre_subgenre ON band_genre (subgenre_id);



--Add control over the duplicates for
ALTER TABLE band_membership ADD CONSTRAINT unique_band_membership UNIQUE (artist_id, band_id);
ALTER TABLE subgenre ADD CONSTRAINT unique_subgenre_genre UNIQUE (genre_id, name);


CREATE TABLE ticket_category (
    ticket_category_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);

CREATE TABLE payment_method (
    payment_method_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);

CREATE TABLE visitor (
    visitor_id SERIAL PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    contact_info VARCHAR(255),
    date_of_birth DATE NOT NULL
);

CREATE TABLE ticket (
    ticket_id SERIAL PRIMARY KEY,
    event_id INT NOT NULL REFERENCES event(event_id),
    visitor_id INT REFERENCES visitor(visitor_id),
    purchase_date DATE,
    ticket_category_id INT NOT NULL REFERENCES ticket_category(ticket_category_id),
    cost NUMERIC(10,2) NOT NULL,
    payment_method_id INT REFERENCES payment_method(payment_method_id),
    ean13_code CHAR(13) NOT NULL,
    UNIQUE (ean13_code),
    used BOOLEAN NOT NULL DEFAULT FALSE,
    UNIQUE (visitor_id, event_id)
);


-- 1. Create trigger function to enforce capacity for sold tickets
CREATE OR REPLACE FUNCTION check_ticket_capacity()
RETURNS TRIGGER AS $$
DECLARE
    sold_count INT;
    capacity   INT;
BEGIN
    -- Lookup the stage capacity for this event
    SELECT s.max_capacity
      INTO capacity
    FROM event e
    JOIN stage s ON e.stage_id = s.stage_id
    WHERE e.event_id = NEW.event_id;

    -- Count existing sold tickets for the event, excluding this row if it exists
    SELECT COUNT(*)
      INTO sold_count
    FROM ticket t
    WHERE t.event_id = NEW.event_id
      AND t.visitor_id IS NOT NULL
      AND t.ticket_id  <> NEW.ticket_id;

    -- If this new/updated ticket is sold, include it in the tally
    IF NEW.visitor_id IS NOT NULL THEN
        sold_count := sold_count + 1;
    END IF;

    -- Enforce: sold_count must not exceed capacity
    IF sold_count > capacity THEN
        RAISE EXCEPTION
          'Cannot sell % tickets for event %, capacity is %.',
          sold_count, NEW.event_id, capacity;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_check_ticket_capacity ON ticket;
-- 2. Attach the trigger to run before each insert or update on ticket
CREATE TRIGGER trg_check_ticket_capacity
BEFORE INSERT OR UPDATE ON ticket
FOR EACH ROW
EXECUTE FUNCTION check_ticket_capacity();


-- Enforce VIP tickets to be 10% of max_capacity
CREATE OR REPLACE FUNCTION enforce_vip_ticket_limit()
RETURNS TRIGGER AS $$
DECLARE
    capacity  INT;
    vip_limit INT;
    vip_count INT;
BEGIN
    -- Only enforce for VIP tickets (category_id = 2)
    IF NEW.ticket_category_id <> 2 THEN
        RETURN NEW;
    END IF;

    -- A. Fetch stage capacity for this event
    SELECT s.max_capacity
      INTO capacity
    FROM event e
    JOIN stage s ON e.stage_id = s.stage_id
    WHERE e.event_id = NEW.event_id;

    -- B. Count existing VIP tickets for this event (unsold + sold, exclude self on UPDATE)
    SELECT COUNT(*)
      INTO vip_count
    FROM ticket t
    WHERE t.event_id = NEW.event_id
      AND t.ticket_category_id = 2
      AND t.ticket_id <> NEW.ticket_id;

    -- C. Include the new/updated ticket
    vip_count := vip_count + 1;

    -- D. Compute 10% limit (ceiling)
    vip_limit := CEIL(capacity * 0.10);

    -- E. Enforce
    IF vip_count > vip_limit THEN
        RAISE EXCEPTION
          'Cannot have % VIP tickets for event %: limit is % (10%% of %).',
          vip_count, NEW.event_id, vip_limit, capacity;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_check_vip_limit ON ticket;

CREATE TRIGGER trg_check_vip_limit
BEFORE INSERT OR UPDATE ON ticket
FOR EACH ROW
EXECUTE FUNCTION enforce_vip_ticket_limit();


CREATE TABLE likert_value (
    likert_value_id SERIAL PRIMARY KEY,
    label VARCHAR(255) NOT NULL
);

CREATE TABLE performance_rating (
    rating_id SERIAL PRIMARY KEY,
    performance_id INT NOT NULL REFERENCES performance(performance_id) ON DELETE CASCADE,
    visitor_id INT NOT NULL REFERENCES visitor(visitor_id) ON DELETE CASCADE,
    rating_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    artist_performance_rating INT REFERENCES likert_value(likert_value_id),
    sound_lighting_rating INT REFERENCES likert_value(likert_value_id),
    stage_presence_rating INT REFERENCES likert_value(likert_value_id),
    organization_rating INT REFERENCES likert_value(likert_value_id),
    overall_impression_rating INT REFERENCES likert_value(likert_value_id),
    UNIQUE (performance_id, visitor_id)
);

