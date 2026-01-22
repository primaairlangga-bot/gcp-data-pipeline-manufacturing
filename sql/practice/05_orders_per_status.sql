SELECT
    status,
    COUNT (*) AS orders
FROM `bigquery-public-data.thelook_ecommerce.orders`
GROUP BY status
ORDER by orders DESC;
