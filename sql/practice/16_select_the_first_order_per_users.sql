WITH ranked AS (        -- bikin “tabel sementara” untuk langkah antara
    SELECT
      user_id,
      order_id,
      created_at,
      ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY created_at) AS rn
    FROM `bigquery-public-data.thelook_ecommerce.orders`
)
SELECT
  user_id,
  order_id,
  created_at
FROM ranked
WHERE rn = 1;


-- ROW_NUMBER() OVER (...)  = memberi rangking/nomor urut per user
-- PARTITION BY             = reset ranking per user_id
-- ORDER BY (dalam OVER)    = menentukan urutan ranking (paling awal = rn 1)
