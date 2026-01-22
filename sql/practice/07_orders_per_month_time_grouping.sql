SELECT DATE_TRUNC(DATE(created_at), MONTH) AS month,
  COUNT (*) AS orders
FROM `bigquery-public-data.thelook_ecommerce.orders`
GROUP BY month
ORDER BY month;
