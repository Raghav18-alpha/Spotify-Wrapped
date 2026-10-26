import os
import mysql.connector
from dotenv import load_dotenv
load_dotenv()

def get_connection():
    return mysql.connector.connect(
        host=os.getenv("DB_HOST","localhost"),
        port=int(os.getenv("DB_PORT","3306")),
        database=os.getenv("DB_NAME","music_wrapped"),
        user=os.getenv("DB_USER","root"),
        password=os.getenv("DB_PASSWORD","")
    )

def fetch_all(sql, params=()):
    conn=get_connection()
    try:
        cur=conn.cursor(dictionary=True)
        cur.execute(sql,params)
        return cur.fetchall()
    finally:
        conn.close()
