SELECT order_id, user_id, status, created_at, num_of_item
FROM `bigquery-public-data.thelook_ecommerce.orders`
ORDER BY created_at DESC
LIMIT 20;
