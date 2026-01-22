# 04 - Total Orders

## Goal
untuk menghitung jumlah data/rows pada tabel dimana nama kolom count diubah ke total_users

## Tables
- bigquery-public-data.thelook_ecommerce.users

## Main concepts
- SELECT    : untuk memilih kolom pada tabel data
- COUNT     : untuk mengjitung jumlah row data yang diambil SELECT
- AS        : untuk mengubah identitas nama kolom yang diambil dengan SELECT
- *         : simbol untuk tampilkan semua kolom pada tabel data

## Grain / correctness notes
- Grain tabel orders: 1 row = 1 order, jadi `COUNT(*)` = total order.
- Tidak ada JOIN sehingga tidak ada risiko row multiplication.

## Cost-aware notes
- Tidak pakai `SELECT *`.
- Query sederhana tanpa join.

## Output interpretation
Menampilkan nominal jumlah row data dengan nama kolom total_orders
