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

INSERT INTO genre (genre_id, name) VALUES
(1, 'Rock'),
(2, 'Pop'),
(3, 'Jazz'),
(4, 'Hip Hop'),
(5, 'Electronic'),
(6, 'Classical'),
(7, 'Reggae');

INSERT INTO subgenre (subgenre_id, name, genre_id) VALUES
(1, 'Alternative Rock', 1),
(2, 'Hard Rock', 1),
(3, 'Indie Rock', 1),
(4, 'Synthpop', 2),
(5, 'Electropop', 2),
(6, 'Smooth Jazz', 3),
(7, 'Bebop', 3),
(8, 'Trap', 4),
(9, 'Boom Bap', 4),
(10, 'House', 5),
(11, 'Techno', 5),
(12, 'Baroque', 6),
(13, 'Romantic', 6),
(14, 'Dancehall', 7),
(15, 'Roots Reggae', 7);

INSERT INTO artist (artist_id, real_name, stage_name, date_of_birth, website, instagram_profile) VALUES
(1, 'Andrew Stone', 'duanegarcia', '1997-01-25', 'https://www.thompson.com/', 'duanegarcia_insta'),
(2, 'Pamela Ward', 'rperez', '2003-10-28', 'https://www.estes.com/', 'rperez_insta'),
(3, 'Daniel Campbell', 'jeffrey87', '1981-09-14', 'http://www.adams.com/', 'jeffrey87_insta'),
(4, 'Joanna White', 'vazquezkeith', '1987-05-24', 'http://www.sullivan.com/', 'vazquezkeith_insta'),
(5, 'Mr. Jonathan Johnson', 'reginawillis', '1982-12-17', 'https://rodriguez.com/', 'reginawillis_insta'),
(6, 'Samuel James', 'simsmartha', '1999-11-07', 'http://www.tran.net/', 'simsmartha_insta'),
(7, 'Joshua Young', 'archerdarius', '1999-11-18', 'https://anderson.info/', 'archerdarius_insta'),
(8, 'Mariah Dixon', 'greentimothy', '1973-12-07', 'http://www.blake-powell.org/', 'greentimothy_insta'),
(9, 'Sarah Berry', 'swallace', '2004-06-25', 'http://www.martinez.com/', 'swallace_insta'),
(10, 'Tracie Webster', 'erichall', '1978-11-21', 'http://www.mcpherson.net/', 'erichall_insta'),
(11, 'Jennifer Moyer', 'ihill', '1991-10-04', 'https://edwards.com/', 'ihill_insta'),
(12, 'Derek Kelly', 'coreybeck', '1983-05-28', 'http://munoz-miller.net/', 'coreybeck_insta'),
(13, 'Matthew Harper', 'rossjeffrey', '1993-08-03', 'https://www.smith-sanchez.com/', 'rossjeffrey_insta'),
(14, 'Craig King', 'kellyperry', '2003-08-26', 'https://www.hancock-smith.info/', 'kellyperry_insta'),
(15, 'Abigail Mason', 'davidsmith', '1979-09-24', 'https://www.taylor.com/', 'davidsmith_insta'),
(16, 'Kristen Smith', 'rhondaalvarez', '2004-04-30', 'https://owen-perry.com/', 'rhondaalvarez_insta'),
(17, 'Eric Ibarra', 'kimedward', '2000-03-29', 'http://www.lane.com/', 'kimedward_insta'),
(18, 'Andrew Morris', 'aliciapennington', '1989-02-24', 'https://www.leonard-hill.com/', 'aliciapennington_insta'),
(19, 'John Ortiz', 'mccarthybeverly', '1975-01-01', 'http://white.com/', 'mccarthybeverly_insta'),
(20, 'Christopher Thomas', 'jeffrey73', '1996-04-14', 'https://alvarez.net/', 'jeffrey73_insta'),
(21, 'Danielle Wright', 'jonathan25', '1974-04-19', 'http://alexander.com/', 'jonathan25_insta'),
(22, 'Cameron Gray', 'ruthwalker', '1992-08-12', 'https://mcdowell.com/', 'ruthwalker_insta'),
(23, 'Kelly Phillips MD', 'stevensonmarissa', '1988-07-09', 'https://owens-reyes.com/', 'stevensonmarissa_insta'),
(24, 'Sarah Vasquez', 'angelaallen', '1983-05-05', 'https://franco-cannon.net/', 'angelaallen_insta'),
(25, 'Anthony Mayo', 'zroth', '2006-05-29', 'http://www.aguirre-wilson.org/', 'zroth_insta'),
(26, 'Michelle Bailey', 'michaelparker', '1976-07-31', 'http://jimenez.info/', 'michaelparker_insta'),
(27, 'Sandra Gibson', 'millerjo', '1977-03-04', 'https://www.jones.org/', 'millerjo_insta'),
(28, 'Christopher Turner', 'taylorshaw', '1999-04-14', 'http://carter.com/', 'taylorshaw_insta'),
(29, 'Thomas Ramirez', 'gonzalezchristian', '1996-09-10', 'http://www.fisher.org/', 'gonzalezchristian_insta'),
(30, 'Kathleen Beck', 'shannonluna', '1980-01-30', 'https://www.lewis-humphrey.com/', 'shannonluna_insta');

