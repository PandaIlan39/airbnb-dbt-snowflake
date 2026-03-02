# 🏠 Airbnb Analytics Pipeline | dbt + Snowflake

A complete end-to-end data engineering portfolio project built with dbt and Snowflake,
transforming raw Airbnb listings data into clean, analytics-ready models.

---

## 🏗️ Architecture
```
Raw CSV (Airbnb) ──→ Snowflake RAW Schema ──→ dbt Staging ──→ dbt Marts ──→ Analytics
Countries Seed   ──→ Snowflake RAW Schema ──→ dbt Marts   ──→ Analytics
```

---

## 📊 Data Sources

| Source | Type | Description |
|--------|------|-------------|
| Inside Airbnb | CSV | 102,599 NYC Airbnb listings |
| Countries Reference | dbt Seed | Country data (region, population, currency) |

---

## 🔄 Data Models

### Staging Layer
| Model | Description | Rows |
|-------|-------------|------|
| `stg_listings` | Cleaned Airbnb listings with price normalization | 102,599 |

### Marts Layer
| Model | Description |
|-------|-------------|
| `pricing_analysis` | Average, min, max prices per neighbourhood and room type |
| `host_performance` | Host rankings by listings, reviews and availability |
| `combined_analysis` | Airbnb listings enriched with country reference data |

---

## 🛠️ Tech Stack

- **Snowflake** — Cloud data warehouse
- **dbt Core** — Data transformation and modeling
- **Python 3.11** — Data ingestion scripts
- **Git & GitHub** — Version control
- **SQL** — Data transformation logic

---

## 📁 Project Structure
```
airbnb_project/
├── models/
│   ├── staging/
│   │   ├── stg_listings.sql      ← Raw data cleaning and normalization
│   │   └── schema.yml            ← Source definitions and data quality tests
│   └── marts/
│       ├── pricing_analysis.sql  ← Price insights by neighbourhood and room type
│       ├── host_performance.sql  ← Host ranking and performance analysis
│       └── combined_analysis.sql ← Enriched listings joined with country data
├── seeds/
│   └── countries.csv             ← Country reference data
├── dbt_project.yml               ← dbt project configuration
└── README.md
```

---

## 🚀 How to Run This Project

### Prerequisites
Before you start make sure you have the following installed and ready:
- A free Snowflake account — sign up at snowflake.com
- Python 3.11 — download at python.org (important: do NOT use Python 3.12 or higher)
- dbt-snowflake installed

---

### Step 1: Clone the Repository
Open Command Prompt and run:
```bash
git clone https://github.com/PandaIlan39/airbnb-dbt-snowflake.git
cd airbnb-dbt-snowflake
```

---

### Step 2: Install dbt
```bash
pip install dbt-snowflake
```
Verify it installed correctly:
```bash
dbt --version
```

---

### Step 3: Set Up Snowflake
Log into your Snowflake account and run this SQL to create the required objects:
```sql
USE ROLE ACCOUNTADMIN;

CREATE WAREHOUSE IF NOT EXISTS AIRBNB_WH
  WAREHOUSE_SIZE = 'X-SMALL'
  AUTO_SUSPEND = 60
  AUTO_RESUME = TRUE;

CREATE DATABASE IF NOT EXISTS AIRBNB_DB;
CREATE SCHEMA IF NOT EXISTS AIRBNB_DB.RAW;

USE WAREHOUSE AIRBNB_WH;
USE DATABASE AIRBNB_DB;
USE SCHEMA RAW;
```

---

### Step 4: Load the Airbnb Data
1. Download the Airbnb NYC dataset from kaggle.com
   - Search for "Airbnb Open Data" on Kaggle
   - Download the CSV file
2. In Snowflake UI go to Data → Add Data → Load files into a Stage
3. Create a stage called `AIRBNB_STAGE` and upload the CSV file
4. Run this to load the data:
```sql
CREATE OR REPLACE TABLE AIRBNB_DB.RAW.LISTINGS (
    id NUMBER, NAME VARCHAR, host_id NUMBER,
    host_identity_verified VARCHAR, host_name VARCHAR,
    neighbourhood_group VARCHAR, neighbourhood VARCHAR,
    lat FLOAT, long FLOAT, country VARCHAR,
    country_code VARCHAR, instant_bookable VARCHAR,
    cancellation_policy VARCHAR, room_type VARCHAR,
    construction_year NUMBER, price VARCHAR,
    service_fee VARCHAR, minimum_nights NUMBER,
    number_of_reviews NUMBER, last_review DATE,
    reviews_per_month FLOAT, review_rate_number NUMBER,
    calculated_host_listings_count NUMBER,
    availability_365 NUMBER, house_rules VARCHAR,
    license VARCHAR
);

COPY INTO AIRBNB_DB.RAW.LISTINGS
FROM @AIRBNB_STAGE
FILE_FORMAT = (
    TYPE = 'CSV'
    FIELD_OPTIONALLY_ENCLOSED_BY = '"'
    PARSE_HEADER = TRUE
    NULL_IF = ('', 'NULL')
    EMPTY_FIELD_AS_NULL = TRUE
)
MATCH_BY_COLUMN_NAME = CASE_INSENSITIVE
ON_ERROR = 'CONTINUE';
```

---

### Step 5: Configure dbt Connection
```bash
dbt init airbnb_project
```
Fill in your Snowflake details when prompted:
- account → your Snowflake account (found in your URL before .snowflakecomputing.com)
- user → your Snowflake username
- password → your Snowflake password
- role → ACCOUNTADMIN
- warehouse → AIRBNB_WH
- database → AIRBNB_DB
- schema → RAW
- threads → 1

Test the connection:
```bash
dbt debug
```
You should see: `All checks passed!`

---

### Step 6: Run the Pipeline
```bash
# Load reference data
dbt seed

# Run all transformation models
dbt run

# Run data quality tests
dbt test

# View documentation and lineage diagram
dbt docs generate
dbt docs serve
```
Then open your browser at `http://localhost:8080`

---

### Step 7: Verify in Snowflake
```sql
SELECT * FROM AIRBNB_DB.RAW.STG_LISTINGS LIMIT 10;
SELECT * FROM AIRBNB_DB.RAW.PRICING_ANALYSIS ORDER BY avg_price DESC;
SELECT * FROM AIRBNB_DB.RAW.HOST_PERFORMANCE ORDER BY total_listings DESC;
SELECT * FROM AIRBNB_DB.RAW.COMBINED_ANALYSIS LIMIT 10;
```

---

## 📈 Key Insights Available
- Average Airbnb price per neighbourhood in NYC
- Most active hosts ranked by number of listings
- Room type distribution across neighbourhoods
- Availability trends across the year
- Listings enriched with country region and currency data

---

## 👨‍💻 Author

**Ilan Izakov** — BI Developer | Data Engineer
- 🔗 LinkedIn: linkedin.com/in/ilan-izakov
- 🐙 GitHub: github.com/PandaIlan39

---

## 📝 License
MIT