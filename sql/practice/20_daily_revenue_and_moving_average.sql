WITH daily as (
    SELECT
        DATE(created_at) as day,
        SUM(sale_price) as revenue
    FROM `bigquery-public-data.thelook_ecommerce.order_items`
    GROUP BY day
)

SELECT
    day,
    revenue,
    AVG(revenue) OVER (
        ORDER BY day
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ) as revenue_MA7
FROM daily
ORDER BY day;
