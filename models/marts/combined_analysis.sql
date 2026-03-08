WITH listings AS (
    SELECT * FROM {{ ref('stg_listings') }}
),

countries AS (
    SELECT * FROM {{ ref('countries') }}
),

combined AS (
    SELECT
        l.listing_id,
        l.listing_name,
        l.host_id,
        l.host_name,
        l.neighbourhood_group,
        l.neighbourhood,
        l.room_type,
        l.price_usd,
        l.service_fee_usd,
        l.minimum_nights,
        l.number_of_reviews,
        l.availability_365,
        l.cancellation_policy,
        c.country_name,
        c.region,
        c.subregion,
        c.population,
        c.currency
    FROM listings l
    LEFT JOIN countries c
        ON l.country_code = c.country_code
)

SELECT * FROM combined