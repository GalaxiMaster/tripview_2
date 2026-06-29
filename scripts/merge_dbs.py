import sqlite3, pandas as pd

def merge_dbs(path: str ='assets/'):
    out = sqlite3.connect('assets/gtfs.db')

    for table, file in {
        'stops':          'stops.db',
        'stop_times':     'stop_times.db',
        'trips':          'trips.db',
        'routes':         'routes.db',
        'calendar':       'calendar.db',
        'calendar_dates': 'calendar_dates.db',
    }.items():
        src = sqlite3.connect(f'{path}{file}')
        pd.read_sql(f'SELECT * FROM {table}', src).to_sql(table, out, if_exists='replace', index=False)
        src.close()

    out.close()