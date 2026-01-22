SELECT
  user_id,
  MIN(DATE(created_at)) AS first_order_date
FROM `bigquery-public-data.thelook_ecommerce.orders`
GROUP BY user_id;
