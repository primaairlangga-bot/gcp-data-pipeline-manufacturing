# 16 - First Order per User (ROW_NUMBER)
## Goal
- Ambil order pertama (order paling awal) untuk setiap user.

## Tables
- bigquery-public-data.thelook_ecommerce.orders

## Main concepts
- WITH (CTE)                : bikin “tabel sementara” untuk langkah antara
- ROW_NUMBER() OVER (...)   : memberi ranking/nomor urut per user
- PARTITION BY              : reset ranking per user_id
- ORDER BY (dalam OVER)     : menentukan urutan ranking (paling awal = rn 1)
- WHERE                     : filter hasil akhir berdasarkan ranking

## Grain / correctness notes
- Grain output: 1 row = 1 user (hanya order pertama per user).
- rn=1 berarti order dengan created_at paling awal.
- Jika ada beberapa order dengan created_at sama persis, hasil bisa tidak deterministik.
  Untuk stabil, tambahkan tie-breaker: ORDER BY created_at, order_id.
- Query ini mengembalikan baris order (order_id + timestamp), bukan hanya tanggal first order.

## Cost-aware notes
- Window function butuh sorting per user; bisa berat untuk tabel besar.
- Hemat dengan filter rentang tanggal bila hanya butuh periode tertentu.

## Line-by-line
L1: WITH ranked AS (
    - Mulai CTE bernama "ranked" untuk menyimpan orders + ranking.

L2:   SELECT
    - Definisikan kolom yang mau ada di CTE.

L3:     user_id,
    - Ambil user_id dari orders.

L4:     order_id,
    - Ambil order_id.

L5:     created_at,
    - Ambil waktu order dibuat.

L6:     ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY created_at) AS rn
    - Beri nomor urut order untuk tiap user.
    - PARTITION BY user_id -> reset numbering per user.
    - ORDER BY created_at -> urut dari order paling awal ke paling baru.
    - rn = 1 akan jadi order pertama user.

L7:   FROM `bigquery-public-data.thelook_ecommerce.orders`
    - Sumber data: tabel orders.

L8: )
    - Tu
