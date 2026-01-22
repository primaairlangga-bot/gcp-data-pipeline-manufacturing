# 12 - Top 10 Products by Revenue (join products)
## Goal
- Cari 10 produk dengan revenue tertinggi berdasarkan total sale_price pada order_items.

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
- Grain output: 1 row = 1 product.
- revenue = SUM(t1.sale_price) untuk semua item dari product tersebut.
- Ini hitung revenue di level line item (order_items), bukan jumlah order.
- Kalau ada refund/return/cancel yang tetap tercatat, revenue bisa bias (butuh filter status jika tersedia).
- Produk yang tidak pernah terjual tidak akan muncul (karena join dari order_items).

## Cost-aware notes
- Join + SUM bisa mahal; hemat dengan filter tanggal pada t1.created_at bila perlu.
- Pastikan hanya pilih kolom yang dibutuhkan (sudah: id, name, sale_price).
- Untuk dataset besar, agregasi setelah filter biasanya jauh lebih murah.

## Line-by-line
L1: SELECT
    - Mulai definisikan kolom output.

L2:   t2.id AS product_id,
    - Ambil id produk dari tabel products (alias t2).
    - AS product_id -> nama kolom output.

L3:   t2.name AS product_name,
    - Ambil nama produk dari tabel products.
    - AS product_name -> nama kolom output.

L4:   SUM(t1.sale_price) AS revenue
    - Jumlahkan sale_price dari order_items (alias t1) per produk.
    - AS revenue -> nama kolom hasil.

L5: FROM `bigquery-public-data.thelook_ecommerce.order_items` t1
    - Sumber utama: order_items (line items), alias t1.

L6: JOIN `bigquery-public-data.thelook_ecommerce.products` t2
    - Gabungkan dengan tabel products untuk dapat info produk, alias t2.

L7:   ON t1.product_id = t2.id
    - Kondisi join: product_id di order_items harus sama dengan id di products.

L8: GROUP BY product_id, product_name
    - Kelompokkan berdasarkan produk (id + name) untuk agregasi SUM.
    - (BigQuery mengizinkan pakai alias SELECT di GROUP BY seperti ini.)

L9: ORDER BY revenue DESC
    - Urutkan dari revenue terbesar ke terkecil.

L10: LIMIT 10;
    - Ambil 10 produk teratas.