INSERT INTO band (band_id, name, date_created, website, instagram_profile) VALUES
(1, 'Moore, Gonzalez and Li', '2023-05-25', 'http://www.galloway.net/', 'moore,gonzalezandli_band'),
(2, 'Larson, Hendrix and Castillo', '2019-04-04', 'http://zimmerman.com/', 'larson,hendrixandcastillo_band'),
(3, 'Thompson, Brown and Barnes', '2013-09-01', 'https://www.molina.com/', 'thompson,brownandbarnes_band'),
(4, 'Roy Inc', '2014-06-27', 'http://pierce.com/', 'royinc_band'),
(5, 'Knapp-Dean', '2017-06-05', 'https://www.gould.biz/', 'knapp-dean_band'),
(6, 'Johnson and Sons', '2019-06-07', 'https://www.jones-trujillo.com/', 'johnsonandsons_band'),
(7, 'Williams-Martin', '2018-11-22', 'https://winters.net/', 'williams-martin_band'),
(8, 'Tran Ltd', '2024-02-01', 'https://www.williams.com/', 'tranltd_band'),
(9, 'Christian-Anthony', '2012-10-10', 'https://jackson.biz/', 'christian-anthony_band'),
(10, 'Williams, Price and Garrett', '2013-10-04', 'https://www.kline-green.org/', 'williams,priceandgarrett_band'),
(11, 'Ellis Ltd', '2022-08-27', 'https://wood.com/', 'ellisltd_band'),
(12, 'Oliver Group', '2023-12-08', 'http://hernandez-tran.com/', 'olivergroup_band'),
(13, 'Sims-Tanner', '2016-01-15', 'http://www.moss.org/', 'sims-tanner_band'),
(14, 'Galvan, Campbell and Harrington', '2014-08-26', 'https://wood-downs.com/', 'galvan,campbellandharrington_band'),
(15, 'Williams-Stone', '2019-12-02', 'http://www.evans.com/', 'williams-stone_band'),
(16, 'Silva Ltd', '2021-04-24', 'https://www.morris-alexander.net/', 'silvaltd_band'),
(17, 'Vasquez LLC', '2014-11-08', 'https://heath.org/', 'vasquezllc_band'),
(18, 'Arnold Group', '2022-10-02', 'https://chen.biz/', 'arnoldgroup_band'),
(19, 'Hernandez Group', '2012-01-07', 'http://romero.com/', 'hernandezgroup_band'),
(20, 'Davis-Hopkins', '2010-04-28', 'http://www.gaines.com/', 'davis-hopkins_band'),
(21, 'Leon Ltd', '2022-12-11', 'http://www.mcneil-brooks.info/', 'leonltd_band'),
(22, 'Harris, Watson and Lucas', '2024-01-05', 'https://beck-jackson.info/', 'harris,watsonandlucas_band'),
(23, 'Ramirez and Sons', '2021-01-31', 'http://duncan.org/', 'ramirezandsons_band'),
(24, 'Spence LLC', '2016-04-20', 'https://martinez.com/', 'spencellc_band'),
(25, 'Maynard Ltd', '2010-11-18', 'https://www.harris.biz/', 'maynardltd_band'),
(26, 'Steele-Miller', '2013-09-28', 'http://www.kane.com/', 'steele-miller_band'),
(27, 'Anderson, Yu and Curry', '2010-05-06', 'https://www.parker.com/', 'anderson,yuandcurry_band'),
(28, 'Atkinson-Baker', '2016-04-18', 'http://blake-ramirez.info/', 'atkinson-baker_band'),
(29, 'Jennings, Holmes and Cooper', '2024-01-17', 'https://barry.com/', 'jennings,holmesandcooper_band'),
(30, 'Page-Gonzalez', '2017-03-14', 'http://www.neal.biz/', 'page-gonzalez_band');

