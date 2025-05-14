/* Pulse University Festival Database */
/* install.sql */

SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = public, pg_catalog;

-- Drop all tables
DROP TABLE IF EXISTS
    stage_equipment,
    event_staff,
    performance_rating,
    performance,
    resale_queue,
    buyer_queue,
    ticket,
    staff,
    staff_type,
    staff_category,
    experience_level,
    event,
    festival,
    stage,
    location,
    media,
    artist_genre,
    band_genre,
    band_membership,
    artist,
    band,
    subgenre,
    genre,
    ticket_category,
    payment_method,
    visitor,
    equipment,
    continent,
    likert_value
    CASCADE;

-- Drop sequences
DROP SEQUENCE IF EXISTS artist_id_seq CASCADE;
DROP SEQUENCE IF EXISTS band_id_seq CASCADE;
DROP SEQUENCE IF EXISTS performance_id_seq CASCADE;

CREATE TABLE continent (
    continent_id SERIAL PRIMARY KEY,
    name         VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE location (
    location_id  SERIAL PRIMARY KEY,
    name         VARCHAR(255) NOT NULL,
    address      VARCHAR(255) NOT NULL,
    city         VARCHAR(255) NOT NULL,
    country      VARCHAR(255) NOT NULL,
    continent_id INT          NOT NULL,
    coordinates  POINT        NULL,
    FOREIGN KEY (continent_id) REFERENCES continent (continent_id)
);

CREATE TABLE festival (
    festival_id SERIAL PRIMARY KEY,
    name        VARCHAR(255) NOT NULL,
    start_date  DATE         NOT NULL,
    end_date    DATE         NOT NULL,
    location_id INT          NOT NULL,
    UNIQUE (location_id),
    year        INT GENERATED ALWAYS AS (EXTRACT(YEAR FROM start_date)::INT) STORED,
    UNIQUE (year),
    FOREIGN KEY (location_id) REFERENCES location (location_id)
);

CREATE OR REPLACE FUNCTION prevent_festival_deletion()
    RETURNS TRIGGER AS $$
BEGIN
    IF TRUE THEN
        RAISE EXCEPTION 'Festival cannot be deleted!';
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_block_festival_delete ON festival;

CREATE TRIGGER trg_block_festival_delete
    BEFORE DELETE
    ON festival
    FOR EACH ROW
EXECUTE FUNCTION prevent_festival_deletion();

CREATE TABLE stage (
    stage_id     SERIAL PRIMARY KEY,
    name         VARCHAR(255) NOT NULL,
    description  TEXT,
    max_capacity INT          NOT NULL CHECK (max_capacity > 0)
);

CREATE TABLE equipment (
    equipment_id SERIAL PRIMARY KEY,
    name         VARCHAR(255) NOT NULL,
    description  TEXT
);

CREATE TABLE stage_equipment (
    stage_id     INT NOT NULL,
    equipment_id INT NOT NULL,
    quantity     INT NOT NULL CHECK (quantity >= 0),
    PRIMARY KEY (stage_id, equipment_id),
    FOREIGN KEY (stage_id) REFERENCES stage (stage_id) ON DELETE CASCADE,
    FOREIGN KEY (equipment_id) REFERENCES equipment (equipment_id) ON DELETE CASCADE
);

CREATE TABLE staff_category (
    staff_category_id SERIAL PRIMARY KEY,
    name              VARCHAR(255) NOT NULL,
    description       TEXT
);

CREATE TABLE staff_type (
    staff_type_id     SERIAL PRIMARY KEY,
    name              VARCHAR(255) NOT NULL,
    description       TEXT,
    staff_category_id INT          NOT NULL,
    FOREIGN KEY (staff_category_id) REFERENCES staff_category (staff_category_id) ON DELETE CASCADE
);

CREATE TABLE experience_level (
    experience_level_id SERIAL PRIMARY KEY,
    name                VARCHAR(255) NOT NULL,
    level               INT          NOT NULL
);

CREATE TABLE staff (
    staff_id            SERIAL PRIMARY KEY,
    first_name          VARCHAR(255) NOT NULL,
    last_name           VARCHAR(255) NOT NULL,
    date_of_birth       DATE         NOT NULL,
    staff_category_id   INT          NOT NULL,
    staff_type_id       INT,
    experience_level_id INT          NOT NULL,
    FOREIGN KEY (staff_category_id) REFERENCES staff_category (staff_category_id),
    FOREIGN KEY (staff_type_id) REFERENCES staff_type (staff_type_id),
    FOREIGN KEY (experience_level_id) REFERENCES experience_level (experience_level_id)
);

CREATE OR REPLACE FUNCTION check_staff_type_category()
    RETURNS TRIGGER AS $$
DECLARE
    st_cat INT;
BEGIN
    IF NEW.staff_type_id IS NOT NULL THEN
        SELECT staff_category_id
          INTO st_cat
          FROM staff_type
         WHERE staff_type_id = NEW.staff_type_id;

        IF st_cat <> NEW.staff_category_id THEN
            RAISE EXCEPTION
                'Staff type % belongs to category %, but staff has category %',
                NEW.staff_type_id, st_cat, NEW.staff_category_id;
        END IF;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_check_staff_type_category ON staff;

CREATE TRIGGER trg_check_staff_type_category
    BEFORE INSERT OR UPDATE
    ON staff
    FOR EACH ROW
EXECUTE FUNCTION check_staff_type_category();

CREATE TABLE event (
    event_id        SERIAL PRIMARY KEY,
    festival_id     INT          NOT NULL,
    name            VARCHAR(255) NOT NULL,
    start_timestamp TIMESTAMP    NOT NULL,
    end_timestamp   TIMESTAMP    NOT NULL,
    stage_id        INT          NOT NULL,
    sold_out        BOOLEAN      NOT NULL DEFAULT FALSE,
    FOREIGN KEY (festival_id) REFERENCES festival (festival_id),
    FOREIGN KEY (stage_id) REFERENCES stage (stage_id)
);

CREATE OR REPLACE FUNCTION check_event_within_festival_dates()
    RETURNS TRIGGER AS $$
DECLARE
    fest_start_ts TIMESTAMP; -- festival starts at 00:00
    fest_end_ts   TIMESTAMP; -- festival ends at 23:59:59
BEGIN
    SELECT start_date,
           end_date + INTERVAL '1 day' - INTERVAL '1 second'
      INTO fest_start_ts,
          fest_end_ts
      FROM festival
     WHERE festival_id = NEW.festival_id;

    IF NEW.start_timestamp < fest_start_ts
        OR NEW.end_timestamp > fest_end_ts
    THEN
        RAISE EXCEPTION
            'Event "%" [%→%] falls outside festival % window [%→%]',
            NEW.event_id,
            NEW.start_timestamp, NEW.end_timestamp,
            NEW.festival_id, fest_start_ts, fest_end_ts;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_check_event_festival_range ON event;

CREATE TRIGGER trg_check_event_festival_range
    BEFORE INSERT OR UPDATE
    ON event
    FOR EACH ROW
EXECUTE FUNCTION check_event_within_festival_dates();

CREATE OR REPLACE FUNCTION prevent_event_deletion()
    RETURNS TRIGGER AS $$
BEGIN
    IF TRUE THEN
        RAISE EXCEPTION 'Event cannot be deleted!';
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_block_event_delete ON event;

CREATE TRIGGER trg_block_event_delete
    BEFORE DELETE
    ON event
    FOR EACH ROW
EXECUTE FUNCTION prevent_event_deletion();

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
    BEFORE INSERT OR UPDATE
    ON event
    FOR EACH ROW
EXECUTE FUNCTION check_event_overlap_timestamp();

CREATE TABLE event_staff (
    event_id INT NOT NULL,
    staff_id INT NOT NULL,
    PRIMARY KEY (event_id, staff_id),
    FOREIGN KEY (event_id) REFERENCES event (event_id) ON DELETE CASCADE,
    FOREIGN KEY (staff_id) REFERENCES staff (staff_id) ON DELETE CASCADE
);

CREATE OR REPLACE FUNCTION check_staff_event_overlap()
    RETURNS TRIGGER AS $$
DECLARE
    new_event RECORD;
BEGIN
    SELECT start_timestamp, end_timestamp
      INTO new_event
      FROM event
     WHERE event_id = NEW.event_id;

    IF EXISTS (
        SELECT 1
          FROM event_staff es
          JOIN event e ON es.event_id = e.event_id
         WHERE es.staff_id = NEW.staff_id
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
    BEFORE INSERT OR UPDATE
    ON event_staff
    FOR EACH ROW
EXECUTE FUNCTION check_staff_event_overlap();

CREATE OR REPLACE FUNCTION check_event_staff_coverage(p_event_id INT)
    RETURNS VOID AS $$
DECLARE
    cap       INT;
    sec_req   INT;
    sup_req   INT;
    sec_count INT;
    sup_count INT;
BEGIN
    SELECT s.max_capacity
      INTO cap
      FROM event e
      JOIN stage s ON s.stage_id = e.stage_id
     WHERE e.event_id = p_event_id;

    sec_req := CEIL(cap * 0.05)::INT;
    sup_req := CEIL(cap * 0.02)::INT;

    -- Count assigned SECURITY staff
    SELECT COUNT(*)
      INTO sec_count
      FROM event_staff es
      JOIN staff st ON st.staff_id = es.staff_id
     WHERE es.event_id = p_event_id
       AND st.staff_category_id = 2;

    -- Count assigned SUPPORT staff
    SELECT COUNT(*)
      INTO sup_count
      FROM event_staff es
      JOIN staff st ON st.staff_id = es.staff_id
     WHERE es.event_id = p_event_id
       AND st.staff_category_id = 3;

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

CREATE TABLE genre (
    genre_id SERIAL PRIMARY KEY,
    name     VARCHAR(255) NOT NULL
);

CREATE TABLE subgenre (
    subgenre_id SERIAL PRIMARY KEY,
    name        VARCHAR(255) NOT NULL,
    genre_id    INTEGER      NOT NULL,
    FOREIGN KEY (genre_id) REFERENCES genre (genre_id) ON DELETE CASCADE
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

CREATE TABLE artist (
    artist_id         INTEGER DEFAULT NEXTVAL('artist_id_seq'::regclass) PRIMARY KEY,
    real_name         VARCHAR(255) NOT NULL,
    stage_name        VARCHAR(255),
    date_of_birth     DATE         NOT NULL,
    website           TEXT,
    instagram_profile VARCHAR(255) UNIQUE
);

CREATE TABLE band (
    band_id           INTEGER DEFAULT NEXTVAL('band_id_seq'::regclass) PRIMARY KEY,
    name              VARCHAR(255),
    date_created      DATE NOT NULL,
    website           TEXT,
    instagram_profile VARCHAR(255) UNIQUE
);

CREATE TABLE artist_genre (
    artist_id   INTEGER NOT NULL,
    genre_id    INTEGER NOT NULL,
    subgenre_id INTEGER,
    PRIMARY KEY (artist_id, genre_id, subgenre_id),
    FOREIGN KEY (artist_id) REFERENCES artist (artist_id) ON DELETE CASCADE,
    FOREIGN KEY (genre_id) REFERENCES genre (genre_id) ON DELETE CASCADE,
    FOREIGN KEY (subgenre_id) REFERENCES subgenre (subgenre_id)
);

CREATE TABLE band_genre (
    band_id     INTEGER NOT NULL,
    genre_id    INTEGER NOT NULL,
    subgenre_id INTEGER,
    PRIMARY KEY (band_id, genre_id, subgenre_id),
    FOREIGN KEY (band_id) REFERENCES band (band_id) ON DELETE CASCADE,
    FOREIGN KEY (genre_id) REFERENCES genre (genre_id) ON DELETE CASCADE,
    FOREIGN KEY (subgenre_id) REFERENCES subgenre (subgenre_id)
);

CREATE TABLE band_membership (
    artist_id INTEGER NOT NULL,
    band_id   INTEGER NOT NULL,
    PRIMARY KEY (artist_id, band_id),
    FOREIGN KEY (artist_id) REFERENCES artist (artist_id) ON DELETE CASCADE,
    FOREIGN KEY (band_id) REFERENCES band (band_id) ON DELETE CASCADE
);

CREATE SEQUENCE performance_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

CREATE TABLE performance (
    performance_id   INTEGER DEFAULT NEXTVAL('performance_id_seq'::regclass) PRIMARY KEY,
    name             VARCHAR(255) NOT NULL,
    event_id         INTEGER      NOT NULL,
    artist_id        INTEGER,
    band_id          INTEGER,
    performance_type VARCHAR(255) NOT NULL,
    start_time       TIMESTAMP    NOT NULL,
    end_time         TIMESTAMP    NOT NULL,
    duration         INTEGER GENERATED ALWAYS AS ((EXTRACT(EPOCH FROM end_time - start_time) / 60)::INTEGER) STORED,
    FOREIGN KEY (artist_id) REFERENCES artist (artist_id),
    FOREIGN KEY (band_id) REFERENCES band (band_id),
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
        SELECT COUNT(*)
          INTO valid_match
          FROM subgenre
         WHERE subgenre_id = NEW.subgenre_id
           AND genre_id = NEW.genre_id;

        IF valid_match = 0 THEN
            RAISE EXCEPTION 'Subgenre % does not belong to Genre % in artist_genre.',
                NEW.subgenre_id, NEW.genre_id;
        END IF;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_validate_artist_genre ON artist_genre;

CREATE TRIGGER trg_validate_artist_genre
    BEFORE INSERT OR UPDATE
    ON artist_genre
    FOR EACH ROW
EXECUTE FUNCTION validate_artist_genre_subgenre();

CREATE OR REPLACE FUNCTION validate_band_genre_subgenre()
    RETURNS TRIGGER AS $$
DECLARE
    valid_match INTEGER;
BEGIN
    IF NEW.subgenre_id IS NOT NULL THEN
        SELECT COUNT(*)
          INTO valid_match
          FROM subgenre
         WHERE subgenre_id = NEW.subgenre_id
           AND genre_id = NEW.genre_id;

        IF valid_match = 0 THEN
            RAISE EXCEPTION 'Subgenre % does not belong to Genre % in band_genre.',
                NEW.subgenre_id, NEW.genre_id;
        END IF;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_validate_band_genre ON band_genre;

CREATE TRIGGER trg_validate_band_genre
    BEFORE INSERT OR UPDATE
    ON band_genre
    FOR EACH ROW
EXECUTE FUNCTION validate_band_genre_subgenre();

CREATE OR REPLACE FUNCTION prevent_middle_performance_deletion()
    RETURNS TRIGGER AS $$
DECLARE
    first_perf INT;
    last_perf  INT;
BEGIN
    SELECT p.performance_id
      INTO first_perf
      FROM performance p
     WHERE p.event_id = OLD.event_id
     ORDER BY p.start_time
     LIMIT 1;

    SELECT p.performance_id
      INTO last_perf
      FROM performance p
     WHERE p.event_id = OLD.event_id
     ORDER BY p.start_time DESC
     LIMIT 1;

    IF OLD.performance_id <> first_perf
        AND OLD.performance_id <> last_perf
    THEN
        RAISE EXCEPTION
            'Cannot delete performance %: only first (%) or last (%) of event % may be removed.',
            OLD.performance_id, first_perf, last_perf, OLD.event_id;
    END IF;

    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_prevent_middle_delete ON performance;

CREATE TRIGGER trg_prevent_middle_delete
    BEFORE DELETE
    ON performance
    FOR EACH ROW
EXECUTE FUNCTION prevent_middle_performance_deletion();

CREATE OR REPLACE FUNCTION prevent_performer_double_booking()
    RETURNS TRIGGER AS $$
BEGIN
    -- Check ARTIST
    IF NEW.artist_id IS NOT NULL THEN
        IF EXISTS (
            SELECT 1
              FROM performance p
             WHERE p.artist_id = NEW.artist_id
               AND p.performance_id <> NEW.performance_id
               AND p.event_id <> NEW.event_id
               AND p.start_time < NEW.end_time
               AND p.end_time > NEW.start_time
        ) THEN
            RAISE EXCEPTION
                'Artist % is already scheduled in another event at the same time.',
                NEW.artist_id;
        END IF;

        -- Check BAND
    ELSIF NEW.band_id IS NOT NULL THEN
        IF EXISTS (
            SELECT 1
              FROM performance p
             WHERE p.band_id = NEW.band_id
               AND p.performance_id <> NEW.performance_id
               AND p.event_id <> NEW.event_id
               AND p.start_time < NEW.end_time
               AND p.end_time > NEW.start_time
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
    BEFORE INSERT OR UPDATE
    ON performance
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
    -- Check if performance is within event time window
    SELECT start_timestamp, end_timestamp
      INTO ev_start, ev_end
      FROM event
     WHERE event_id = NEW.event_id;

    IF NEW.start_time < ev_start OR NEW.end_time > ev_end THEN
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
           AND p.start_time < NEW.end_time
           AND p.end_time > NEW.start_time
    ) THEN
        RAISE EXCEPTION
            'Performance "%" [%→%] overlaps with existing slot on event %',
            NEW.name, NEW.start_time, NEW.end_time, NEW.event_id;
    END IF;

    -- Check for break before
    SELECT end_time
      INTO prev_end
      FROM performance
     WHERE event_id = NEW.event_id
       AND performance_id <> NEW.performance_id
       AND end_time <= NEW.start_time
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

    -- Check for break after
    SELECT start_time
      INTO next_start
      FROM performance
     WHERE event_id = NEW.event_id
       AND performance_id <> NEW.performance_id
       AND start_time >= NEW.end_time
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
    BEFORE INSERT OR UPDATE
    ON performance
    FOR EACH ROW
EXECUTE FUNCTION check_performance_overlap_and_breaks();

CREATE OR REPLACE FUNCTION check_performer_fourth_consecutive_year()
    RETURNS TRIGGER AS $$
DECLARE
    curr_year  INT;
    prev_count INT;
BEGIN
    -- Find the year of festival
    SELECT f.year
      INTO curr_year
      FROM event e
      JOIN festival f ON f.festival_id = e.festival_id
     WHERE e.event_id = NEW.event_id;

    IF NEW.artist_id IS NOT NULL THEN
        -- Check if artist has performed in the last three years
        SELECT COUNT(DISTINCT f.year)
          INTO prev_count
          FROM performance p
          JOIN event e ON p.event_id = e.event_id
          JOIN festival f ON e.festival_id = f.festival_id
         WHERE p.artist_id = NEW.artist_id
           AND f.year IN (curr_year - 1, curr_year - 2, curr_year - 3)
           AND p.performance_id <> NEW.performance_id;

        IF prev_count = 3 THEN
            RAISE EXCEPTION
                'Artist % has already performed in the last three consecutive festival years.',
                NEW.artist_id;
        END IF;

    ELSIF NEW.band_id IS NOT NULL THEN
        -- Check if band has performed in the last three years
        SELECT COUNT(DISTINCT f.year)
          INTO prev_count
          FROM performance p
          JOIN event e ON p.event_id = e.event_id
          JOIN festival f ON e.festival_id = f.festival_id
         WHERE p.band_id = NEW.band_id
           AND f.year IN (curr_year - 1, curr_year - 2, curr_year - 3)
           AND p.performance_id <> NEW.performance_id;

        IF prev_count = 3 THEN
            RAISE EXCEPTION
                'Band % has already performed in the last three consecutive festival years.',
                NEW.band_id;
        END IF;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_check_performer_years ON performance;

CREATE TRIGGER trg_check_performer_years
    BEFORE INSERT OR UPDATE
    ON performance
    FOR EACH ROW
EXECUTE FUNCTION check_performer_fourth_consecutive_year();

CREATE TABLE ticket_category (
    ticket_category_id SERIAL PRIMARY KEY,
    name               VARCHAR(255) NOT NULL
);

CREATE TABLE payment_method (
    payment_method_id SERIAL PRIMARY KEY,
    name              VARCHAR(255) NOT NULL
);

CREATE TABLE visitor (
    visitor_id    SERIAL PRIMARY KEY,
    first_name    VARCHAR(255) NOT NULL,
    last_name     VARCHAR(255) NOT NULL,
    contact_info  VARCHAR(255),
    date_of_birth DATE         NOT NULL
);

CREATE TABLE ticket (
    ticket_id          SERIAL PRIMARY KEY,
    event_id           INT            NOT NULL REFERENCES event (event_id),
    visitor_id         INT            NOT NULL REFERENCES visitor (visitor_id) ON DELETE CASCADE,
    purchase_date      TIMESTAMP      NOT NULL,
    ticket_category_id INT            NOT NULL REFERENCES ticket_category (ticket_category_id),
    cost               NUMERIC(10, 2) NOT NULL,
    payment_method_id  INT            NOT NULL REFERENCES payment_method (payment_method_id),
    ean13_code         CHAR(13)       NOT NULL,
    UNIQUE (ean13_code),
    used               BOOLEAN        NOT NULL DEFAULT FALSE,
    UNIQUE (visitor_id, event_id)
);

ALTER TABLE ticket
    DROP CONSTRAINT IF EXISTS chk_ean13_valid,
    ADD CONSTRAINT chk_ean13_valid
        CHECK (
            -- ean13_code must be 13 digits
            ean13_code ~ '^[0-9]{13}$'
                AND (
                        (SUBSTR(ean13_code, 1, 1)::INT * 1) +
                        (SUBSTR(ean13_code, 2, 1)::INT * 3) +
                        (SUBSTR(ean13_code, 3, 1)::INT * 1) +
                        (SUBSTR(ean13_code, 4, 1)::INT * 3) +
                        (SUBSTR(ean13_code, 5, 1)::INT * 1) +
                        (SUBSTR(ean13_code, 6, 1)::INT * 3) +
                        (SUBSTR(ean13_code, 7, 1)::INT * 1) +
                        (SUBSTR(ean13_code, 8, 1)::INT * 3) +
                        (SUBSTR(ean13_code, 9, 1)::INT * 1) +
                        (SUBSTR(ean13_code, 10, 1)::INT * 3) +
                        (SUBSTR(ean13_code, 11, 1)::INT * 1) +
                        (SUBSTR(ean13_code, 12, 1)::INT * 3) +
                        (SUBSTR(ean13_code, 13, 1)::INT * 1)
                        ) % 10 = 0
            );

CREATE OR REPLACE FUNCTION check_ticket_capacity()
    RETURNS TRIGGER AS $$
DECLARE
    sold_count INT;
    capacity   INT;
BEGIN
    SELECT s.max_capacity
      INTO capacity
      FROM event e
      JOIN stage s ON e.stage_id = s.stage_id
     WHERE e.event_id = NEW.event_id;

    SELECT COUNT(*)
      INTO sold_count
      FROM ticket t
     WHERE t.event_id = NEW.event_id
       AND t.ticket_id <> NEW.ticket_id;

    -- Include the new/updated ticket
    IF NEW.visitor_id IS NOT NULL THEN
        sold_count := sold_count + 1;
    END IF;

    IF sold_count > capacity THEN
        RAISE EXCEPTION
            'Cannot sell % tickets for event %, capacity is %.',
            sold_count, NEW.event_id, capacity;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_check_ticket_capacity ON ticket;

CREATE TRIGGER trg_check_ticket_capacity
    BEFORE INSERT OR UPDATE
    ON ticket
    FOR EACH ROW
EXECUTE FUNCTION check_ticket_capacity();

CREATE OR REPLACE FUNCTION enforce_vip_ticket_limit()
    RETURNS TRIGGER AS $$
DECLARE
    capacity  INT;
    vip_limit INT;
    vip_count INT;
BEGIN
    -- ticket_category_id = 2 is VIP
    IF NEW.ticket_category_id <> 2 THEN
        RETURN NEW;
    END IF;

    SELECT s.max_capacity
      INTO capacity
      FROM event e
      JOIN stage s ON e.stage_id = s.stage_id
     WHERE e.event_id = NEW.event_id;

    -- Count existing VIP tickets
    SELECT COUNT(*)
      INTO vip_count
      FROM ticket t
     WHERE t.event_id = NEW.event_id
       AND t.ticket_category_id = 2
       AND t.ticket_id <> NEW.ticket_id;

    -- Include the new/updated ticket
    vip_count := vip_count + 1;

    -- 10% of max_capacity limit
    vip_limit := CEIL(capacity * 0.10);

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
    BEFORE INSERT OR UPDATE
    ON ticket
    FOR EACH ROW
EXECUTE FUNCTION enforce_vip_ticket_limit();

CREATE OR REPLACE FUNCTION update_event_sold_out()
    RETURNS TRIGGER AS $$
DECLARE
    evt_id   INT;
    cap      INT;
    sold_cnt INT;
BEGIN
    IF TG_OP = 'DELETE' THEN
        evt_id := OLD.event_id;
    ELSE
        evt_id := NEW.event_id;
    END IF;

    SELECT s.max_capacity
      INTO cap
      FROM event e
      JOIN stage s ON s.stage_id = e.stage_id
     WHERE e.event_id = evt_id;

    SELECT COUNT(*)
      INTO sold_cnt
      FROM ticket t
     WHERE t.event_id = evt_id;

    -- Update the sold_out status
    UPDATE event
       SET sold_out = (sold_cnt >= cap)
     WHERE event_id = evt_id;

    IF TG_OP = 'DELETE' THEN
        RETURN OLD;
    ELSE
        RETURN NEW;
    END IF;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_update_event_sold_out ON ticket;

CREATE TRIGGER trg_update_event_sold_out
    AFTER INSERT OR UPDATE OR DELETE
    ON ticket
    FOR EACH ROW
EXECUTE FUNCTION update_event_sold_out();

CREATE TABLE likert_value (
    likert_value_id SERIAL PRIMARY KEY,
    label           VARCHAR(255) NOT NULL
);

CREATE TABLE performance_rating (
    rating_id                 SERIAL PRIMARY KEY,
    performance_id            INT       NOT NULL REFERENCES performance (performance_id) ON DELETE CASCADE,
    visitor_id                INT       NOT NULL REFERENCES visitor (visitor_id) ON DELETE CASCADE,
    rating_date               TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    artist_performance_rating INT REFERENCES likert_value (likert_value_id),
    sound_lighting_rating     INT REFERENCES likert_value (likert_value_id),
    stage_presence_rating     INT REFERENCES likert_value (likert_value_id),
    organization_rating       INT REFERENCES likert_value (likert_value_id),
    overall_impression_rating INT REFERENCES likert_value (likert_value_id),
    UNIQUE (performance_id, visitor_id)
);

CREATE OR REPLACE FUNCTION chk_rating_allowed()
    RETURNS TRIGGER AS $$
DECLARE
    v_event_id INT;
BEGIN
    SELECT event_id
      INTO v_event_id
      FROM performance
     WHERE performance_id = NEW.performance_id;

    IF NOT EXISTS (
        SELECT 1
          FROM ticket t
         WHERE t.event_id = v_event_id
           AND t.visitor_id = NEW.visitor_id
           AND t.used = TRUE
    ) THEN
        RAISE EXCEPTION
            'Visitor % cannot rate performance %: no used ticket for its event.',
            NEW.visitor_id, NEW.performance_id;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_chk_rating_allowed ON performance_rating;

CREATE TRIGGER trg_chk_rating_allowed
    BEFORE INSERT OR UPDATE
    ON performance_rating
    FOR EACH ROW
EXECUTE FUNCTION chk_rating_allowed();

CREATE TABLE resale_queue (
    resale_id    SERIAL PRIMARY KEY,
    ticket_id    INT       NOT NULL REFERENCES ticket (ticket_id) ON DELETE CASCADE,
    created_at   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    processed_at TIMESTAMP
);

CREATE TABLE buyer_queue (
    buyer_id           SERIAL PRIMARY KEY,
    visitor_id         INT       NOT NULL REFERENCES visitor (visitor_id) ON DELETE CASCADE,
    event_id           INT REFERENCES event (event_id),
    ticket_category_id INT REFERENCES ticket_category (ticket_category_id),
    resale_id          INT,
    created_at         TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    processed_at       TIMESTAMP,

    CONSTRAINT ck_buyer_request_exclusive
        CHECK (
            (resale_id IS NOT NULL
                AND event_id IS NULL
                AND ticket_category_id IS NULL)
                OR (resale_id IS NULL
                AND event_id IS NOT NULL
                AND ticket_category_id IS NOT NULL)
            )
);

CREATE INDEX resale_open_idx
    ON resale_queue (ticket_id)
    WHERE processed_at IS NULL;

CREATE INDEX buyer_event_category_open_idx
    ON buyer_queue (event_id, ticket_category_id)
    WHERE resale_id IS NULL AND processed_at IS NULL;

CREATE INDEX buyer_resale_open_idx
    ON buyer_queue (resale_id)
    WHERE resale_id IS NOT NULL AND processed_at IS NULL;

CREATE OR REPLACE FUNCTION process_resale_listing()
    RETURNS TRIGGER AS $$
DECLARE
    v_event_id    INT;
    v_category_id INT;
    v_used        BOOLEAN;
    v_seller_id   INT;
    v_buyer       RECORD;
BEGIN
    -- 1) Check if the ticket is already listed for resale
    IF EXISTS (
        SELECT 1
          FROM resale_queue r
         WHERE r.ticket_id = NEW.ticket_id
           AND r.resale_id <> NEW.resale_id
           AND r.processed_at IS NULL
             FOR UPDATE
    ) THEN
        RAISE EXCEPTION
            'Ticket % is already listed for resale.',
            NEW.ticket_id;
    END IF;

    -- 2) Check if ticket is already used
    SELECT t.event_id,
           t.ticket_category_id,
           t.used,
           t.visitor_id
      INTO v_event_id, v_category_id, v_used, v_seller_id
      FROM ticket t
     WHERE t.ticket_id = NEW.ticket_id
         FOR UPDATE;

    IF v_used THEN
        RAISE EXCEPTION
            'Cannot list ticket % for resale: it has already been used.',
            NEW.ticket_id;
    END IF;

    -- 3) Check if the event is sold out
    IF NOT EXISTS (
        SELECT 1
          FROM event e
         WHERE e.event_id = v_event_id
           AND e.sold_out = TRUE
    ) THEN
        RAISE EXCEPTION
            'Cannot list ticket %: event % is not sold out.',
            NEW.ticket_id, v_event_id;
    END IF;

    -- 4) Search for a buyer (FIFO)
    SELECT *
      INTO v_buyer
      FROM buyer_queue b
     WHERE b.processed_at IS NULL
       AND b.resale_id IS NULL
       AND b.event_id = v_event_id
       AND b.ticket_category_id = v_category_id
       AND b.visitor_id <> v_seller_id -- exclude owner
     ORDER BY b.created_at
     LIMIT 1 FOR UPDATE SKIP LOCKED;

    -- 5) Complete transaction if match
    IF FOUND THEN
        UPDATE ticket
           SET visitor_id    = v_buyer.visitor_id,
               purchase_date = CURRENT_TIMESTAMP
         WHERE ticket_id = NEW.ticket_id;

        UPDATE buyer_queue
           SET processed_at = CURRENT_TIMESTAMP
         WHERE buyer_id = v_buyer.buyer_id;

        UPDATE resale_queue
           SET processed_at = CURRENT_TIMESTAMP
         WHERE resale_id = NEW.resale_id;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_process_resale_listing ON resale_queue;

