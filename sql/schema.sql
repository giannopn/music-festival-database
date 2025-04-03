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

CREATE TABLE staff_type (
    staff_type_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description VARCHAR(255)
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
    staff_type_id INT NOT NULL,
    experience_level_id INT NOT NULL,
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