INSERT INTO band_membership (artist_id, band_id) VALUES
(7, 24),
(9, 27),
(2, 15),
(26, 3),
(12, 20),
(8, 28),
(11, 28),
(16, 24),
(25, 22),
(10, 5),
(22, 11),
(14, 22),
(27, 5),
(21, 20),
(28, 15),
(29, 15),
(5, 21),
(24, 23),
(30, 14),
(17, 30),
(6, 12),
(13, 6),
(3, 27),
(15, 27),
(19, 7);

INSERT INTO artist_genre (artist_id, genre_id, subgenre_id) VALUES
(1, 6, 13),
(1, 3, 6),
(2, 3, 7),
(2, 4, 9),
(3, 5, 11),
(3, 7, 15),
(4, 4, 9),
(4, 5, 11),
(5, 5, 10),
(5, 4, 8),
(6, 1, 2),
(6, 2, 5),
(7, 1, 1),
(7, 6, 12),
(8, 3, 7),
(9, 1, 2),
(9, 1, 3),
(10, 6, 12),
(10, 1, 1),
(11, 3, 7),
(11, 6, 12),
(12, 1, 2),
(12, 4, 9),
(13, 6, 13),
(13, 4, 9),
(14, 5, 10),
(14, 3, 7),
(15, 2, 5),
(15, 4, 9),
(16, 2, 5),
(16, 4, 8),
(17, 3, 7),
(17, 1, 3),
(18, 4, 9),
(19, 5, 11),
(19, 1, 3),
(20, 5, 10),
(20, 5, 11),
(21, 2, 5),
(21, 4, 8),
(22, 7, 14),
(22, 3, 7),
(23, 1, 1),
(23, 5, 10),
(24, 5, 11),
(24, 2, 4),
(25, 7, 14),
(25, 4, 8),
(26, 1, 1),
(26, 5, 11),
(27, 5, 10),
(27, 2, 4),
(28, 5, 11),
(28, 7, 14),
(29, 7, 15),
(29, 1, 2),
(30, 5, 10),
(30, 2, 4);

INSERT INTO band_genre (band_id, genre_id, subgenre_id) VALUES
(1, 6, 12),
(1, 3, 6),
(2, 3, 7),
(2, 7, 15),
(3, 1, 3),
(3, 5, 10),
(4, 5, 11),
(4, 1, 2),
(5, 1, 2),
(5, 7, 15),
(6, 4, 8),
(6, 5, 11),
(7, 3, 6),
(7, 4, 8),
(8, 4, 8),
(8, 1, 2),
(9, 3, 6),
(9, 2, 5),
(10, 5, 10),
(10, 7, 14),
(11, 5, 10),
(11, 3, 6),
(12, 7, 15),
(12, 5, 10),
(13, 4, 9),
(13, 6, 13),
(14, 3, 6),
(14, 4, 8),
(15, 7, 14),
(15, 5, 10),
(16, 4, 9),
(16, 1, 3),
(17, 5, 10),
(17, 7, 14),
(18, 3, 7),
(18, 7, 14),
(19, 5, 11),
(19, 6, 12),
(20, 1, 3),
(20, 1, 2),
(21, 3, 7),
(21, 1, 2),
(22, 3, 6),
(22, 4, 8),
(23, 6, 13),
(23, 2, 5),
(24, 5, 10),
(24, 5, 11),
(25, 1, 3),
(25, 2, 4),
(26, 2, 5),
(26, 5, 10),
(27, 5, 10),
(27, 7, 14),
(28, 2, 5),
(29, 2, 4),
(29, 3, 7),
(30, 6, 13),
(30, 7, 14);