CREATE TRIGGER trg_process_resale_listing
    AFTER INSERT
    ON resale_queue
    FOR EACH ROW
EXECUTE FUNCTION process_resale_listing();

CREATE OR REPLACE FUNCTION cleanup_resale_on_ticket_used()
    RETURNS TRIGGER AS $$
BEGIN
    -- used: FALSE → TRUE
    IF (TG_OP = 'UPDATE')
        AND (OLD.used IS DISTINCT FROM NEW.used)
        AND NEW.used = TRUE
    THEN
        UPDATE resale_queue
           SET processed_at = CURRENT_TIMESTAMP
         WHERE ticket_id = NEW.ticket_id
           AND processed_at IS NULL;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_cleanup_resale_on_ticket_used ON ticket;

CREATE TRIGGER trg_cleanup_resale_on_ticket_used
    AFTER UPDATE OF used
    ON ticket
    FOR EACH ROW
    WHEN (OLD.used IS DISTINCT FROM NEW.used AND NEW.used = TRUE)
EXECUTE FUNCTION cleanup_resale_on_ticket_used();

CREATE OR REPLACE FUNCTION process_buyer_request()
    RETURNS TRIGGER AS $$
DECLARE
    r_resale    RECORD;
    v_seller_id INT;
BEGIN
    IF NEW.resale_id IS NOT NULL THEN
        -- For specific resale ticket request
        -- Check if resale ticket available
        SELECT r.*
          INTO r_resale
          FROM resale_queue r
         WHERE r.resale_id = NEW.resale_id
           AND r.processed_at IS NULL
             FOR UPDATE SKIP LOCKED;

        IF r_resale.resale_id IS NULL THEN
            RAISE EXCEPTION
                'Listing % is not available (either doesn’t exist or already sold).',
                NEW.resale_id;
        END IF;

        -- Prevent buying your own ticket
        SELECT visitor_id
          INTO v_seller_id
          FROM ticket
         WHERE ticket_id = r_resale.ticket_id
             FOR UPDATE;

        IF v_seller_id = NEW.visitor_id THEN
            RAISE EXCEPTION
                'Visitor % cannot purchase their own ticket %.',
                NEW.visitor_id, r_resale.ticket_id;
        END IF;

    ELSE
        -- For event + category request
        -- Check if the request is already in the queue
        IF EXISTS (
            SELECT 1
              FROM buyer_queue bq
             WHERE bq.visitor_id = NEW.visitor_id
               AND bq.event_id = NEW.event_id
               AND bq.ticket_category_id = NEW.ticket_category_id
               AND bq.buyer_id <> NEW.buyer_id -- exclude owner
               AND bq.processed_at IS NULL
                 FOR UPDATE
        ) THEN
            RAISE EXCEPTION
                'Visitor % already has an open interest for event % / category %.',
                NEW.visitor_id, NEW.event_id, NEW.ticket_category_id;
        END IF;

        -- Search for a resale ticket (FIFO)
        SELECT r.*
          INTO r_resale
          FROM resale_queue r
          JOIN ticket t ON t.ticket_id = r.ticket_id
         WHERE r.processed_at IS NULL
           AND t.event_id = NEW.event_id
           AND t.ticket_category_id = NEW.ticket_category_id
           AND t.visitor_id <> NEW.visitor_id -- exclude owner
         ORDER BY r.created_at
         LIMIT 1 FOR UPDATE SKIP LOCKED;
    END IF;

    -- Complete transaction if match
    IF r_resale.resale_id IS NOT NULL THEN
        UPDATE ticket
           SET visitor_id    = NEW.visitor_id,
               purchase_date = CURRENT_TIMESTAMP
         WHERE ticket_id = r_resale.ticket_id;

        UPDATE resale_queue
           SET processed_at = CURRENT_TIMESTAMP
         WHERE resale_id = r_resale.resale_id;

        UPDATE buyer_queue
           SET processed_at = CURRENT_TIMESTAMP
         WHERE buyer_id = NEW.buyer_id;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_process_buyer_request ON buyer_queue;

