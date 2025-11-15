SELECT
    ship_country AS country,
    ROUND(
        AVG(EXTRACT(EPOCH FROM (shipped_date - order_date)) / 86400.0)::numeric,
        2
    ) AS avg_days_between_order_and_ship,
    COUNT(DISTINCT order_id) AS total_orders
FROM orders
WHERE
    EXTRACT(YEAR FROM order_date) = 1998
    AND shipped_date IS NOT NULL
GROUP BY
    ship_country
HAVING
    AVG(EXTRACT(EPOCH FROM (shipped_date - order_date)) / 86400.0) >= 5
    AND COUNT(DISTINCT order_id) > 10
ORDER BY
    country ASC;
