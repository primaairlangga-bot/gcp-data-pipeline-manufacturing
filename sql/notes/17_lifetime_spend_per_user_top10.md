# 17 - Top 10 Users by Lifetime Spend

## Goal
- Hitung total pengeluaran (lifetime spend) per user dari tabel order_items, lalu ambil 10 user dengan spend terbesar.

## Tables
- bigquery-public-data.thelook_ecommerce.order_items

## Main concepts
- SELECT        : memilih kolom output
- SUM()         : menjumlahkan nilai numerik (total spend)
- AS            : alias/rename kolom output
- GROUP BY      : agregasi per kelompok (per user)
- ORDER BY DESC : urutkan dari nilai terbesar ke kecil
- LIMIT         : ambil top N baris

## Grain / correctness notes
- Grain output: 1 row = 1 user.
- lifetime_spend dihitung dari SUM(sale_price) pada level line item (order_items).
  1 order bisa punya banyak item -> semua item dijumlahkan.
- Jika ada refund/return/cancel yang tetap tercatat, spend bisa bias (butuh filter status jika tersedia).
- User dengan sale_price NULL tidak menambah total (SUM mengabaikan NULL).

## Cost-aware notes
- Scan seluruh order_items lalu group by user_id; bisa berat di data besar.
- Untuk hemat, bisa filter waktu (mis. last 12 months) jika tidak butuh “lifetime” beneran.

## Line-by-line
L1: SELECT user_id, SUM(sale_price) AS lifetime_spend
    - user_id: key agregasi (siapa usernya).
    - SUM(sale_price): total belanja user (jumlah semua sale_price item).
    - AS lifetime_spend: nama kolom hasil agregasi.

L2: FROM `bigquery-public-data.thelook_ecommerce.order_items`
    - Sumber data: tabel order_items.

L3: GROUP BY user_id
    - Kelompokkan per user untuk menghitung SUM per user.

L4: ORDER BY lifetime_spend DESC
    - Urutkan dari total spend terbesar ke terkecil.

L5: LIMIT 10;
    - Ambil 10 user teratas.
