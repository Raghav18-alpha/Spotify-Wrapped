USE music_wrapped;
-- Top 5 songs per user/year using CTE + DENSE_RANK.
WITH play_counts AS (
 SELECT user_id,song_id,COUNT(*) plays FROM listening_history
 WHERE played_at>='2026-01-01' AND played_at<'2027-01-01'
 GROUP BY user_id,song_id
), ranked AS (
 SELECT *,DENSE_RANK() OVER(PARTITION BY user_id ORDER BY plays DESC) rnk FROM play_counts
)
SELECT u.name,s.title,r.plays,r.rnk FROM ranked r
JOIN users u ON u.user_id=r.user_id JOIN songs s ON s.song_id=r.song_id
WHERE r.rnk<=5 ORDER BY u.name,r.rnk;

-- Longest consecutive-day listening streak (LAG/window-style date grouping).
WITH dates AS (
 SELECT DISTINCT user_id,DATE(played_at) d FROM listening_history WHERE YEAR(played_at)=2026
), numbered AS (
 SELECT user_id,d,DATE_SUB(d,INTERVAL ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY d) DAY) grp FROM dates
), streaks AS (
 SELECT user_id,grp,COUNT(*) days FROM numbered GROUP BY user_id,grp
)
SELECT u.name,MAX(days) longest_streak FROM streaks JOIN users u USING(user_id)
GROUP BY u.user_id,u.name ORDER BY longest_streak DESC;

-- Night Owl: more than 30% of plays between 00:00 and 03:59.
SELECT u.name,SUM(HOUR(h.played_at) BETWEEN 0 AND 3) night_plays,COUNT(*) all_plays,
 ROUND(100*SUM(HOUR(h.played_at) BETWEEN 0 AND 3)/COUNT(*),1) night_percent
FROM users u JOIN listening_history h USING(user_id) WHERE YEAR(h.played_at)=2026
GROUP BY u.user_id,u.name HAVING night_percent>30;

-- Monthly favorite genre, with previous month via LAG.
WITH counts AS (
 SELECT h.user_id,DATE_FORMAT(h.played_at,'%Y-%m') month_key,g.name genre_name,COUNT(*) plays
 FROM listening_history h JOIN songs s USING(song_id) JOIN genres g USING(genre_id)
 WHERE YEAR(h.played_at)=2026 GROUP BY h.user_id,month_key,g.genre_id,g.name
), ranked AS (
 SELECT *,ROW_NUMBER() OVER(PARTITION BY user_id,month_key ORDER BY plays DESC,genre_name) rn FROM counts
), winners AS (SELECT * FROM ranked WHERE rn=1)
SELECT u.name,w.month_key,w.genre_name,LAG(w.genre_name) OVER(PARTITION BY w.user_id ORDER BY w.month_key) previous_genre
FROM winners w JOIN users u USING(user_id) ORDER BY u.name,w.month_key;

-- Similar taste: shared songs between users.
SELECT DISTINCT u1.name user_one,u2.name user_two,s.title shared_song
FROM listening_history h1 JOIN listening_history h2 ON h1.song_id=h2.song_id AND h1.user_id<h2.user_id
JOIN users u1 ON u1.user_id=h1.user_id JOIN users u2 ON u2.user_id=h2.user_id
JOIN songs s ON s.song_id=h1.song_id
WHERE YEAR(h1.played_at)=2026 AND YEAR(h2.played_at)=2026;

-- Users whose minutes exceed the average for their country.
SELECT u.name,u.country,SUM(h.ms_played)/60000 minutes
FROM users u JOIN listening_history h USING(user_id)
WHERE YEAR(h.played_at)=2026 GROUP BY u.user_id,u.name,u.country
HAVING minutes > (SELECT AVG(x.mins) FROM (
 SELECT u2.user_id,SUM(h2.ms_played)/60000 mins FROM users u2
 JOIN listening_history h2 USING(user_id) WHERE u2.country=u.country AND YEAR(h2.played_at)=2026
 GROUP BY u2.user_id
) x);

-- MySQL-compatible set difference: H1 songs that do not appear in H2 (NOT EXISTS).
SELECT DISTINCT s.song_id,s.title FROM listening_history h JOIN songs s USING(song_id)
WHERE h.user_id=1 AND h.played_at>='2026-01-01' AND h.played_at<'2026-07-01'
AND NOT EXISTS (SELECT 1 FROM listening_history h2 WHERE h2.user_id=1 AND h2.song_id=h.song_id
 AND h2.played_at>='2026-07-01' AND h2.played_at<'2027-01-01');
