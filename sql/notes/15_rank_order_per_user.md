# 15 - Order Sequence per User (ROW_NUMBER)
## Goal
- Buat nomor urut order untuk tiap user berdasarkan waktu order dibuat (order ke-1, ke-2, dst).

## Tables
- bigquery-public-data.thelook_ecommerce.orders

## Main concepts
- SELECT                    : memilih kolom output
- ROW_NUMBER() OVER (...)   : window function untuk memberi nomor urut per partisi
- OVER (...)                : definisi window (partisi + urutan)
- PARTITION BY              : reset penomoran per grup (di sini per user)
- ORDER BY (dalam OVER)     : menentukan urutan penomoran
- AS                        : alias/rename kolom output

## Grain / correctness notes
- Grain output: 1 row = 1 order (baris dari tabel orders).
- order_seq dimulai dari 1 untuk setiap user.
- Kalau ada created_at yang sama persis (tie), urutan bisa tidak deterministik.
  Untuk stabil, tambahkan tie-breaker, mis:
  ORDER BY created_at, order_id
- Ini tidak menghapus duplikat; hanya menambahkan kolom urutan.

## Cost-aware notes
- Window function butuh sort per user; bisa berat untuk tabel besar.
- Batasi kolom yang dipilih (sudah minimal).
- Untuk hemat, tambahkan filter tanggal kalau hanya butuh periode tertentu.

## Line-by-line
L1: SELECT
    - Mulai definisikan kolom output.

L2:   user_id,
    - Ambil user_id (pembeli) dari orders.

L3:   order_id,
    - Ambil order_id (id order).

L4:   created_at,
    - Ambil timestamp/datetime kapan order dibuat.

L5:   ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY created_at) AS order_seq
    - ROW_NUMBER() memberi nomor urut 1,2,3,... untuk tiap baris.
    - PARTITION BY user_id -> penomoran di-reset untuk setiap user (per user).
    - ORDER BY created_at -> urutan order ditentukan dari created_at paling awal ke paling baru.
    - AS order_seq -> nama kolom nomor urutnya.

L6: FROM `bigquery-public-data.thelook_ecommerce.orders`;
    - Sumber data: tabel orders.