INSERT INTO performance (performance_id, name, event_id, band_id, performance_type, start_time, end_time, duration, stage_id) VALUES
(1, 'Automated scalable firmware', 1, 16, 'Live', '14:00:00', '14:45:00', 45, 1),
(2, 'Quality-focused foreground Local Area Ne', 1, 26, 'Live', '14:50:00', '15:35:00', 45, 1),
(4, 'Team-oriented content-based array', 1, 7, 'Live', '14:50:00', '15:35:00', 45, 2),
(5, 'Triple-buffered local encryption', 1, 8, 'Live', '14:00:00', '14:45:00', 45, 3),
(7, 'Robust heuristic throughput', 1, 11, 'Live', '14:00:00', '14:45:00', 45, 4),
(8, 'Customizable homogeneous functionalities', 1, 25, 'Live', '14:50:00', '15:35:00', 45, 4),
(9, 'Organic tangible open system', 1, 9, 'Live', '14:00:00', '14:45:00', 45, 5),
(17, 'Ergonomic actuating analyzer', 2, 6, 'Live', '14:00:00', '14:45:00', 45, 4),
(18, 'Advanced composite hierarchy', 2, 10, 'Live', '14:50:00', '15:35:00', 45, 4),
(19, 'Horizontal reciprocal artificial intelli', 2, 27, 'Live', '14:00:00', '14:45:00', 45, 5),
(21, 'Multi-layered zero tolerance functionali', 3, 23, 'Live', '14:00:00', '14:45:00', 45, 1),
(26, 'Multi-channeled asynchronous parallelism', 3, 20, 'Live', '14:50:00', '15:35:00', 45, 3),
(28, 'Optional optimal solution', 3, 6, 'Live', '14:50:00', '15:35:00', 45, 4),
(30, 'Polarized stable toolset', 3, 4, 'Live', '14:50:00', '15:35:00', 45, 5);

INSERT INTO performance (performance_id, name, event_id, artist_id, performance_type, start_time, end_time, duration, stage_id) VALUES
(3, 'Persistent system-worthy groupware', 1, 12, 'Live', '14:00:00', '14:45:00', 45, 2),
(6, 'Mandatory tertiary website', 1, 8, 'Live', '14:50:00', '15:35:00', 45, 3),
(10, 'Enterprise-wide discrete parallelism', 1, 21, 'Live', '14:50:00', '15:35:00', 45, 5),
(11, 'Centralized zero administration function', 2, 7, 'Live', '14:00:00', '14:45:00', 45, 1),
(12, 'Organic didactic definition', 2, 6, 'Live', '14:50:00', '15:35:00', 45, 1),
(13, 'Organic empowering intranet', 2, 6, 'Live', '14:00:00', '14:45:00', 45, 2),
(14, 'Focused fault-tolerant approach', 2, 29, 'Live', '14:50:00', '15:35:00', 45, 2),
(15, 'Optional intermediate solution', 2, 17, 'Live', '14:00:00', '14:45:00', 45, 3),
(16, 'Extended neutral infrastructure', 2, 21, 'Live', '14:50:00', '15:35:00', 45, 3),
(20, 'Optional bi-directional throughput', 2, 18, 'Live', '14:50:00', '15:35:00', 45, 5),
(22, 'Versatile heuristic superstructure', 3, 16, 'Live', '14:50:00', '15:35:00', 45, 1),
(23, 'Upgradable web-enabled parallelism', 3, 27, 'Live', '14:00:00', '14:45:00', 45, 2),
(24, 'Compatible didactic array', 3, 19, 'Live', '14:50:00', '15:35:00', 45, 2),
(25, 'User-friendly intangible encryption', 3, 13, 'Live', '14:00:00', '14:45:00', 45, 3),
(27, 'Total content-based encryption', 3, 7, 'Live', '14:00:00', '14:45:00', 45, 4),
(29, 'Optimized cohesive methodology', 3, 30, 'Live', '14:00:00', '14:45:00', 45, 5);