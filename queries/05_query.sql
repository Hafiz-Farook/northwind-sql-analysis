WITH price_history AS (
    SELECT
        p.product_id,
        p.product_name,
        p.unit_price AS current_unit_price,
        MIN(od.unit_price) AS initial_unit_price
    FROM products p
    JOIN order_details od
        ON od.product_id = p.product_id
    GROUP BY
        p.product_id, p.product_name, p.unit_price
),
price_changes AS (
    SELECT
        product_name,
        ROUND(current_unit_price::numeric, 2) AS current_price,
        ROUND(initial_unit_price::numeric, 2) AS initial_price,
        ((current_unit_price - initial_unit_price) / initial_unit_price * 100) AS pct_increase
    FROM price_history
    WHERE current_unit_price > initial_unit_price
)
SELECT
    product_name,
    current_price,
    initial_price,
    ROUND(pct_increase)::int AS percentage_increase
FROM price_changes
WHERE
    pct_increase < 20
    OR pct_increase > 30
ORDER BY
    percentage_increase ASC;
