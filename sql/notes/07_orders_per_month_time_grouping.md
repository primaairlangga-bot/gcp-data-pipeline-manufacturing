# 07 - Orders per Month
## Goal
- Hitung jumlah orders per bulan berdasarkan created_at.

## Tables
- bigquery-public-data.thelook_ecommerce.orders

## Main concepts
- SELECT        : memilih kolom output
- DATE()        : konversi timestamp/datetime -> date (buang jam)
- DATE_TRUNC()  : bucket tanggal ke awal bulan (MONTH)
- AS            : alias/rename kolom output
- COUNT(*)      : hitung jumlah row per group
- GROUP BY      : agregasi per kelompok
- ORDER BY      : urutkan hasil

## Grain / correctness notes
- Grain output: 1 row = 1 bulan.
- Jika created_at bertipe TIMESTAMP: DATE(created_at) pakai UTC default.
  (opsional timezone: DATE(created_at, "Asia/Jakarta"))
- Bulan tanpa order tidak muncul (butuh calendar table kalau mau lengkap).

## Cost-aware notes
- Scan tabel orders; lebih hemat kalau tambahin filter tanggal.
- Hindari SELECT * (sudah benar).

## Line-by-line
L1: SELECT
    - Mulai definisikan kolom output.

L2:   DATE_TRUNC(DATE(created_at), MONTH) AS month,
    - DATE(created_at) -> ambil tanggal saja (tanpa waktu).
    - DATE_TRUNC(..., MONTH) -> ubah jadi awal bulan (YYYY-MM-01).
    - AS month -> nama kolom output jadi "month".

L3:   COUNT(*) AS orders
    - Hitung jumlah baris (orders) per bulan.
    - AS orders -> nama kolom hasil hitung jadi "orders".

L4: FROM `bigquery-public-data.thelook_ecommerce.orders`
    - Ambil data dari tabel orders.

L5: GROUP BY month
    - Kelompokkan berdasarkan month untuk agregasi COUNT.

L6: ORDER BY month;
    - Urutkan hasil per bulan (ascending).
