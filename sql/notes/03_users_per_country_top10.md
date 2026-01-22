# 03 - Users per Country

## Goal
untuk meghitung jumlah user 10 negara terbanyak

## Tables
- bigquery-public-data.thelook_ecommerce.users

## Main concepts
- SELECT    : untuk memilih kolom pada tabel data
- COUNT     : untuk mengjitung jumlah row data yang diambil SELECT
- AS        : untuk mengubah identitas nama kolom yang diambil dengan SELECT
- *         : simbol untuk tampilkan semua kolom pada tabel data
- GROUP BY  : untuk mengelompokkan baris data dengan nilai yang sama
- ORDER BY  : untuk mengurutkan baris data yang diambil dengan SELECT
- DESC      : parameter pengurutan dari banyak ke kecil

## Grain / correctness notes
- Grain tabel users: 1 row = 1 user, jadi `COUNT(*)` per country valid.
- Jika ada `country` NULL, hasil bisa punya group NULL (opsional: filter).

## Cost-aware notes
- Memilih kolom yang dibutuhkan (country + count).
- LIMIT mengurangi output (bukan mengurangi scan), tapi tetap bagus untuk eksplorasi

## Output interpretation
memilih kolom country, lalu hitung total baris data dengan identitas users dari tabel data. Lalu dikelompokkan berdasarkan country lalu diurutkan 10 negara dari yang terbanyak ke terkecil
