# 08 - Distinct Buyers
## Goal
- Hitung jumlah user unik yang pernah melakukan order (distinct buyers).

## Tables
- bigquery-public-data.thelook_ecommerce.orders

## Main concepts
- SELECT                 : memilih kolom output
- COUNT(DISTINCT ...)    : hitung jumlah nilai unik (dedup)
- AS                     : alias/rename kolom output
- FROM                   : sumber tabel data

## Grain / correctness notes
- Grain output: 1 row = 1 angka total distinct buyers.
- Definisi "buyer" di sini = user yang muncul di tabel orders.
  (kalau ada cancelled/returned dan kamu mau exclude, perlu filter status)
- DISTINCT di level user_id: 1 user dihitung sekali walau order berkali-kali.

## Cost-aware notes
- COUNT(DISTINCT) biasanya lebih berat daripada COUNT(*) karena butuh dedup.
- Kalau data besar dan ada partition (mis. by created_at), tambahkan filter tanggal untuk hemat scan.

## Line-by-line
L1: SELECT COUNT(DISTINCT(user_id)) AS distinct_buyers
    - DISTINCT(user_id) -> ambil user_id unik (hapus duplikat).
    - COUNT(...) -> hitung berapa banyak user_id unik tersebut.
    - AS distinct_buyers -> nama kolom output jadi "distinct_buyers".

L2: FROM `bigquery-public-data.thelook_ecommerce.orders`;
    - Ambil data dari tabel orders.
