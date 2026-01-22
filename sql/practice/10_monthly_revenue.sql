# Monthly Revenue using order_items.sale_price

SELECT
  DATE_TRUNC(DATE(created_at),MONTH) month,
  SUM(sale_price) as revenue
FROM `bigquery-public-data.thelook_ecommerce.order_items`
GROUP By month
ORDER BY month;
