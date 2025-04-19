INSERT INTO continent (name) VALUES
('Africa'),
('Antarctica'),
('Asia'),
('Europe'),
('North America'),
('Oceania'),
('South America');

INSERT INTO location (name, address, city, country, continent, coordinates) VALUES
('Central Festival Grounds', 'Alexanderplatz 1', 'Berlin', 'Germany', 4, point(13.4050, 52.5200)),
('Lakeside Music Park', 'Harbour St 45', 'Toronto', 'Canada', 5, point(-79.3832, 43.6532)),
('Desert Rock Arena', 'Phoenix Blvd 101', 'Phoenix', 'USA', 5, point(-112.0740, 33.4484)),
('Sunset Festival Field', 'Opera House Rd', 'Sydney', 'Australia', 6, point(151.2093, -33.8688)),
('Urban Beat Arena', 'Shibuya Crossing 5', 'Tokyo', 'Japan', 3, point(139.6917, 35.6895)),
('Mountain Echo Amphitheater', 'Alpine Way 10', 'Innsbruck', 'Austria', 4, point(11.4041, 47.2692)),
('Cultural Fiesta Plaza', 'Reforma 200', 'Mexico City', 'Mexico', 5, point(-99.1332, 19.4326)),
('Riverfront Stage', 'Nile Avenue', 'Cairo', 'Egypt', 1, point(31.2357, 30.0444)),
('Seaside Sound Garden', 'La Rambla 50', 'Barcelona', 'Spain', 4, point(2.1734, 41.3851)),
('Highland Music Park', 'Royal Mile 12', 'Edinburgh', 'UK', 4, point(-3.1883, 55.9533)),
('City Lights Concert Arena', 'Broadway 200', 'New York', 'USA', 5, point(-74.0060, 40.7128)),
('Festival Green Field', 'Nairobi Road', 'Nairobi', 'Kenya', 1, point(36.8219, -1.2921)),
('Island Vibes Venue', 'Queen Street 33', 'Auckland', 'New Zealand', 6, point(174.7633, -36.8485)),
('Metropolitan Music Hub', 'Champs-Élysées 100', 'Paris', 'France', 4, point(2.3522, 48.8566)),
('Jungle Jam Grounds', 'Sukhumvit Rd', 'Bangkok', 'Thailand', 3, point(100.5018, 13.7563)),
('Cosmopolitan Concert Park', 'Sheikh Zayed Rd', 'Dubai', 'UAE', 3, point(55.2708, 25.2048)),
('Urban Rave Square', 'Piccadilly 88', 'London', 'UK', 4, point(-0.1278, 51.5074)),
('Riverside Rhythm Arena', 'Avenida 9 de Julio', 'Buenos Aires', 'Argentina', 7, point(-58.3816, -34.6037)),
('Festival Fields', 'Paulista Ave', 'Sao Paulo', 'Brazil', 7, point(-46.6333, -23.5505)),
('Central Park Stage', 'Central Park West', 'New York', 'USA', 5, point(-73.935242, 40.730610));

INSERT INTO festival (name, start_date, end_date, location_id) VALUES
('Pulse Festival 2010', '2010-06-01', '2010-06-05', 1),
('Pulse Festival 2011', '2011-06-01', '2011-06-05', 2),
('Pulse Festival 2012', '2012-06-01', '2012-06-05', 3),
('Pulse Festival 2013', '2013-06-01', '2013-06-05', 4),
('Pulse Festival 2014', '2014-06-01', '2014-06-05', 5),
('Pulse Festival 2015', '2015-06-01', '2015-06-05', 6),
('Pulse Festival 2016', '2016-06-01', '2016-06-05', 7),
('Pulse Festival 2017', '2017-06-01', '2017-06-05', 8),
('Pulse Festival 2018', '2018-06-01', '2018-06-05', 9),
('Pulse Festival 2019', '2019-06-01', '2019-06-05', 10),
('Pulse Festival 2020', '2020-06-01', '2020-06-05', 11),
('Pulse Festival 2021', '2021-06-01', '2021-06-05', 12),
('Pulse Festival 2022', '2022-06-01', '2022-06-05', 13),
('Pulse Festival 2023', '2023-06-01', '2023-06-05', 14),
('Pulse Festival 2024', '2024-06-01', '2024-06-05', 15);

