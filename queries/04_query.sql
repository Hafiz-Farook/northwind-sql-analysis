SELECT
    DATE_TRUNC('month', order_date)::date AS year_month,
    COUNT(order_id) AS total_orders,
    ROUND(SUM(freight)) AS total_freight
FROM orders
WHERE
    order_date >= DATE '1997-01-01'
    AND order_date <  DATE '1999-01-01'
GROUP BY
    DATE_TRUNC('month', order_date)
HAVING
    COUNT(order_id) > 35
ORDER BY
    total_freight DESC;
