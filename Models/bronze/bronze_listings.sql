-- Bronze layer: raw data, no transformations
-- Direct copy of source data for data lineage tracking

WITH source AS (
    SELECT * FROM {{ source('raw', 'listings') }}
)

SELECT
    *,
    CURRENT_TIMESTAMP()     AS loaded_at,
    CURRENT_DATE()          AS load_date
FROM source