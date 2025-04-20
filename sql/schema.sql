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
    year INT GENERATED ALWAYS AS (EXTRACT(YEAR FROM start_date)::int) STORED,
    UNIQUE (year),
    FOREIGN KEY (location_id) REFERENCES location(location_id)
);

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
    FOREIGN KEY (stage_id) REFERENCES stage(stage_id),
    FOREIGN KEY (equipment_id) REFERENCES equipment(equipment_id)
);

CREATE TABLE staff_category (
    staff_category_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description VARCHAR(255)
);

CREATE TABLE staff_type (
    staff_type_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description VARCHAR(255),
    staff_category_id INT NOT NULL,
    FOREIGN KEY (staff_category_id) REFERENCES staff_category(staff_category_id)
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
          AND e.event_id <> COALESCE(NEW.event_id, -1)
    ) THEN
        RAISE EXCEPTION 'Stage % is already booked in the given time range.', NEW.stage_id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_check_overlap_timestamp
BEFORE INSERT OR UPDATE ON event
FOR EACH ROW
EXECUTE FUNCTION check_event_overlap_timestamp();

CREATE TABLE event_staff (
    event_id INT NOT NULL,
    staff_id INT NOT NULL,
    PRIMARY KEY (event_id, staff_id),
    FOREIGN KEY (event_id) REFERENCES event(event_id),
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id)
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
           AND e.event_id <> COALESCE(NEW.event_id, -1)
           AND new_event.start_timestamp < e.end_timestamp
           AND new_event.end_timestamp > e.start_timestamp
    ) THEN
        RAISE EXCEPTION 'Staff member % is already assigned to an overlapping event.', NEW.staff_id;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_check_staff_overlap
BEFORE INSERT OR UPDATE ON event_staff
FOR EACH ROW
EXECUTE FUNCTION check_staff_event_overlap();


-- USE IT AS CONSTRAINT TRIGGER, DEFERRABLE INITIALLY DEFERRED
-- 1. Create the trigger function that enforces the minimum staff coverage
CREATE OR REPLACE FUNCTION check_event_staff_coverage()
RETURNS TRIGGER AS $$
DECLARE
    evt_id     INT;
    cap        INT;
    sec_req    INT;
    sup_req    INT;
    sec_count  INT;
    sup_count  INT;
BEGIN
    -- Determine which event_id to check (NEW for insert/update, OLD for delete)
    IF (TG_OP = 'DELETE') THEN
        evt_id := OLD.event_id;
    ELSE
        evt_id := NEW.event_id;
    END IF;

    -- Fetch the stage capacity for that event
    SELECT s.max_capacity
      INTO cap
    FROM event e
    JOIN stage s ON e.stage_id = s.stage_id
    WHERE e.event_id = evt_id;

    -- Calculate required numbers (5% for security, 2% for support)
    sec_req := CEIL(cap * 0.05)::INT;
    sup_req := CEIL(cap * 0.02)::INT;

    -- Count assigned security staff
    SELECT COUNT(*) INTO sec_count
    FROM event_staff es
    JOIN staff st            ON es.staff_id = st.staff_id
    JOIN staff_category sc   ON st.staff_category_id = sc.staff_category_id
    WHERE es.event_id = evt_id
      AND sc.name = 'Security';

    -- Count assigned support staff
    SELECT COUNT(*) INTO sup_count
    FROM event_staff es
    JOIN staff st            ON es.staff_id = st.staff_id
    JOIN staff_category sc   ON st.staff_category_id = sc.staff_category_id
    WHERE es.event_id = evt_id
      AND sc.name = 'Support';

    -- Enforce minimums
    IF sec_count < sec_req THEN
        RAISE EXCEPTION
          'Event %: only % security staff assigned, but at least % required (5%% of capacity %)',
          evt_id, sec_count, sec_req, cap;
    END IF;
    IF sup_count < sup_req THEN
        RAISE EXCEPTION
          'Event %: only % support staff assigned, but at least % required (2%% of capacity %)',
          evt_id, sup_count, sup_req, cap;
    END IF;

    RETURN NEW;
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
  FOREIGN KEY (genre_id) references genre (genre_id)
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
  real_name varchar(255),
  stage_name varchar(255) NOT NULL,
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
    FOREIGN KEY (genre_id) REFERENCES genre (genre_id),
    FOREIGN KEY (subgenre_id) REFERENCES subgenre (subgenre_id)
);

