# 06 - Latest 20 orders

## Goal
untuk ambil data order_id, user_id, status, created_at, num_of_item pada tabel

## Tables
- bigquery-public-data.thelook_ecommerce.users

## Main concepts
- SELECT    : untuk memilih kolom pada tabel data
- ORDER BY  : untuk mengurutkan baris data yang diambil dengan SELECT
- DESC      : parameter pengurutan dari banyak ke kecil

## Grain / correctness notes
- Grain tabel orders: 1 row = 1 order, jadi
- Jika status NULL, akan muncul group NULL (opsional: filter).

## Cost-aware notes
- Hanya mengambil kolom yang dipakai.
- Tidak pakai `SELECT *`.

## Output interpretation
Muncul kolom ambil data order_id, user_id, status, created_at, num_of_item 20 row pertama diurutkan berdasarkan created_at
