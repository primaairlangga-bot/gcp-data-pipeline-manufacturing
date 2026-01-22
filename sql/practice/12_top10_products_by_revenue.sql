# Top 10 products by revenue (join products)
SELECT
  t2.id AS product_id,
  t2.name AS product_name,
  SUM(t1.sale_price) AS revenue
FROM `bigquery-public-data.thelook_ecommerce.order_items` t1
JOIN `bigquery-public-data.thelook_ecommerce.products` t2
  ON t1.product_id = t2.id
GROUP BY product_id, product_name
ORDER BY revenue DESC
LIMIT 10;
