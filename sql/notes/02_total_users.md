# 02 - Total Users

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
- Grain tabel users: 1 row = 1 user, jadi `COUNT(*)` = total user.
- Jika tabel punya duplikasi user (tidak di sini), baru perlu `COUNT(DISTINCT id)`.

## Cost-aware notes
- Query ini scan tabel users, tapi hanya menghitung row (tanpa join).
- Tidak pakai `SELECT *`.

## Output interpretation
Menampilkan nominal jumlah row data dengan nama kolom total_users
