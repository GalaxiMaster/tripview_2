# apply_fixes.py
import csv
import sqlite3
import sys

db_path  = sys.argv[1]  # e.g. C:/tripview_2/assets/stops.db
csv_path = sys.argv[2]  # e.g. type_mismatches.csv

conn = sqlite3.connect(db_path)
cur  = conn.cursor()

with open(csv_path, encoding='utf-8') as f:
    rows = list(csv.DictReader(f))

for row in rows:
    cur.execute(
        "UPDATE stops SET type = ? WHERE stop_id = ?",
        (int(row['gtfs_type']), row['stop_id'])
    )

conn.commit()
conn.close()
print(f"Updated {len(rows)} stops.")