CREATE TRIGGER trg_process_buyer_request
    AFTER INSERT
    ON buyer_queue
    FOR EACH ROW
EXECUTE FUNCTION process_buyer_request();

CREATE INDEX idx_artist_stage_name ON artist USING btree (stage_name);
CREATE INDEX idx_band_name ON band USING btree (name);
CREATE INDEX idx_performance_event ON performance USING btree (event_id);
CREATE INDEX idx_performance_time ON performance USING btree (start_time, end_time);
CREATE INDEX idx_genre_name ON genre USING btree (name);
CREATE INDEX idx_subgenre_name ON subgenre USING btree (name);
CREATE INDEX idx_subgenre_genre ON subgenre USING btree (genre_id);
CREATE INDEX idx_artist_genre_artist ON artist_genre (artist_id);
CREATE INDEX idx_artist_genre_genre ON artist_genre (genre_id);
CREATE INDEX idx_artist_genre_subgenre ON artist_genre (subgenre_id);
CREATE INDEX idx_band_genre_band ON band_genre (band_id);
CREATE INDEX idx_band_genre_genre ON band_genre (genre_id);
CREATE INDEX idx_band_genre_subgenre ON band_genre (subgenre_id);
CREATE INDEX idx_event_staff_staff ON event_staff (staff_id);
CREATE INDEX idx_performance_artist ON performance (artist_id);
CREATE INDEX idx_performance_band ON performance (band_id);
CREATE INDEX idx_event_stage_time ON event (stage_id, start_timestamp, end_timestamp);
CREATE INDEX idx_ticket_event_sold ON ticket (event_id);
CREATE INDEX idx_performance_event_time ON performance (event_id, start_time, end_time);
CREATE INDEX idx_artist_genre_comp ON artist_genre (genre_id, subgenre_id);
CREATE INDEX idx_band_genre_comp ON band_genre (genre_id, subgenre_id);

