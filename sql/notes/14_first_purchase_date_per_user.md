# 14 - First Order Date per User
## Goal
- Cari tanggal order pertama untuk setiap user (first order date).

## Tables
- bigquery-public-data.thelook_ecommerce.orders

## Main concepts
- SELECT        : memilih kolom output
- MIN()         : ambil nilai minimum (paling awal)
- DATE()        : konversi timestamp/datetime -> date (buang jam)
- AS            : alias/rename kolom output
- GROUP BY      : agregasi per kelompok (per user)

## Grain / correctness notes
- Grain output: 1 row = 1 user.
- first_order_date = tanggal paling awal dari created_at untuk user tersebut.
- DATE(created_at) membuang informasi waktu; kalau kamu butuh timestamp pertama persis, pakai MIN(created_at) tanpa DATE().
- Jika created_at bertipe TIMESTAMP: DATE(created_at) default pakai UTC.

## Cost-aware notes
- Scan tabel orders dan group by user_id; bisa berat kalau tabel besar.
- Hemat dengan filter tanggal jika kamu hanya butuh periode tertentu (mis. cohort analysis tertentu).

## Line-by-line
L1: SELECT
    - Mulai definisikan kolom output.

L2:   user_id,
    - Ambil user_id sebagai key agregasi (siapa usernya).

L3:   MIN(DATE(created_at)) AS first_order_date
    - DATE(created_at) -> ubah created_at jadi tanggal saja.
    - MIN(...) -> ambil tanggal paling awal untuk user tersebut.
    - AS first_order_date -> nama kolom output.

L4: FROM `bigquery-public-data.thelook_ecommerce.orders`
    - Sumber data: tabel orders.

L5: GROUP BY user_id;
    - Kelompokkan per user_id untuk menghitung MIN per user.
