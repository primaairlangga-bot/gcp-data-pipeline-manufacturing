SELECT country, COUNT(*) AS users
FROM `bigquery-public-data.thelook_ecommerce.users`
GROUP BY country
ORDER BY users DESC
LIMIT 10;
