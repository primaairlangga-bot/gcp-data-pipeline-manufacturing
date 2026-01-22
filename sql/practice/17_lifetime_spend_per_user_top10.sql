SELECT
  user_id,
  SUM(sale_price) as lifetime_spend
FROM `bigquery-public-data.thelook_ecommerce.order_items`
GROUP BY user_id
ORDER BY lifetime_spend DESC
LIMIT 10;
