# 05 - Orders per Status

## Goal
untuk meghitung jumlah orders masing" status

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
- Grain tabel orders: 1 row = 1 order, jadi `COUNT(*)` per status valid.
- Jika status NULL, akan muncul group NULL (opsional: filter).

## Cost-aware notes
- Hanya mengambil kolom yang dipakai.
- Tidak pakai `SELECT *`.

## Output interpretation
memilih kolom status, lalu hitung total baris data dengan identitas users dari tabel data. Lalu dikelompokkan berdasarkan status lalu diurutkan jumlah status yang terbanyak ke terkecil
