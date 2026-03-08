WITH base AS (
    SELECT * FROM {{ ref('silver_listings') }}
),

summary AS (
    SELECT
        neighbourhood_group,
        room_type,
        COUNT(*)                                AS total_listings,
        ROUND(AVG(price_usd), 2)                AS avg_price,
        ROUND(MIN(price_usd), 2)                AS min_price,
        ROUND(MAX(price_usd), 2)                AS max_price,
        ROUND(AVG(availability_365), 0)         AS avg_availability,
        ROUND(AVG(number_of_reviews), 0)        AS avg_reviews
    FROM base
    WHERE price_usd IS NOT NULL
    AND price_usd > 0
    GROUP BY neighbourhood_group, room_type
    ORDER BY avg_price DESC
)

SELECT * FROM summary