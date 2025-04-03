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
