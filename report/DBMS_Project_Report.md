# Spotify-Style Wrapped Generator — DBMS Mini Project Report

## Abstract
This project turns raw music-listening events into a personalized annual summary. MySQL stores normalized user and music-catalog data, while SQL queries calculate rankings, listening minutes, streaks, night-owl behavior and taste overlap. A Streamlit interface displays the results.

## Problem statement and objectives
Raw listening events are too numerous to interpret manually. The system stores the events consistently and derives a concise annual summary. Objectives: design relational tables; demonstrate normalization; use joins, aggregates, CTEs, subqueries and window functions; implement a trigger, function, stored procedure, cursor and views; demonstrate transactions and indexing; build a simple front end.

## ER model
- USER 1:M LISTENING_HISTORY; SONG 1:M LISTENING_HISTORY.
- ALBUM 1:M SONG; GENRE 1:M SONG.
- SONG M:N ARTIST through SONG_ARTIST, which stores MAIN/FEATURED role.
- ALBUM 1:M TRACK_NUMBER. TRACK_NUMBER is a weak/dependent entity with composite key `(album_id, track_number)`.
- USER 1:M WRAPPED_SUMMARY, one per user/year.
- Conceptual specialization: FREE_USER and PREMIUM_USER are subtypes of USER; physical implementation uses `plan_type`.

## Relational schema
USERS(**user_id**, name, email, country, join_date, plan_type)
ARTISTS(**artist_id**, name, country)
ALBUMS(**album_id**, title, release_year, artist_id FK)
GENRES(**genre_id**, name)
SONGS(**song_id**, title, duration_sec, album_id FK, genre_id FK, play_count)
SONG_ARTIST(**song_id** FK, **artist_id** FK, role)
TRACK_NUMBER(**album_id** FK, **track_number**, song_id FK)
LISTENING_HISTORY(**listen_id**, user_id FK, song_id FK, played_at, ms_played, skipped)
WRAPPED_SUMMARY(**user_id** FK, **wrapped_year**, top_song_id FK, top_artist_id FK, total_minutes, longest_streak, listener_type, generated_at)

## Normalization walkthrough
Start from a flat relation:
`FLAT_LISTEN(user_email, user_name, country, song_title, album_title, genre_name, artist_name, played_at, ms_played, skipped)`

Use stable IDs as determinants because titles and names need not be unique:
- user_id → name, email, country, join_date, plan_type
- song_id → title, duration_sec, album_id, genre_id
- album_id → title, release_year, album artist
- genre_id → genre name
- listen_id → user_id, song_id, played_at, ms_played, skipped
- (song_id, artist_id) → role

**1NF:** each column is atomic and every play is one row; artist lists are not stored as comma-separated values.
**2NF:** move user and song attributes that depend only on part of a composite/event key into USERS and SONGS.
**3NF:** remove transitive dependencies, e.g. song_id → genre_id → genre_name, by storing genre names only in GENRES.
**BCNF:** each non-trivial determinant is a candidate/superkey within its relation. SONG_ARTIST uses its composite key; TRACK_NUMBER uses `(album_id, track_number)`.
**Anomalies:** updates to genre names happen once; artists/albums can be inserted before a play exists; deleting a play does not delete catalog details. Foreign keys support valid joins and lossless reconstruction across event/catalog tables. Dependencies are represented in the entity tables and bridge table.

## SQL and programming objects
- CTE + DENSE_RANK: top five songs per user.
- Window functions: ROW_NUMBER for streak grouping; LAG for previous month's genre.
- Aggregation: COUNT, SUM, AVG, GROUP BY, HAVING.
- Subqueries: users above their country's average.
- Set difference: `NOT EXISTS` selects H1 songs not heard in H2 (MySQL-compatible alternative to EXCEPT).
- Procedure `generate_wrapped(user_id, year)` saves one annual summary.
- Cursor procedure `generate_wrapped_all(year)` processes all users.
- Function `get_listener_type(user_id, year)` labels Night Owl, Explorer, Loyalist or Mood Listener.
- Trigger updates songs.play_count for history events with at least 30 seconds played.
- `v_user_wrapped` omits email; `v_top_artists_global` gives a global artist ranking.

## Transactions and index experiment
`transaction_demo.sql` demonstrates COMMIT and a temporary row removed with ROLLBACK. `benchmark.sql` uses `EXPLAIN ANALYZE` on a user/year top-song query. Load more history, record measured timing with the composite `(user_id, played_at)` index, then compare with the index removed and recreated. Do not invent a speedup; report actual measurements from your machine.

## Test checklist
1. Import schema.sql, seed.sql and routines.sql in that order.
2. Run `CALL generate_wrapped(1,2026);`
3. Check `SELECT * FROM v_user_wrapped;`
4. Check `SELECT * FROM v_top_artists_global ORDER BY qualified_plays DESC;`
5. Test trigger with history rows below and above 30 seconds.
6. Run transaction_demo.sql; year 2099 rollback row should not remain.
7. Run `streamlit run app.py`.
8. Generate 100,000+ history rows and compare EXPLAIN ANALYZE timings.

## Conclusion
The project shows how normalized relational data and SQL analytics can produce a useful user-facing product while keeping the database central to the application.
