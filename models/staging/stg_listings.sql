WITH source AS (
    SELECT * FROM {{ source('raw', 'listings') }}
),

cleaned AS (
    SELECT
        id                                      AS listing_id,
        name                                    AS listing_name,
        host_id,
        host_name,
        neighbourhood_group,
        neighbourhood,
        lat                                     AS latitude,
        long                                    AS longitude,
        country,
        country_code,
        room_type,
        REPLACE(REPLACE(price, '$', ''), ',', '')::FLOAT          AS price_usd,
        REPLACE(REPLACE(service_fee, '$', ''), ',', '')::FLOAT    AS service_fee_usd,
        minimum_nights,
        number_of_reviews,
        availability_365,
        instant_bookable,
        cancellation_policy
    FROM source
    WHERE id IS NOT NULL
)

SELECT * FROM cleaned