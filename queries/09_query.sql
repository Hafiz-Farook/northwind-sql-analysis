WITH employee_sales AS (
    SELECT
        e.employee_id,
        e.first_name || ' ' || e.last_name AS employee_full_name,
        e.title,
        SUM(od.unit_price * od.quantity) AS total_sales_excl_disc,
        COUNT(DISTINCT o.order_id) AS total_unique_orders,
        COUNT(o.order_id) AS total_orders,
        SUM(od.unit_price * od.quantity * od.discount) AS total_discount_amount,
        SUM(od.unit_price * od.quantity * (1 - od.discount)) AS total_sales_incl_disc
    FROM employees e
    JOIN orders o
        ON o.employee_id = e.employee_id
    JOIN order_details od
        ON od.order_id = o.order_id
    GROUP BY
        e.employee_id,
        employee_full_name,
        e.title
)
SELECT
    employee_full_name,
    title AS job_title,
    ROUND(total_sales_excl_disc::numeric, 2) AS total_sales_excluding_discount,
    total_unique_orders,
    total_orders,
    ROUND(
        (total_sales_excl_disc / NULLIF(total_orders, 0))::numeric,
        2
    ) AS avg_product_amount_excluding_discount,
    ROUND(
        (total_sales_excl_disc / NULLIF(total_unique_orders, 0))::numeric,
        2
    ) AS avg_order_amount_excluding_discount,
    ROUND(total_discount_amount::numeric, 2) AS total_discount_amount,
    ROUND(total_sales_incl_disc::numeric, 2) AS total_sales_including_discount,
    ROUND(
        (total_discount_amount / NULLIF(total_sales_excl_disc, 0) * 100)::numeric,
        2
    ) AS total_discount_percentage
FROM employee_sales
ORDER BY
    total_sales_including_discount DESC;
