# Top 10 brands by revenue (join brand)

SELECT
  t2.brand,
  SUM(t1.sale_price) AS revenue
FROM `bigquery-public-data.thelook_ecommerce.order_items` t1
JOIN `bigquery-public-data.thelook_ecommerce.products` t2
  ON t1.product_id = t2.id
GROUP BY t2.brand
ORDER BY revenue DESC
LIMIT 10;
