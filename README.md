# Spotify Wrapped — DBMS Course Project

A database-powered music-listening summary application built with **MySQL + Python + Streamlit**. The project is designed to make the DBMS work visible during a live teacher demonstration.

## Features

- **Your Wrapped:** select a sample listener and year, then generate a summary using a MySQL stored procedure.
- **DBMS Query Lab:** choose prepared SQL examples, inspect the query text, run it, and view actual MySQL results. Includes table listing, `SELECT`, `DESCRIBE`, `JOIN`, aggregate functions, views, and index inspection.
- **Schema Explorer:** browse actual tables/views, column types, nullability, keys, defaults, and preview sample rows.
- **Viva Guide:** short explanations of relational schema, keys, constraints, joins, aggregate functions, views, routines, triggers, and indexes.
- **SQL teaching files:** `database/schema.sql`, `seed.sql`, `analytics.sql`, `routines.sql`, `teacher_demo.sql`, `transaction_demo.sql`, and `benchmark.sql`.

## Requirements

- MySQL 8.x
- Python 3.10 or later
- The packages in `requirements.txt`

## Setup

1. Create/prepare the MySQL database and import the SQL files if this is a fresh installation. The schema script drops and recreates `music_wrapped`, so **do not rerun it if you need to preserve existing data**.
2. Create a file named `.env` in the same folder as `app.py`, using `.env.example` as a template:

   ```env
   DB_HOST=localhost
   DB_PORT=3306
   DB_NAME=music_wrapped
   DB_USER=root
   DB_PASSWORD=your_actual_mysql_password
   ```

3. Install packages in your virtual environment:

   ```powershell
   python -m pip install -r requirements.txt
   ```

4. Start the app:

   ```powershell
   python -m streamlit run app.py
   ```

5. Open the local URL printed by Streamlit (normally `http://localhost:8501`). Keep MySQL running.

## SQL import order (fresh setup only)

Run the commands in the MySQL client, adjusting the file path to your extracted folder:

```sql
SOURCE D:/path/to/Spotify_Wrapped_DBMS_Project/database/schema.sql;
SOURCE D:/path/to/Spotify_Wrapped_DBMS_Project/database/seed.sql;
SOURCE D:/path/to/Spotify_Wrapped_DBMS_Project/database/routines.sql;
```

## Teacher demonstration

Read [`DEMO_FOR_TEACHER.md`](DEMO_FOR_TEACHER.md). For a convenient live demonstration, open the app's **DBMS Query Lab** tab and run the visible prepared queries, then open **Schema Explorer**. The SQL source files are also available in the `database` folder for inspection in VS Code.

## Database concepts demonstrated

Relational tables, primary and foreign keys, constraints, joins, aggregate functions, grouping, views, stored procedures, stored functions, triggers, indexes, transactions, and advanced analytical SQL (CTEs/window functions, depending on the query).

All supplied names and listening records are fictional demo data.
