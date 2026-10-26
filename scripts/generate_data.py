import argparse,os,random
from datetime import datetime,timedelta
import mysql.connector
from dotenv import load_dotenv
load_dotenv()
p=argparse.ArgumentParser()
p.add_argument('--rows',type=int,default=100000)
n=p.parse_args().rows
if n<1: raise SystemExit('--rows must be positive')
conn=mysql.connector.connect(host=os.getenv('DB_HOST','localhost'),port=int(os.getenv('DB_PORT','3306')),database=os.getenv('DB_NAME','music_wrapped'),user=os.getenv('DB_USER','root'),password=os.getenv('DB_PASSWORD',''))
cur=conn.cursor()
cur.execute('SELECT user_id FROM users'); users=[x[0] for x in cur.fetchall()]
cur.execute('SELECT song_id FROM songs'); songs=[x[0] for x in cur.fetchall()]
if not users or not songs: raise SystemExit('Run schema.sql and seed.sql first.')
start=datetime(2025,1,1); span=int((datetime(2026,12,31,23,59,59)-start).total_seconds())
weights=list(range(len(songs),0,-1)); batch=[]
for i in range(n):
    uid=random.choice(users); sid=random.choices(songs,weights=weights,k=1)[0]
    dt=start+timedelta(seconds=random.randint(0,span))
    ms=random.choice([random.randint(5000,29000),random.randint(30000,260000)])
    batch.append((uid,sid,dt.strftime('%Y-%m-%d %H:%M:%S'),ms,ms<30000))
    if len(batch)>=2000:
        cur.executemany('INSERT INTO listening_history(user_id,song_id,played_at,ms_played,skipped) VALUES(%s,%s,%s,%s,%s)',batch); conn.commit(); batch=[]
if batch:
    cur.executemany('INSERT INTO listening_history(user_id,song_id,played_at,ms_played,skipped) VALUES(%s,%s,%s,%s,%s)',batch); conn.commit()
cur.close(); conn.close()
print(f'Inserted {n:,} listening-history rows.')
