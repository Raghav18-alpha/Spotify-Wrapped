USE music_wrapped;
DELIMITER $$

CREATE TRIGGER trg_count_qualified_play AFTER INSERT ON listening_history
FOR EACH ROW
BEGIN
 IF NEW.ms_played >= 30000 THEN
   UPDATE songs SET play_count=play_count+1 WHERE song_id=NEW.song_id;
 END IF;
END$$

CREATE FUNCTION get_listener_type(p_user_id INT,p_year INT)
RETURNS VARCHAR(40) READS SQL DATA
BEGIN
 DECLARE n INT DEFAULT 0; DECLARE genres_n INT DEFAULT 0;
 DECLARE artists_n INT DEFAULT 0; DECLARE night_n INT DEFAULT 0;
 SELECT COUNT(*) INTO n FROM listening_history WHERE user_id=p_user_id AND YEAR(played_at)=p_year;
 IF n=0 THEN RETURN 'Quiet Year'; END IF;
 SELECT COUNT(DISTINCT s.genre_id) INTO genres_n
 FROM listening_history h JOIN songs s ON s.song_id=h.song_id
 WHERE h.user_id=p_user_id AND YEAR(h.played_at)=p_year;
 SELECT COUNT(DISTINCT sa.artist_id) INTO artists_n
 FROM listening_history h JOIN song_artist sa ON sa.song_id=h.song_id
 WHERE h.user_id=p_user_id AND YEAR(h.played_at)=p_year;
 SELECT COUNT(*) INTO night_n FROM listening_history
 WHERE user_id=p_user_id AND YEAR(played_at)=p_year AND HOUR(played_at) BETWEEN 0 AND 3;
 IF night_n/n > .30 THEN RETURN 'Night Owl'; END IF;
 IF genres_n >= 5 THEN RETURN 'Explorer'; END IF;
 IF artists_n <= 2 AND n >= 5 THEN RETURN 'Loyalist'; END IF;
 RETURN 'Mood Listener';
END$$

CREATE PROCEDURE generate_wrapped(IN p_user_id INT,IN p_year INT)
BEGIN
 DECLARE v_song INT DEFAULT NULL; DECLARE v_artist INT DEFAULT NULL;
 DECLARE v_minutes DECIMAL(12,2) DEFAULT 0; DECLARE v_streak INT DEFAULT 0;
 DECLARE v_type VARCHAR(40);
 SELECT song_id INTO v_song FROM listening_history
 WHERE user_id=p_user_id AND YEAR(played_at)=p_year
 GROUP BY song_id ORDER BY COUNT(*) DESC,song_id LIMIT 1;
 SELECT sa.artist_id INTO v_artist FROM listening_history h
 JOIN song_artist sa ON sa.song_id=h.song_id
 WHERE h.user_id=p_user_id AND YEAR(h.played_at)=p_year
 GROUP BY sa.artist_id ORDER BY COUNT(*) DESC,sa.artist_id LIMIT 1;
 SELECT COALESCE(SUM(ms_played)/60000,0) INTO v_minutes
 FROM listening_history WHERE user_id=p_user_id AND YEAR(played_at)=p_year;
 SELECT COALESCE(MAX(streak_len),0) INTO v_streak FROM (
   SELECT COUNT(*) streak_len FROM (
     SELECT d, DATE_SUB(d,INTERVAL ROW_NUMBER() OVER(ORDER BY d) DAY) grp FROM (
       SELECT DISTINCT DATE(played_at) d FROM listening_history
       WHERE user_id=p_user_id AND YEAR(played_at)=p_year
     ) dates
   ) numbered GROUP BY grp
 ) streaks;
 SET v_type=get_listener_type(p_user_id,p_year);
 INSERT INTO wrapped_summary(user_id,wrapped_year,top_song_id,top_artist_id,total_minutes,longest_streak,listener_type)
 VALUES(p_user_id,p_year,v_song,v_artist,v_minutes,v_streak,v_type)
 ON DUPLICATE KEY UPDATE top_song_id=VALUES(top_song_id),top_artist_id=VALUES(top_artist_id),
 total_minutes=VALUES(total_minutes),longest_streak=VALUES(longest_streak),
 listener_type=VALUES(listener_type),generated_at=CURRENT_TIMESTAMP;
END$$

CREATE PROCEDURE generate_wrapped_all(IN p_year INT)
BEGIN
 DECLARE done INT DEFAULT 0; DECLARE uid INT;
 DECLARE user_cur CURSOR FOR SELECT user_id FROM users;
 DECLARE CONTINUE HANDLER FOR NOT FOUND SET done=1;
 START TRANSACTION; OPEN user_cur;
 loop_users: LOOP
   FETCH user_cur INTO uid;
   IF done=1 THEN LEAVE loop_users; END IF;
   CALL generate_wrapped(uid,p_year);
 END LOOP;
 CLOSE user_cur; COMMIT;
END$$
DELIMITER ;

CREATE OR REPLACE VIEW v_user_wrapped AS
SELECT u.user_id,u.name,u.country,u.plan_type,w.wrapped_year,s.title top_song,
 a.name top_artist,w.total_minutes,w.longest_streak,w.listener_type,w.generated_at
FROM users u LEFT JOIN wrapped_summary w ON w.user_id=u.user_id
LEFT JOIN songs s ON s.song_id=w.top_song_id
LEFT JOIN artists a ON a.artist_id=w.top_artist_id;

CREATE OR REPLACE VIEW v_top_artists_global AS
SELECT a.artist_id,a.name artist_name,COUNT(*) qualified_plays
FROM listening_history h JOIN song_artist sa ON sa.song_id=h.song_id
JOIN artists a ON a.artist_id=sa.artist_id
WHERE h.ms_played>=30000 GROUP BY a.artist_id,a.name;
