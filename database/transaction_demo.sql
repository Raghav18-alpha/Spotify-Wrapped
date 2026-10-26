USE music_wrapped;
START TRANSACTION;
CALL generate_wrapped(1,2026);
COMMIT;
SELECT * FROM wrapped_summary WHERE user_id=1 AND wrapped_year=2026;

-- Rollback test: row exists inside transaction but disappears after rollback.
START TRANSACTION;
INSERT INTO wrapped_summary(user_id,wrapped_year,total_minutes,longest_streak,listener_type)
VALUES(1,2099,999,99,'ROLLBACK DEMO');
SELECT * FROM wrapped_summary WHERE wrapped_year=2099;
ROLLBACK;
SELECT * FROM wrapped_summary WHERE wrapped_year=2099; -- should return zero rows
