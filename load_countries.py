import requests
import snowflake.connector
import pandas as pd

# Fetch from REST Countries API
print("Fetching countries data from API...")
response = requests.get('https://restcountries.com/v3.1/all')

# Parse response
countries = response.json()

# Check if response is valid
print(f"Response type: {type(countries)}")
print(f"First item type: {type(countries[0])}")

# Parse data
data = []
for c in countries:
    if isinstance(c, dict):
        data.append({
            'country_code': c.get('cca2', ''),
            'country_name': c.get('name', {}).get('common', ''),
            'region': c.get('region', ''),
            'subregion': c.get('subregion', ''),
            'population': c.get('population', 0),
            'currency': list(c.get('currencies', {}).keys())[0] if c.get('currencies') else ''
        })

df = pd.DataFrame(data)
print(f"Fetched {len(df)} countries!")

# Connect to Snowflake
print("Connecting to Snowflake...")
conn = snowflake.connector.connect(
    user='PandaIlan',
    password='PandaIlan9123456!!',
    account='DJ36883.me-central-1.aws',
    warehouse='AIRBNB_WH',
    database='AIRBNB_DB',
    schema='RAW'
)

cursor = conn.cursor()

# Create table
print("Creating table...")
cursor.execute("""
    CREATE OR REPLACE TABLE AIRBNB_DB.RAW.COUNTRIES (
        country_code    VARCHAR,
        country_name    VARCHAR,
        region          VARCHAR,
        subregion       VARCHAR,
        population      NUMBER,
        currency        VARCHAR
    )
""")

# Insert data
print("Inserting data...")
rows = [
    (
        str(row['country_code']),
        str(row['country_name']),
        str(row['region']),
        str(row['subregion']),
        int(row['population']),
        str(row['currency'])
    )
    for _, row in df.iterrows()
]

cursor.executemany(
    "INSERT INTO AIRBNB_DB.RAW.COUNTRIES VALUES (%s, %s, %s, %s, %s, %s)",
    rows
)

print(f"Successfully loaded {len(rows)} countries into Snowflake!")
cursor.close()
conn.close()