ALTER TABLE band_membership
    ADD CONSTRAINT unique_band_membership UNIQUE (artist_id, band_id);
ALTER TABLE subgenre
    ADD CONSTRAINT unique_subgenre_genre UNIQUE (genre_id, name);

CREATE TABLE media (
    media_id    SERIAL PRIMARY KEY,
    image_url   TEXT NOT NULL UNIQUE,
    description TEXT
);

ALTER TABLE artist
    ADD COLUMN media_id INT REFERENCES media (media_id);

ALTER TABLE artist_genre
    ADD COLUMN media_id INT REFERENCES media (media_id);

ALTER TABLE band
    ADD COLUMN media_id INT REFERENCES media (media_id);

ALTER TABLE band_genre
    ADD COLUMN media_id INT REFERENCES media (media_id);

ALTER TABLE band_membership
    ADD COLUMN media_id INT REFERENCES media (media_id);

ALTER TABLE continent
    ADD COLUMN media_id INT REFERENCES media (media_id);

ALTER TABLE equipment
    ADD COLUMN media_id INT REFERENCES media (media_id);

ALTER TABLE event
    ADD COLUMN media_id INT REFERENCES media (media_id);

ALTER TABLE event_staff
    ADD COLUMN media_id INT REFERENCES media (media_id);

