# 13 - Top 10 Brands by Revenue (join brand)
## Goal
- Cari 10 brand dengan revenue tertinggi berdasarkan total sale_price pada order_items.

## Tables
- bigquery-public-data.thelook_ecommerce.order_items
- bigquery-public-data.thelook_ecommerce.products

## Main concepts
- SELECT        : memilih kolom output
- JOIN          : menggabungkan 2 tabel berdasarkan key yang sama
- ON            : kondisi join (relasi antar kolom)
- SUM()         : total revenue (jumlah sale_price)
- AS            : alias/rename kolom output
- GROUP BY      : agregasi per kelompok
- ORDER BY DESC : urutkan dari nilai terbesar ke kecil
- LIMIT         : ambil top N baris
- Alias (t1,t2) : nama pendek untuk tabel biar query ringkas

## Grain / correctness notes
- Grain output: 1 row = 1 brand.
- revenue = SUM(t1.sale_price) untuk semua item yang brand-nya sama.
- Brand NULL bisa ikut muncul sebagai 1 grup (opsional: WHERE t2.brand IS NOT NULL).
- Revenue dihitung dari line items (order_items), bukan jumlah order.
- Kalau ada return/cancel yang tetap tercatat, revenue bisa bias (butuh filter status jika ada).

## Cost-aware notes
- Join + SUM bisa mahal; hemat dengan filter tanggal pada t1.created_at bila perlu.
- Pilih kolom secukupnya (sudah: brand + sale_price).
- Untuk dataset besar, agregasi setelah filter biasanya lebih murah.

## Line-by-line
L1: SELECT
    - Mulai definisikan kolom output.

L2:   t2.brand,
    - Ambil kolom brand dari tabel products (alias t2).

L3:   SUM(t1.sale_price) AS revenue
    - Jumlahkan sale_price dari order_items (alias t1) untuk tiap brand.
    - AS revenue -> nama kolom hasil.

L4: FROM `bigquery-public-data.thelook_ecommerce.order_items` t1
    - Sumber utama: order_items (line items), alias t1.

L5: JOIN `bigquery-public-data.thelook_ecommerce.products` t2
    - Gabungkan dengan tabel products untuk dapat brand tiap product, alias t2.

L6:   ON t1.product_id = t2.id
    - Kondisi join: product_id di order_items sama dengan id di products.

L7: GROUP BY t2.brand
    - Kelompokkan berdasarkan brand untuk agregasi SUM.

L8: ORDER BY revenue DESC
    - Urutkan dari revenue terbesar ke terkecil.

L9: LIMIT 10;
    - Ambil 10 brand teratas.