INSERT INTO festival (name, start_date, end_date, location_id) VALUES
('Pulse Festival2 2010', '2010-07-01', '2010-07-05', 16);

INSERT INTO stage (name, description, max_capacity) VALUES
('Main Stage', 'Primary stage for headline performances', 5000),
('Secondary Stage', 'Supporting acts and mid-tier performers', 3000),
('Outdoor Arena', 'Open-air venue for large events', 6000),
('Acoustic Stage', 'Intimate setting for acoustic sessions', 1500),
('Electric Stage', 'Venue dedicated to electronic music acts', 2500),
('Jazz Corner', 'Cozy stage for jazz performances', 800),
('Rock Arena', 'Large venue for rock concerts', 4000),
('Indie Stage', 'Stage focused on indie and alternative music', 1200),
('Hip-Hop Stage', 'Dedicated to hip-hop performances', 2000),
('Classical Hall', 'Indoor setting for classical concerts', 1000),
('Dance Floor', 'High-energy stage for DJ sets and dance parties', 3500),
('Experimental Stage', 'Platform for avant-garde and experimental acts', 600),
('Fusion Stage', 'Mixing genres in a creative environment', 2200),
('Chill Out Lounge', 'Relaxed venue for ambient and chill music', 500),
('Pop Arena', 'Large indoor stage for pop music events', 4500),
('Folk Stage', 'Showcasing folk and cultural performances', 900),
('Electronic Dome', 'Enclosed dome for electronic music festivals', 3000),
('Reggae Garden', 'Outdoor venue for reggae and world music', 1100),
('Metal Pit', 'Intense stage for metal band performances', 3500),
('Salsa Venue', 'Dedicated to salsa and Latin music events', 1300),
('Blues Bar', 'Cozy spot for blues performances', 700),
('Country Corner', 'Venue for country music and related acts', 1000),
('Soul Stage', 'Stage for soulful and R&B performances', 1800),
('Funk Floor', 'Energetic space for funk music', 2000),
('Rave Arena', 'High-energy venue for rave and EDM events', 4000),
('K-Pop Stage', 'Stage dedicated to K-Pop performances', 2500),
('Reggaeton Arena', 'Venue for reggaeton and urban music events', 2300),
('Ambient Area', 'Quiet stage for ambient music sessions', 600),
('World Music Stage', 'International music genres under one roof', 1400),
('Comedy Club', 'Intimate venue for stand-up comedy shows', 800),
('Poetry Corner', 'Cozy stage for spoken word and poetry readings', 300),
('Theater Stage', 'Traditional stage for theatrical performances', 1500),
('Opera House', 'Elegant venue for opera performances', 2000),
('B-Boy Arena', 'Space for breakdancing and street performance battles', 1200),
('Electronic Lounge', 'Modern setting for electronic and dance music', 2200);

--Lower max_capacity
UPDATE stage
SET max_capacity = CASE
    WHEN max_capacity > 400 THEN 400
    WHEN max_capacity < 100 THEN 100
    ELSE max_capacity
END;


INSERT INTO equipment (name, description) VALUES
('Speakers', 'High quality audio speakers for clear sound projection.'),
('Microphones', 'Wireless and wired microphones for performers.'),
('Mixing Console', 'Digital mixing board with multiple channels.'),
('Lighting Rig', 'Advanced lighting system for dynamic stage effects.'),
('Drum Kit', 'Complete drum set for percussion needs.'),
('Guitar Amplifier', 'Amplifier designed for electric guitars.'),
('Stage Monitor', 'On-stage monitors for clear performer audio.'),
('Projector', 'High-resolution projector for visuals and video.'),
('LED Screens', 'Large LED displays for live video feeds.'),
('Smoke Machine', 'Machine to create atmospheric smoke effects.');

