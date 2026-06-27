# 2: normal trains
# 4: ferry
# 106: regional trains
# 204: regional trains and coaches
# 205: temporary coaches
# 401: metro line
# 700: sydney buses
# 712: school buses
# 714: temporary buses
# 900: light rail

import pandas as pd

ROUTES_DTYPES = {'route_id': str, 'route_type': str}
TRIPS_DTYPES  = {'route_id': str, 'trip_id': str}
STIMES_DTYPES = {'trip_id': str, 'stop_id': str}
STOPS_DTYPES  = {'stop_id': str, 'parent_station': str}  # added parent_station

# 1. Load routes and identify unwanted route IDs
routes = pd.read_csv('assets/routes.csv', dtype=ROUTES_DTYPES)
routes['route_type'] = pd.to_numeric(routes['route_type'], errors='coerce')
unwanted_route_ids = set(routes[routes['route_type'].isin([700, 712])]['route_id'])
print(f"Found {len(unwanted_route_ids)} unwanted route IDs (types 700 and 712)")

# 2. Filter trips
trips = pd.read_csv('assets/trips.csv', dtype=TRIPS_DTYPES, low_memory=False)
filtered_trips = trips[~trips['route_id'].isin(unwanted_route_ids)]
filtered_trips.to_csv('assets/trips_cleaned.csv', index=False)
print(f"Trips:      {len(trips):>8,} -> {len(filtered_trips):>8,} (removed {len(trips) - len(filtered_trips):,})")

# 3. Filter stop_times in chunks, collecting valid stop IDs in the same pass
valid_trip_ids = set(filtered_trips['trip_id'])
valid_stop_ids = set()
chunk_size = 100_000
first_chunk = True

for chunk in pd.read_csv('assets/stop_times.csv', chunksize=chunk_size, dtype=STIMES_DTYPES):
    filtered_chunk = chunk[chunk['trip_id'].isin(valid_trip_ids)]
    valid_stop_ids.update(filtered_chunk['stop_id'].unique())

    mode = 'w' if first_chunk else 'a'
    filtered_chunk.to_csv('assets/stop_times_cleaned.csv', mode=mode, index=False, header=first_chunk)
    first_chunk = False

print(f"stop_times: chunked filtering done. {len(valid_stop_ids):,} unique stops still referenced.")

# 4. Filter stops — first pass: stops that appear in stop_times
stops = pd.read_csv('assets/stops.csv', dtype=STOPS_DTYPES)
filtered_stops = stops[stops['stop_id'].isin(valid_stop_ids)]

# Second pass: parent stations (location_type=1) are never in stop_times directly —
# they're referenced via parent_station on child stops, so we need to add them back
valid_parent_ids = set(filtered_stops['parent_station'].dropna().unique())
parent_stations = stops[stops['stop_id'].isin(valid_parent_ids)]
filtered_stops = pd.concat([filtered_stops, parent_stations]).drop_duplicates(subset='stop_id')

filtered_stops.to_csv('assets/stops_cleaned.csv', index=False)
print(f"Stops:      {len(stops):>8,} -> {len(filtered_stops):>8,} (removed {len(stops) - len(filtered_stops):,})")
print(f"  (includes {len(parent_stations):,} parent stations re-added from parent_station references)")

print("\nDone. Files written: trips_cleaned.csv, stop_times_cleaned.csv, stops_cleaned.csv")