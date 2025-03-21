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