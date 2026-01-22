SELECT
  MIN(DATE(created_at)) AS min_date,
  MAX(DATE(created_at)) AS max_date
FROM `bigquery-public-data.thelook_ecommerce.orders`;