CREATE TABLE band_genre (
    band_id INTEGER NOT NULL,
    genre_id INTEGER NOT NULL,
    subgenre_id INTEGER,
    PRIMARY KEY (band_id, genre_id, subgenre_id),
    FOREIGN KEY (band_id) REFERENCES band (band_id) ON DELETE CASCADE,
    FOREIGN KEY (genre_id) REFERENCES genre (genre_id),
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
    name varchar(40) NOT NULL,
    event_id integer NOT NULL,
    artist_id integer,
    band_id integer,
    performance_type text NOT NULL,
    start_time time NOT NULL,
    end_time time NOT NULL,
    duration integer DEFAULT 0 NOT NULL, --in minutes
    stage_id INTEGER NOT NULL, --Added here for better tracking for the overlapping performances of artists and brands
    FOREIGN KEY (artist_id) references artist (artist_id),
    FOREIGN KEY (band_id) references band (band_id),
    CHECK (start_time < end_time),
    CHECK (end_time - start_time < INTERVAL '3 hours'),
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

CREATE TRIGGER trg_validate_band_genre
BEFORE INSERT OR UPDATE ON band_genre
FOR EACH ROW
EXECUTE FUNCTION validate_band_genre_subgenre();


CREATE OR REPLACE FUNCTION prevent_performance_deletion()
RETURNS TRIGGER AS $$
BEGIN
    RAISE EXCEPTION 'Performance cannot be deleted!';
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER prevent_delete_performance
BEFORE DELETE ON performance
FOR EACH ROW
EXECUTE FUNCTION prevent_performance_deletion();



CREATE OR REPLACE FUNCTION prevent_simultaneous_performances()
RETURNS TRIGGER AS $$
DECLARE
    overlapping_count INTEGER;
BEGIN
    -- Check if artist has another performance at the same time
    SELECT COUNT(*) INTO overlapping_count
    FROM performance
    WHERE event_id = NEW.event_id
      AND start_time < NEW.end_time
      AND end_time > NEW.start_time
      AND stage_id <> NEW.stage_id -- Ensure different stage
      AND (
          artist_id = NEW.artist_id OR
          band_id = NEW.band_id OR
          EXISTS (
              SELECT 1 FROM band_membership
              WHERE band_membership.artist_id = NEW.artist_id
              AND band_membership.band_id = performance.band_id
          ) -- Ensure artists' bands aren't double-booked
      );
    IF overlapping_count > 0 THEN
        RAISE EXCEPTION 'Artist or band cannot perform on two stages at the same time!';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER check_simultaneous_performance
BEFORE INSERT OR UPDATE ON performance
FOR EACH ROW
EXECUTE FUNCTION prevent_simultaneous_performances();








--At least 5 minutes and at most 30 minutes break between two consecutive performances.
-- The system checks for the latest performance on the same event_id and stage_id.
--If there is a previous performance
--Ensures at least 5 minutes of break.
--Ensures at most 30 minutes of break. Else an error is raised,

CREATE OR REPLACE FUNCTION enforce_break_between_performances()
RETURNS TRIGGER AS $$
DECLARE
    prev_end_time TIME;
BEGIN
    -- Find the end_time of the last performance on the same stage and event
    SELECT end_time INTO prev_end_time
    FROM performance
    WHERE event_id = NEW.event_id
      AND stage_id = NEW.stage_id
      AND end_time <= NEW.start_time
    ORDER BY end_time DESC
    LIMIT 1;

    -- If there is a previous performance, check break duration
    IF prev_end_time IS NOT NULL THEN
        IF NEW.start_time - prev_end_time < INTERVAL '5 minutes' THEN
            RAISE EXCEPTION 'Break between performances must be at least 5 minutes!';
        ELSIF NEW.start_time - prev_end_time > INTERVAL '30 minutes' THEN
            RAISE EXCEPTION 'Break between performances must not exceed 30 minutes!';
        END IF;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER check_performance_breaks
BEFORE INSERT OR UPDATE ON performance
FOR EACH ROW
EXECUTE FUNCTION enforce_break_between_performances();

--


CREATE INDEX idx_artist_stage_name ON artist USING btree (stage_name);
CREATE UNIQUE INDEX idx_artist_instagram ON artist USING btree (instagram_profile);
CREATE INDEX idx_band_name ON band USING btree (name);
CREATE UNIQUE INDEX idx_band_instagram ON band USING btree (instagram_profile);
CREATE INDEX idx_performance_event ON performance USING btree (event_id);
CREATE INDEX idx_performance_stage ON performance USING btree (stage_id);
CREATE INDEX idx_performance_time ON performance USING btree (start_time, end_time);
CREATE INDEX idx_performance_conflict ON performance USING btree (artist_id, band_id, stage_id) WHERE artist_id IS NOT NULL OR band_id IS NOT NULL;
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
ALTER TABLE performance ADD CONSTRAINT unique_performance_event_stage UNIQUE (event_id, stage_id, start_time);
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

CREATE TABLE likert_value (
    likert_value_id SERIAL PRIMARY KEY,
    label VARCHAR(255) NOT NULL
);

CREATE TABLE performance_rating (
    rating_id                     SERIAL PRIMARY KEY,
    performance_id                INT   NOT NULL REFERENCES event(event_id),
    visitor_id                    INT   NOT NULL REFERENCES visitor(visitor_id),
    rating_date                   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    artist_performance_rating     INT   REFERENCES likert_value(likert_value_id),
    sound_lighting_rating         INT   REFERENCES likert_value(likert_value_id),
    stage_presence_rating         INT   REFERENCES likert_value(likert_value_id),
    organization_rating           INT   REFERENCES likert_value(likert_value_id),
    overall_impression_rating     INT   REFERENCES likert_value(likert_value_id),
    UNIQUE (performance_id, visitor_id)
);

