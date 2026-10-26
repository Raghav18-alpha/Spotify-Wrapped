USE music_wrapped;
INSERT INTO users(user_id,name,email,country,join_date,plan_type) VALUES
(1,'Aarav Sharma','aarav@example.com','India','2022-04-10','PREMIUM'),
(2,'Maya Patel','maya@example.com','India','2023-01-20','FREE'),
(3,'Noah Williams','noah@example.com','USA','2021-09-15','PREMIUM'),
(4,'Isha Rao','isha@example.com','India','2024-06-02','FREE'),
(5,'Liam Chen','liam@example.com','Singapore','2022-11-11','PREMIUM');
INSERT INTO artists(artist_id,name,country) VALUES
(1,'The Midnight Echoes','India'),(2,'Nova Sky','USA'),(3,'Aria Bloom','UK'),
(4,'Neon Tigers','South Korea'),(5,'Coastal Lines','Australia'),(6,'DJ Orbit','India');
INSERT INTO albums(album_id,title,release_year,artist_id) VALUES
(1,'City Lights',2022,1),(2,'Blue Hour',2023,2),(3,'Wildflower',2021,3),
(4,'Neon Dreams',2024,4),(5,'Open Roads',2020,5),(6,'Orbit Sessions',2024,6);
INSERT INTO genres(genre_id,name) VALUES
(1,'Pop'),(2,'Indie'),(3,'Electronic'),(4,'Rock'),(5,'Lo-fi'),(6,'R&B');
INSERT INTO songs(song_id,title,duration_sec,album_id,genre_id) VALUES
(1,'Afterglow Avenue',213,1,2),(2,'Paper Moons',187,1,1),(3,'Midnight Signal',244,2,3),
(4,'Blue Hour',201,2,6),(5,'Wildflower Heart',228,3,1),(6,'Runaway Season',195,5,4),
(7,'Neon Skyline',221,4,3),(8,'Quiet Satellites',205,6,5),(9,'Golden Static',239,4,4),
(10,'Ocean Between Us',216,5,6),(11,'Small Hours',183,3,2),(12,'Orbiting',207,6,3);
INSERT INTO song_artist(song_id,artist_id,role) VALUES
(1,1,'MAIN'),(2,1,'MAIN'),(3,2,'MAIN'),(4,2,'MAIN'),(5,3,'MAIN'),(6,5,'MAIN'),
(7,4,'MAIN'),(8,6,'MAIN'),(9,4,'MAIN'),(10,5,'MAIN'),(11,3,'MAIN'),(12,6,'MAIN'),
(3,6,'FEATURED'),(7,2,'FEATURED');
INSERT INTO track_number(album_id,track_number,song_id) VALUES
(1,1,1),(1,2,2),(2,1,3),(2,2,4),(3,1,5),(3,2,11),
(4,1,7),(4,2,9),(5,1,6),(5,2,10),(6,1,8),(6,2,12);

INSERT INTO listening_history(user_id,song_id,played_at,ms_played,skipped) VALUES
(1,1,'2026-01-01 00:35:00',213000,0),(1,1,'2026-01-01 22:15:00',213000,0),
(1,3,'2026-01-02 01:10:00',244000,0),(1,3,'2026-01-03 00:50:00',244000,0),
(1,7,'2026-01-04 19:10:00',221000,0),(1,1,'2026-01-05 23:20:00',213000,0),
(1,5,'2026-02-10 12:00:00',228000,0),(1,3,'2026-03-12 01:20:00',244000,0),
(1,7,'2026-04-15 20:10:00',221000,0),(1,8,'2026-05-18 02:05:00',205000,0),
(1,3,'2026-06-20 00:40:00',244000,0),(1,9,'2026-07-21 21:30:00',239000,0),
(1,1,'2026-08-22 23:55:00',213000,0),(1,12,'2026-09-23 01:10:00',207000,0),
(1,2,'2026-10-01 22:00:00',187000,0),(1,3,'2026-11-02 00:15:00',244000,0),
(1,7,'2026-12-03 20:45:00',221000,0),(1,5,'2025-01-02 21:00:00',228000,0),
(2,2,'2026-01-01 08:10:00',187000,0),(2,2,'2026-01-02 08:10:00',187000,0),
(2,4,'2026-01-03 13:10:00',201000,0),(2,6,'2026-01-04 14:10:00',195000,0),
(2,10,'2026-02-04 17:10:00',216000,0),(2,2,'2026-03-05 08:10:00',187000,0),
(2,5,'2026-04-06 23:10:00',228000,0),(2,11,'2026-05-07 23:50:00',183000,0),
(3,3,'2026-01-01 02:10:00',244000,0),(3,3,'2026-01-02 02:10:00',244000,0),
(3,7,'2026-01-03 02:10:00',221000,0),(3,9,'2026-01-04 02:10:00',239000,0),
(3,12,'2026-02-04 02:10:00',207000,0),(3,8,'2026-03-05 02:10:00',205000,0),
(4,5,'2026-01-01 18:10:00',228000,0),(4,5,'2026-01-02 18:10:00',228000,0),
(4,1,'2026-01-03 18:10:00',213000,0),(4,2,'2026-02-04 18:10:00',187000,0),
(5,6,'2026-01-01 20:10:00',195000,0),(5,10,'2026-01-02 20:10:00',216000,0),
(5,6,'2026-01-03 20:10:00',195000,0),(5,10,'2026-02-04 20:10:00',216000,0);
