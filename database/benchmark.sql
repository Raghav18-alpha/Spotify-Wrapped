USE music_wrapped;
-- Run after loading many rows. Compare EXPLAIN ANALYZE before and after the index.
EXPLAIN ANALYZE
SELECT song_id,COUNT(*) plays FROM listening_history
WHERE user_id=1 AND played_at>='2026-01-01' AND played_at<'2027-01-01'
GROUP BY song_id ORDER BY plays DESC LIMIT 5;

-- Test only on a test database:
-- ALTER TABLE listening_history DROP INDEX idx_history_user_time;
-- Re-run EXPLAIN ANALYZE and record time.
-- CREATE INDEX idx_history_user_time ON listening_history(user_id,played_at);
-- Re-run EXPLAIN ANALYZE and compare measured results.