INSERT INTO stage_equipment (stage_id, equipment_id, quantity) VALUES
(1, 1, 4),  -- Main Stage: 4 Speakers
(1, 2, 6),  -- Main Stage: 6 Microphones
(2, 1, 2),  -- Secondary Stage: 2 Speakers
(2, 4, 3),  -- Secondary Stage: 3 Lighting Rigs
(3, 1, 8),  -- Outdoor Arena: 8 Speakers
(4, 2, 4),  -- Acoustic Stage: 4 Microphones
(5, 3, 2),  -- Electric Stage: 2 Mixing Consoles
(6, 2, 2),  -- Jazz Corner: 2 Microphones
(7, 1, 10), -- Rock Arena: 10 Speakers
(7, 5, 1),  -- Rock Arena: 1 Drum Kit
(8, 2, 3),  -- Indie Stage: 3 Microphones
(8, 6, 1),  -- Indie Stage: 1 Guitar Amplifier
(9, 2, 5),  -- Hip-Hop Stage: 5 Microphones
(10, 7, 4), -- Classical Hall: 4 Stage Monitors
(11, 4, 2), -- Dance Floor: 2 Lighting Rigs
(12, 8, 1), -- Experimental Stage: 1 Projector
(13, 9, 2), -- Fusion Stage: 2 LED Screens
(14, 10, 1),-- Chill Out Lounge: 1 Smoke Machine
(15, 1, 6); -- Pop Arena: 6 Speakers

INSERT INTO experience_level (name, level) VALUES
('Apprentice', 1),
('Beginner', 2),
('Intermediate', 3),
('Experienced', 4),
('Highly Experienced', 5);

INSERT INTO staff_category (name, description) VALUES
('Technical', 'Technical personnel'),
('Security', 'Security personnel'),
('Support', 'Auxiliary/support personnel');

INSERT INTO staff_type (name, description, staff_category_id) VALUES
('Sound Engineer', 'Handles setup and operation of audio systems', 1),
('Lighting Technician', 'Designs and controls stage lighting', 1),
('Mixing Engineer', 'Manages live sound mixing during performances', 1),
('Rigger', 'Installs and secures lighting/sound rigging', 1),
('Video Technician', 'Operates projection and video feeds', 1),
('Security Guard', 'Monitors venue security and access control', 2),
('Crowd Control Officer', 'Manages audience flow and safety', 2),
('Perimeter Guard', 'Secures the event perimeter', 2),
('Usher', 'Guides attendees to their seats/areas', 3),
('Cleaner', 'Maintains cleanliness before, during, and after events', 3),
('Equipment Handler', 'Loads, unloads, and transports gear', 3),
('Parking Attendant', 'Directs vehicle parking and traffic', 3);

INSERT INTO staff (first_name, last_name, date_of_birth, staff_category_id, staff_type_id, experience_level_id) VALUES
('John',    'Doe',       '1985-04-10', 1,  1, 4),
('Alice',   'Smith',     '1990-06-20', 1,  2, 3),
('Bob',     'Johnson',   '1978-11-05', 2,  6, 5),
('Maria',   'Garcia',    '1988-12-01', 2,  7, 4),
('David',   'Lee',       '1995-02-14', 3,  9, 2),
('Laura',   'Brown',     '1980-09-30', 3, 10, 3),
('Mike',    'Davis',     '1982-07-22', 3, 11, 5),
('Sarah',   'Wilson',    '1992-03-15', 1,  3, 3),
('Tom',     'Martinez',  '1975-01-20', 1,  4, 5),
('Emma',    'Thompson',  '1998-08-10', 3, 12, 1),
('Chris',   'Evans',     '1987-06-13', 1, NULL, 2),
('Nina',    'Adams',     '1983-05-02', 2, NULL, 4),
('Laura',    'Chen',      '1991-04-12', 1,  3, 2),
('Daniel',   'Young',     '1984-07-15', 1,  4, 5),
('Oliver',   'Scott',     '1979-12-11', 1,  5, 4),
('Sophia',   'Turner',    '1993-11-23', 2,  6, 3),
('Ethan',    'Walker',    '1986-02-19', 2,  7, 4),
('Isabella', 'Harris',    '1990-05-25', 2,  8, 2),
('Noah',     'King',      '1999-09-09', 3,  9, 1),
('Mia',      'Wright',    '1988-10-30', 3, 10, 3),
('Ava',      'Martin',    '1992-03-08', 3, NULL, 2),
('Liam',     'Perez',     '1995-08-14', 2, NULL, 3);

