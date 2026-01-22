SELECT
  user_id,
  order_id,
  created_at,
  ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY created_at) AS order_seq
FROM `bigquery-public-data.thelook_ecommerce.orders`;
