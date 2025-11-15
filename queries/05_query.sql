WITH price_changes AS (
    SELECT
        p.product_id,
        p.product_name,
        p.unit_price AS current_unit_price,
        MIN(od.unit_price) AS initial_unit_price
    FROM products p
    JOIN order_details od
        ON od.product_id = p.product_id
    GROUP BY
        p.product_id,
        p.product_name,
        p.unit_price
),
with_increase AS (
    SELECT
        product_id,
        product_name,
        current_unit_price,
        initial_unit_price,
        (current_unit_price - initial_unit_price)
            / initial_unit_price * 100.0 AS pct_increase
    FROM price_changes
    WHERE current_unit_price > initial_unit_price
)
SELECT
    product_name,
    ROUND(current_unit_price::numeric, 2) AS current_unit_price,
    ROUND(initial_unit_price::numeric, 2) AS initial_unit_price,
    ROUND(pct_increase)::int AS percentage_increase
FROM with_increase
WHERE
    pct_increase < 20
    OR pct_increase > 30
ORDER BY
    percentage_increase ASC;
