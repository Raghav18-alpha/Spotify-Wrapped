# Teacher Demonstration Guide — Spotify Wrapped DBMS Project

## Recommended live demo (5–7 minutes)

### 1. Show the real MySQL database (1 minute)
Open the MySQL command-line client and run:

```sql
SHOW DATABASES;
USE music_wrapped;
SHOW TABLES;
```

Explain that MySQL stores the application's relational data.

### 2. Show table structure and constraints (1 minute)

```sql
DESCRIBE users;
DESCRIBE listening_history;
SHOW CREATE TABLE listening_history;
```

Point out primary keys, foreign keys, column data types, and indexes.

### 3. Show SELECT, aggregate functions, and GROUP BY (1 minute)

```sql
SELECT plan_type, COUNT(*) AS total_users
FROM users
GROUP BY plan_type;

SELECT song_id, COUNT(*) AS plays
FROM listening_history
GROUP BY song_id
ORDER BY plays DESC
LIMIT 5;
```

Explain that `COUNT`, `GROUP BY`, and `ORDER BY` summarize and rank the data.

### 4. Show a JOIN (1 minute)

```sql
SELECT u.name AS listener, s.title AS song, h.played_at
FROM listening_history h
JOIN users u ON u.user_id = h.user_id
JOIN songs s ON s.song_id = h.song_id
ORDER BY h.played_at
LIMIT 10;
```

Explain that foreign-key relationships let one query combine data from multiple tables.

### 5. Show database objects (1 minute)

```sql
SELECT * FROM v_top_artists_global ORDER BY qualified_plays DESC LIMIT 10;
SELECT name, get_listener_type(user_id, 2026) AS listener_type FROM users;
SHOW INDEX FROM listening_history;
```

Explain the view, stored function, and indexes. If the function/view does not exist, import `database/routines.sql` once.

### 6. Show the project interface (1 minute)
Run the app and open the **DBMS Query Lab** tab. Select a prepared query, point to the visible SQL, click **Run this SQL query**, and explain the result. Then open **Schema Explorer** to show table/view names and column definitions. Finally, use **Your Wrapped** to generate a listener's summary; this calls the MySQL `generate_wrapped` stored procedure.

## Start the project

1. Start the MySQL server and make sure database `music_wrapped` exists.
2. Create `.env` next to `app.py` using `.env.example` as a template; enter your own MySQL password.
3. Activate your Python virtual environment, then run `python -m streamlit run app.py`.
4. Keep MySQL running while using the app.

## Important safety note
`database/schema.sql` begins by dropping and recreating `music_wrapped`. Do not run it again against a database you need to preserve unless you intentionally want to erase and rebuild that project database. `database/teacher_demo.sql` includes a stored-procedure call that inserts/updates 2026 summary rows; the in-app DBMS Query Lab uses prepared read-only queries.

All names and music activity are fictional sample data.
