WITH monthly AS (
  SELECT
    DATE_TRUNC(DATE(created_at), MONTH) AS month,
    COUNT(DISTINCT(order_id)) AS orders,
    SUM(sale_price) AS revenue
  FROM `bigquery-public-data.thelook_ecommerce.order_items`
  GROUP BY month
)
SELECT
  month,
  revenue,
  SAFE_DIVIDE(revenue, orders) AS aov
FROM monthly
ORDER BY  month;
