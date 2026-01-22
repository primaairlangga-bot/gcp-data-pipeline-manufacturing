WITH monthly AS (
    SELECT
      DATE_TRUNC(DATE(created_at), MONTH) as month,
      SUM(sale_price) AS revenue
    FROM `bigquery-public-data.thelook_ecommerce.order_items`
    GROUP BY month
)
SELECT
  month,
  revenue,
  SUM(revenue) OVER (ORDER BY month) AS revenue_running_total
FROM monthly
ORDER BY month;
