{{
    config(
        materialized='incremental',
        unique_key='listing_id',
        on_schema_change='append_new_columns'
    )
}}

WITH source AS (
    SELECT * FROM {{ ref('bronze_listings') }}

    {% if is_incremental() %}
        WHERE load_date > (SELECT MAX(load_date) FROM {{ this }})
    {% endif %}
),

cleaned AS (
    SELECT
        id                                                          AS listing_id,
        name                                                        AS listing_name,
        host_id,
        host_name,
        neighbourhood_group,
        neighbourhood,
        lat                                                         AS latitude,
        long                                                        AS longitude,
        country,
        country_code,
        room_type,
        REPLACE(REPLACE(price, '$', ''), ',', '')::FLOAT            AS price_usd,
        REPLACE(REPLACE(service_fee, '$', ''), ',', '')::FLOAT      AS service_fee_usd,
        minimum_nights,
        number_of_reviews,
        last_review,
        availability_365,
        instant_bookable,
        cancellation_policy,
        CURRENT_TIMESTAMP()                                         AS loaded_at,
        CURRENT_DATE()                                              AS load_date
    FROM source
    WHERE id IS NOT NULL
    QUALIFY ROW_NUMBER() OVER (PARTITION BY id ORDER BY id) = 1
)

SELECT * FROM cleaned