ALTER TABLE experience_level
    ADD COLUMN media_id INT REFERENCES media (media_id);

ALTER TABLE festival
    ADD COLUMN media_id INT REFERENCES media (media_id);

ALTER TABLE genre
    ADD COLUMN media_id INT REFERENCES media (media_id);

ALTER TABLE likert_value
    ADD COLUMN media_id INT REFERENCES media (media_id);

ALTER TABLE location
    ADD COLUMN media_id INT REFERENCES media (media_id);

ALTER TABLE payment_method
    ADD COLUMN media_id INT REFERENCES media (media_id);

ALTER TABLE performance
    ADD COLUMN media_id INT REFERENCES media (media_id);

ALTER TABLE performance_rating
    ADD COLUMN media_id INT REFERENCES media (media_id);

ALTER TABLE staff
    ADD COLUMN media_id INT REFERENCES media (media_id);

ALTER TABLE staff_category
    ADD COLUMN media_id INT REFERENCES media (media_id);

ALTER TABLE staff_type
    ADD COLUMN media_id INT REFERENCES media (media_id);

ALTER TABLE stage
    ADD COLUMN media_id INT REFERENCES media (media_id);

ALTER TABLE stage_equipment
    ADD COLUMN media_id INT REFERENCES media (media_id);

ALTER TABLE subgenre
    ADD COLUMN media_id INT REFERENCES media (media_id);

ALTER TABLE ticket
    ADD COLUMN media_id INT REFERENCES media (media_id);

ALTER TABLE ticket_category
    ADD COLUMN media_id INT REFERENCES media (media_id);

ALTER TABLE visitor
    ADD COLUMN media_id INT REFERENCES media (media_id);