WITH item_counts as (
    SELECT
        order_id,
        COUNT(*) as item_cnt,
    FROM `bigquery-public-data.thelook_ecommerce.order_items`
    GROUP BY order_id
)

SELECT
    o.order_id,
    o.num_of_item,
    ic.item_cnt
FROM `bigquery-public-data.thelook_ecommerce.orders` o
JOIN item_counts ic
    ON o.order_id = ic.order_id
WHERE o.num_of_item != ic.item_cnt
ORDER BY ABS(o.num_of_item - ic.item_cnt) DESC
LIMIT 50;
