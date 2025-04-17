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
  genre_id integer NOT NULL,
  subgenre_id integer,
  website text,
  instagram_profile varchar(255) UNIQUE,
  FOREIGN KEY (genre_id) references genre (genre_id),
  FOREIGN KEY (subgenre_id) references subgenre (subgenre_id)
);

CREATE TABLE band(
  band_id integer DEFAULT nextval('band_id_seq'::regclass) PRIMARY KEY,
  name varchar(255),
  date_created date NOT NULL,
  genre_id integer NOT NULL,
  subgenre_id integer,
  website text,
  instagram_profile varchar(255) UNIQUE,
  FOREIGN KEY (genre_id) references genre (genre_id),
  FOREIGN KEY (subgenre_id) references subgenre (subgenre_id)
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
              SELECT 1 FROM artist_band 
              WHERE artist_band.artist_id = NEW.artist_id
              AND artist_band.band_id = performance.band_id
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

CREATE OR REPLACE FUNCTION check_subgenre_validity()
RETURNS TRIGGER AS $$
DECLARE
    genre_match INT;
BEGIN
    -- If subgenre_id is provided, check if it belongs to the same genre_id
    IF NEW.subgenre_id IS NOT NULL THEN
        SELECT COUNT(*) INTO genre_match
        FROM subgenre
        WHERE subgenre_id = NEW.subgenre_id AND genre_id = NEW.genre_id;

        IF genre_match = 0 THEN
            RAISE EXCEPTION 'Subgenre does not belong to the specified genre!';
        END IF;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER enforce_subgenre_genre_match
BEFORE INSERT OR UPDATE ON artist
FOR EACH ROW
EXECUTE FUNCTION check_subgenre_validity();




CREATE OR REPLACE FUNCTION check_band_subgenre_validity()
RETURNS TRIGGER AS $$
DECLARE
    genre_match INT;
BEGIN
    -- If subgenre_id is provided, check if it belongs to the same genre_id
    IF NEW.subgenre_id IS NOT NULL THEN
        SELECT COUNT(*) INTO genre_match
        FROM subgenre
        WHERE subgenre_id = NEW.subgenre_id AND genre_id = NEW.genre_id;

        IF genre_match = 0 THEN
            RAISE EXCEPTION 'Subgenre does not belong to the specified genre!';
        END IF;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER enforce_band_subgenre_match
BEFORE INSERT OR UPDATE ON band
FOR EACH ROW
EXECUTE FUNCTION check_band_subgenre_validity();



CREATE INDEX idx_artist_stage_name ON artist USING btree (stage_name);
CREATE INDEX idx_artist_genre ON artist USING btree (genre_id);
CREATE INDEX idx_artist_subgenre ON artist USING btree (subgenre_id);
CREATE UNIQUE INDEX idx_artist_instagram ON artist USING btree (instagram_profile);
CREATE INDEX idx_band_name ON band USING btree (name);
CREATE INDEX idx_band_genre ON band USING btree (genre_id);
CREATE INDEX idx_band_subgenre ON band USING btree (subgenre_id);
CREATE UNIQUE INDEX idx_band_instagram ON band USING btree (instagram_profile);
CREATE UNIQUE INDEX idx_stage_name ON band USING btree (stage_name);
CREATE INDEX idx_performance_event ON performance USING btree (event_id);
CREATE INDEX idx_performance_stage ON performance USING btree (stage_id);
CREATE INDEX idx_performance_time ON performance USING btree (start_time, end_time);
CREATE INDEX idx_performance_conflict ON performance USING btree (artist_id, band_id, stage_id) WHERE artist_id IS NOT NULL OR band_id IS NOT NULL;
CREATE INDEX idx_artist_band_artist ON artist_band USING btree (artist_id);
CREATE INDEX idx_artist_band_band ON artist_band USING btree (band_id);
CREATE INDEX idx_genre_name ON genre USING btree (name);
CREATE INDEX idx_subgenre_name ON subgenre USING btree (name);
CREATE INDEX idx_subgenre_genre ON subgenre USING btree (genre_id);



--Add control over the duplicates for 
ALTER TABLE artist_band ADD CONSTRAINT unique_artist_band UNIQUE (artist_id, band_id);
ALTER TABLE performance ADD CONSTRAINT unique_performance_event_stage UNIQUE (event_id, stage_id, start_time);
ALTER TABLE subgenre ADD CONSTRAINT unique_subgenre_genre UNIQUE (genre_id, name);