INSERT INTO event (festival_id, name, start_timestamp, end_timestamp, stage_id) VALUES
-- Festival 1 (2010)
(1,  'Opening Ceremony',       '2010-06-01 10:00:00', '2010-06-01 11:30:00', 1),
(1,  'Rock Legends',           '2010-06-01 12:00:00', '2010-06-01 14:00:00', 1),
(1,  'Acoustic Session',       '2010-06-01 10:00:00', '2010-06-01 11:00:00', 2),
-- Festival 2 (2011)
(2,  'Jazz Morning',           '2011-06-01 09:00:00', '2011-06-01 10:30:00', 6),
(2,  'Folk Ensemble',          '2011-06-01 11:00:00', '2011-06-01 12:30:00', 6),
(2,  'Headline Pop',           '2011-06-02 20:00:00', '2011-06-02 22:00:00', 1),
-- Festival 3 (2012)
(3,  'Electronic Beats',       '2012-06-01 18:00:00', '2012-06-01 20:00:00', 5),
(3,  'Dance Night',            '2012-06-01 20:30:00', '2012-06-01 23:00:00', 5),
-- Festival 4 (2013)
(4,  'Classical Overture',     '2013-06-01 17:00:00', '2013-06-01 19:00:00', 10),
(4,  'Symphony No. 5',         '2013-06-02 19:30:00', '2013-06-02 22:00:00', 10),
-- Festival 5 (2014)
(5,  'Indie Showcase',         '2014-06-03 14:00:00', '2014-06-03 16:00:00', 8),
(5,  'Alternative Rock',       '2014-06-03 16:30:00', '2014-06-03 18:30:00', 8),
-- Festival 6 (2015)
(6,  'Hip-Hop Cypher',         '2015-06-01 22:00:00', '2015-06-02 00:00:00', 9),
-- Festival 7 (2016)
(7,  'Metal Mania',            '2016-06-02 18:00:00', '2016-06-02 20:00:00', 7),
(7,  'Drum Solo',              '2016-06-02 20:30:00', '2016-06-02 21:30:00', 7),
-- Festival 8 (2017)
(8,  'Reggae Roots',           '2017-06-01 12:00:00', '2017-06-01 14:00:00', 18),
-- Festival 9 (2018)
(9,  'Latin Dance',            '2018-06-04 19:00:00', '2018-06-04 21:00:00', 20),
-- Festival 10 (2019)
(10, 'Blues Evening',          '2019-06-05 18:00:00', '2019-06-05 20:00:00', 22),
-- Festival 11 (2020)
(11, 'Ambient Chill',          '2020-06-02 15:00:00', '2020-06-02 17:00:00', 29),
-- Festival 12 (2021)
(12, 'World Music Fusion',     '2021-06-03 16:00:00', '2021-06-03 18:00:00', 28),
-- Festival 13 (2022)
(13, 'K-Pop Extravaganza',     '2022-06-01 20:00:00', '2022-06-01 22:30:00', 26),
-- Festival 14 (2023)
(14, 'Electronic Dome Rave',   '2023-06-02 21:00:00', '2023-06-03 00:00:00', 17),
-- Festival 15 (2024)
(15, 'Closing Fireworks',      '2024-06-05 22:00:00', '2024-06-05 23:00:00', 1);

-- Insert 200 new security staff (staff_category_id = 2, staff_type_id cycles through 6–8)
INSERT INTO staff (first_name, last_name, date_of_birth, staff_category_id, staff_type_id, experience_level_id)
SELECT
  'Sec' || i AS first_name,
  'Guard' || i AS last_name,
  DATE '1985-01-01' AS date_of_birth,
  2 AS staff_category_id,
  6 + ((i - 1) % 3) AS staff_type_id,      -- cycles through 6,7,8
  1 + ((i - 1) % 5) AS experience_level_id -- cycles through 1–5
FROM generate_series(1,200) AS s(i);

-- Insert 100 new support staff (staff_category_id = 3, staff_type_id cycles through 9–12)
INSERT INTO staff (first_name, last_name, date_of_birth, staff_category_id, staff_type_id, experience_level_id)
SELECT
  'Sup' || i AS first_name,
  'Staff' || i AS last_name,
  DATE '1990-01-01' AS date_of_birth,
  3 AS staff_category_id,
  9 + ((i - 1) % 4) AS staff_type_id,      -- cycles through 9–12
  1 + ((i - 1) % 5) AS experience_level_id -- cycles through 1–5
FROM generate_series(1,100) AS s(i);

INSERT INTO genre (name) VALUES
('Rock'),
('Pop'),
('Jazz'),
('Electronic'),
('Classical'),
('Hip-Hop'),
('Blues'),
('Reggae'),
('Folk'),
('Metal');

