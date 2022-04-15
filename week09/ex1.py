import psycopg2
from geopy.geocoders import Nominatim

geolocator = Nominatim(user_agent="firefox")
con = psycopg2.connect(database="dvdrental", user="postgres", password="postgres", host="127.0.0.1", port="5432")

print("Database opened successfully")

cur = con.cursor()
cur.execute('select * from fetch_addresses();')
rows = cur.fetchall()
print("Fetch ok")
print(rows)
addrs = []
for row in rows:
    location = None
    try:
        location = geolocator.geocode(row[1])
    except Exception as e:
        pass
    if location is None:
        addrs.append("(0,0)")
    else:
        addrs.append(f"({location.latitude},{location.longitude})")
print(addrs)
   
for i, row in enumerate(rows):
    cur.execute(f'update address set geo_coords={addrs[i]} where address_id={row[0]};')
con.commit()
con.close()
print('Database closed')
