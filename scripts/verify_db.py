import sqlite3

con = sqlite3.connect('assets/old/most recent/stops.db')
cur = con.cursor()

cur.execute('''
    CREATE VIRTUAL TABLE IF NOT EXISTS stops_fts
    USING fts5(stop_name, content='stops', content_rowid='rowid')
''')
cur.execute("INSERT INTO stops_fts(stops_fts) VALUES ('rebuild')")


cur.execute("SELECT COUNT(*) FROM stops_fts")
print(f"FTS rows indexed: {cur.fetchone()[0]:,}")

# Check the table exists in sqlite_master
cur.execute("SELECT name FROM sqlite_master WHERE type='table' ORDER BY name")
print("Tables in stops.db:", [row[0] for row in cur.fetchall()])

# Do a test search
cur.execute("SELECT stop_name FROM stops_fts WHERE stops_fts MATCH 'Central' LIMIT 5")
print("Test search for 'Central':", [row[0] for row in cur.fetchall()])


con.commit()
con.close()
print("FTS index built.")