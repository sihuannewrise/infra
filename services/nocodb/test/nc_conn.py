import http.client

conn = http.client.HTTPSConnection("nocodb.knh.cloud")

headers = {"xc-token": "IlHmicaslod_aRVFvXS6oUVj4eW-2NYqQzrSSZGF"}
baseUrl = "https://nocodb.knh.cloud/api/v2"
tableIdBeeline = "mpmbm8wsz4g9cza"

conn.request("PATCH", "{baseUrl}/meta/columns/{tableId}", headers=headers)

res = conn.getresponse()
data = res.read()

print(data.decode("utf-8"))
