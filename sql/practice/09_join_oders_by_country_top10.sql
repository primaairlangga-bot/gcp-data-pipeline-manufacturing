SELECT
  t2.country ,
  COUNT(*) AS total_orders
FROM `bigquery-public-data.thelook_ecommerce.orders` t1
JOIN `bigquery-public-data.thelook_ecommerce.users` t2
  ON t1.user_id = t2.id
GROUP BY t2.country
ORDER BY total_orders DESC
LIMIT 10;
