# test_trip.py
import requests
from datetime import datetime

API_KEY  = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiIweC1vR25DelZRdlk4cUZxZm1yRmhrSl9jZzc3d05ueENBLXF3R1JTNGlvIiwiaWF0IjoxNzgyMzYyMTIyfQ.2p0Dt0xE_ePWEggmRUaR5Tl9DEYMSzMmzUZtaM7Ow2I'
ORIGIN   = '222010'   # e.g. Hurstville
DEST     = '200060'   # e.g. Central

now = datetime.now()

# response = requests.get(
#     'https://api.transport.nsw.gov.au/v1/tp/trip',
#     headers={'Authorization': f'apikey {API_KEY}'},
#     params={
#         'outputFormat':       'rapidJSON',
#         'coordOutputFormat':  'EPSG:4326',
#         'depArrMacro':        'dep',               # departing at time below
#         'itdDate':            now.strftime('%Y%m%d'),
#         'itdTime':            now.strftime('%H%M'),
#         'type_origin':        'stop',
#         'name_origin':        ORIGIN,
#         'type_destination':   'stop',
#         'name_destination':   DEST,
#         'calcNumberOfTrips':  5,                   # return 5 journey options
#         'TfNSWTR':            'true',
#     }
# )

# import json
# print(json.dumps(response, indent=2))

response = requests.get('http://192.168.0.71:8000/gtfs.db.gz', stream=True)
    
# Ensure the request was successful
response.raise_for_status()

# Write the raw response content to a file in binary mode
with open("gtfs.db.gz", 'wb') as f:
    for chunk in response.iter_content(chunk_size=8192):
        if chunk:
            f.write(chunk)