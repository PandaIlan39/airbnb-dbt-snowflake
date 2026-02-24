WITH base AS (
    SELECT * FROM {{ ref('stg_listings') }}
),

hosts AS (
    SELECT
        host_id,
        host_name,
        COUNT(*)                                AS total_listings,
        ROUND(AVG(price_usd), 2)                AS avg_price,
        SUM(number_of_reviews)                  AS total_reviews,
        ROUND(AVG(availability_365), 0)         AS avg_availability,
        MIN(neighbourhood_group)                AS primary_neighbourhood
    FROM base
    WHERE host_id IS NOT NULL
    GROUP BY host_id, host_name
    ORDER BY total_listings DESC
)

SELECT * FROM hosts