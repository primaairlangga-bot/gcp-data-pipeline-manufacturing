# 01 - Users sample (LIMIT)

## Goal
untuk menampilkan data 10 baris pertama.

## Tables
- bigquery-public-data.thelook_ecommerce.users

## Main concepts
- SELECT    : untuk memilih kolom pada tabel data
- *         : simbol untuk tampilkan semua kolom pada tabel data
- LIMIT     : untuk menentukan berapa baris pertama yang ditampilkan

## Grain / correctness notes
- Tidak ada JOIN/agregasi, jadi tidak ada risiko double count.
- Hasil hanya sample untuk eksplorasi.

## Cost-aware notes
- `LIMIT 10` membantu eksplorasi cepat.
- `SELECT *` oke untuk eksplorasi, tapi untuk query “serius” sebaiknya pilih kolom yang dibutuhkan.

## Output interpretation
Menampilkan semua kolom 10 baris pertama
