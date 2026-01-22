SELECT status, COUNT(*) AS n
FROM `bigquery-public-data.thelook_ecommerce.order_items`
GROUP BY status
ORDER BY n DESC;
