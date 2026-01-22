# 10 - Monthly Revenue using order_items.sale_price
## Goal
- Hitung total revenue per bulan dari kolom sale_price di tabel order_items.

## Tables
- bigquery-public-data.thelook_ecommerce.order_items

## Main concepts
- SELECT        : memilih kolom output
- DATE()        : konversi timestamp/datetime -> date (buang jam)
- DATE_TRUNC()  : bucket tanggal ke awal bulan (MONTH)
- SUM()         : menjumlahkan nilai numerik (total revenue)
- AS            : alias/rename kolom output
- GROUP BY      : agregasi per kelompok
- ORDER BY      : urutkan hasil

## Grain / correctness notes
- Grain output: 1 row = 1 bulan.
- SUM(sale_price) menjumlahkan semua baris item (line items), bukan jumlah order.
  1 order bisa punya banyak item -> revenue dihitung per item, itu normal untuk revenue.
- Jika ada refund/return/cancel dan sale_price masih tercatat, revenue bisa “overstated”.
  (kalau mau net revenue, biasanya filter status tertentu di order_items atau join ke orders)
- Jika created_at bertipe TIMESTAMP: DATE(created_at) pakai UTC default.

## Cost-aware notes
- Scan seluruh tabel order_items; lebih hemat kalau filter rentang tanggal.
- Hindari SELECT * (sudah benar).

## Line-by-line
L1: SELECT
    - Mulai definisikan kolom output.

L2:   DATE_TRUNC(DATE(created_at), MONTH) month,
    - DATE(created_at) -> ambil tanggal saja (tanpa waktu).
    - DATE_TRUNC(..., MONTH) -> ubah jadi awal bulan (YYYY-MM-01).
    - month -> alias kolom output (tanpa AS juga valid).

L3:   SUM(sale_price) AS revenue
    - SUM(sale_price) -> jumlahkan sale_price untuk semua item pada bulan itu.
    - AS revenue -> nama kolom hasil jadi "revenue".

L4: FROM `bigquery-public-data.thelook_ecommerce.order_items`
    - Ambil data dari tabel order_items.

L5: GROUP BY month
    - Kelompokkan berdasarkan month untuk agregasi SUM.

L6: ORDER BY month;
    - Urutkan hasil per bulan (ascending).