-- Insert into subgenre
INSERT INTO subgenre (name, genre_id) VALUES
('Alternative Rock', 1),
('Indie Pop', 2),
('Smooth Jazz', 3),
('House', 4),
('Opera', 5),
('Trap', 6),
('Delta Blues', 7),
('Dancehall', 8),
('Singer-Songwriter', 9),
('Death Metal', 10);

-- Insert into artist
INSERT INTO artist (real_name, stage_name, date_of_birth, genre_id, subgenre_id, website, instagram_profile) VALUES
('John Doe', 'Johnny Rock', '1985-06-15', 1, 1, 'http://johnnyrock.com', 'johnnyrock'),
('Emily Smith', 'Em Pop', '1992-03-22', 2, 2, 'http://empopmusic.com', 'empopmusic'),
('Mike Brown', 'Jazz Mike', '1978-12-11', 3, 3, 'http://jazzmike.com', 'jazzmike'),
('Lisa Green', 'DJ Lisa', '1990-07-04', 4, 4, 'http://djlisa.com', 'djlisa'),
('Andrew White', 'Opera Andy', '1980-09-17', 5, 5, 'http://operaandy.com', 'operaandy'),
('Chris Black', 'C-Black', '1995-05-30', 6, 6, 'http://cblackhiphop.com', 'cblackhiphop'),
('Samantha King', 'Blues Sammy', '1983-11-21', 7, 7, 'http://bluessammy.com', 'bluessammy'),
('David Marley', 'Reggae Dave', '1986-02-10', 8, 8, 'http://reggaedave.com', 'reggaedave'),
('Nina Folk', 'Folk Nina', '1993-08-14', 9, 9, 'http://folknina.com', 'folknina'),
('Jack Metal', 'Metal Jack', '1975-04-25', 10, 10, 'http://metaljack.com', 'metaljack');

-- Insert into band
INSERT INTO band (name, date_created, genre_id, subgenre_id, website, instagram_profile) VALUES
('Rockers United', '2005-06-20', 1, 1, 'http://rockersunited.com', 'rockersunited'),
('Pop Stars', '2010-11-15', 2, 2, 'http://popstars.com', 'popstarsband'),
('Jazz Masters', '1998-09-10', 3, 3, 'http://jazzmasters.com', 'jazzmasters'),
('Electro Beats', '2015-04-05', 4, 4, 'http://electrobeats.com', 'electrobeats'),
('Classical Virtuosos', '1992-07-12', 5, 5, 'http://classicalvirtuosos.com', 'classicalvirtuosos'),
('Hip-Hop Crew', '2008-01-25', 6, 6, 'http://hiphopcrew.com', 'hiphopcrew'),
('Blues Legends', '1985-06-30', 7, 7, 'http://blueslegends.com', 'blueslegends'),
('Reggae Kings', '1990-12-05', 8, 8, 'http://reggaekings.com', 'reggaekings'),
('Folk Group', '2012-03-18', 9, 9, 'http://folkgroup.com', 'folkgroup'),
('Metal Lords', '2000-09-09', 10, 10, 'http://metallords.com', 'metallords');

-- Insert into artist_band
INSERT INTO artist_band (artist_id, band_id) VALUES
(1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 7), (8, 8), (9, 9), (10, 10);

-- Insert into performance
INSERT INTO performance (event_id, artist_id, band_id, performance_type, start_time, end_time, duration, stage_id) VALUES
(1, 1, NULL, 'Solo', '14:00', '15:00', 60, 1),
(1, NULL, 1, 'Band', '15:10', '16:10', 60, 1),
(1, 2, NULL, 'Solo', '16:20', '17:20', 60, 1),
(2, 3, NULL, 'Solo', '18:00', '19:00', 60, 2),
(2, NULL, 3, 'Band', '19:10', '20:10', 60, 2),
(3, 4, NULL, 'DJ Set', '21:00', '22:30', 90, 3),
(3, 5, NULL, 'Opera', '22:40', '23:40', 60, 3),
(4, 6, NULL, 'Rap', '12:00', '13:00', 60, 4),
(4, NULL, 6, 'Group Rap', '13:10', '14:10', 60, 4),
(5, 7, NULL, 'Blues', '15:00', '16:30', 90, 5);