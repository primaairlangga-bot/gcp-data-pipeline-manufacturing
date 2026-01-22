# 09 - Top 10 Countries by Total Orders
## Goal
- Cari 10 negara dengan jumlah order terbanyak (berdasarkan join orders -> users).

## Tables
- bigquery-public-data.thelook_ecommerce.orders
- bigquery-public-data.thelook_ecommerce.users

## Main concepts
- SELECT        : memilih kolom output
- JOIN          : menggabungkan 2 tabel berdasarkan key yang sama
- ON            : kondisi join (relasi antar kolom)
- COUNT(*)      : hitung jumlah row per group (jumlah orders)
- GROUP BY      : agregasi per kelompok
- ORDER BY DESC : urutkan dari nilai terbesar ke kecil
- LIMIT         : ambil top N baris
- Alias (t1,t2) : nama pendek untuk tabel biar query ringkas

## Grain / correctness notes
- Grain output: 1 row = 1 country.
- COUNT(*) di sini menghitung jumlah baris orders setelah join => jumlah order per negara.
- Kalau ada users tanpa country (NULL), akan muncul group NULL (opsional: filter WHERE t2.country IS NOT NULL).
- Ini hitung total orders, bukan distinct buyers. (kalau mau buyers unik: COUNT(DISTINCT t1.user_id)).

## Cost-aware notes
- Join dua tabel bisa mahal; pastikan pilih kolom secukupnya (sudah: country + count).
- Untuk hemat, bisa filter periode waktu orders (mis. WHERE t1.created_at >= ...).
- Kalau tujuan hanya country, cukup join key + kolom country (hindari SELECT *).

## Line-by-line
L1: SELECT
    - Mulai definisikan kolom output.

L2:   t2.country,
    - Ambil kolom country dari tabel users (alias t2).

L3:   COUNT(*) AS total_orders
    - Hitung jumlah row (orders) per country.
    - AS total_orders -> nama kolom hasil hitung.

L4: FROM `bigquery-public-data.thelook_ecommerce.orders` t1
    - Sumber utama: tabel orders, diberi alias t1.

L5: JOIN `bigquery-public-data.thelook_ecommerce.users` t2
    - Gabungkan dengan tabel users, diberi alias t2.

L6:   ON t1.user_id = t2.id
    - Kondisi join: user_id di orders harus sama dengan id di users.

L7: GROUP BY t2.country
    - Kelompokkan hasil join berdasarkan country untuk agregasi COUNT.

L8: ORDER BY total_orders DESC
    - Urutkan dari jumlah order paling besar ke paling kecil.

L9: LIMIT 10;
    - Ambil 10 negara teratas.
