DROP DATABASE IF EXISTS music_wrapped;
CREATE DATABASE music_wrapped CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE music_wrapped;

CREATE TABLE users (
 user_id INT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(100) NOT NULL,
 email VARCHAR(150) NOT NULL UNIQUE, country VARCHAR(80) NOT NULL,
 join_date DATE NOT NULL, plan_type ENUM('FREE','PREMIUM') NOT NULL DEFAULT 'FREE'
);
CREATE TABLE artists (
 artist_id INT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(120) NOT NULL, country VARCHAR(80)
);
CREATE TABLE albums (
 album_id INT AUTO_INCREMENT PRIMARY KEY, title VARCHAR(160) NOT NULL,
 release_year SMALLINT, artist_id INT NOT NULL,
 FOREIGN KEY (artist_id) REFERENCES artists(artist_id)
);
CREATE TABLE genres (
 genre_id INT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(80) NOT NULL UNIQUE
);
CREATE TABLE songs (
 song_id INT AUTO_INCREMENT PRIMARY KEY, title VARCHAR(160) NOT NULL,
 duration_sec INT NOT NULL CHECK (duration_sec > 0), album_id INT NOT NULL,
 genre_id INT NOT NULL, play_count BIGINT NOT NULL DEFAULT 0,
 FOREIGN KEY (album_id) REFERENCES albums(album_id),
 FOREIGN KEY (genre_id) REFERENCES genres(genre_id)
);
CREATE TABLE song_artist (
 song_id INT NOT NULL, artist_id INT NOT NULL, role ENUM('MAIN','FEATURED') NOT NULL DEFAULT 'MAIN',
 PRIMARY KEY(song_id,artist_id),
 FOREIGN KEY(song_id) REFERENCES songs(song_id) ON DELETE CASCADE,
 FOREIGN KEY(artist_id) REFERENCES artists(artist_id)
);
-- Weak/dependent entity: track number exists only within an album.
CREATE TABLE track_number (
 album_id INT NOT NULL, track_number SMALLINT NOT NULL, song_id INT NOT NULL,
 PRIMARY KEY(album_id,track_number), UNIQUE KEY uq_album_song(album_id,song_id),
 FOREIGN KEY(album_id) REFERENCES albums(album_id) ON DELETE CASCADE,
 FOREIGN KEY(song_id) REFERENCES songs(song_id) ON DELETE CASCADE
);
CREATE TABLE listening_history (
 listen_id BIGINT AUTO_INCREMENT PRIMARY KEY, user_id INT NOT NULL, song_id INT NOT NULL,
 played_at DATETIME NOT NULL, ms_played INT NOT NULL CHECK(ms_played >= 0),
 skipped BOOLEAN NOT NULL DEFAULT FALSE,
 FOREIGN KEY(user_id) REFERENCES users(user_id) ON DELETE CASCADE,
 FOREIGN KEY(song_id) REFERENCES songs(song_id),
 INDEX idx_history_user_time(user_id,played_at),
 INDEX idx_history_song_time(song_id,played_at)
);
CREATE TABLE wrapped_summary (
 user_id INT NOT NULL, wrapped_year SMALLINT NOT NULL, top_song_id INT NULL,
 top_artist_id INT NULL, total_minutes DECIMAL(12,2) NOT NULL DEFAULT 0,
 longest_streak INT NOT NULL DEFAULT 0, listener_type VARCHAR(40) NOT NULL DEFAULT 'Listener',
 generated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
 PRIMARY KEY(user_id,wrapped_year),
 FOREIGN KEY(user_id) REFERENCES users(user_id) ON DELETE CASCADE,
 FOREIGN KEY(top_song_id) REFERENCES songs(song_id),
 FOREIGN KEY(top_artist_id) REFERENCES artists(artist_id)
);
