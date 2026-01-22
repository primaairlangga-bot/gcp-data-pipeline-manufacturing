# 19 - Data Quality Check: num_of_item vs counted order_items

## Goal
- Validasi konsistensi: apakah `orders.num_of_item` sama dengan jumlah baris item di `order_items` untuk order yang sama.
- Tampilkan mismatch terbesar (kalau ada).

## Tables
- bigquery-public-data.thelook_ecommerce.orders
- bigquery-public-data.thelook_ecommerce.order_items

## Main concepts
- WITH (CTE)      : bikin hasil agregasi sementara (item count per order)
- COUNT(*)        : hitung jumlah row (jumlah item per order)
- JOIN            : gabungkan orders dengan hasil hitungan item_counts
- ON              : kondisi join (order_id harus sama)
- WHERE !=        : filter yang tidak sama (mismatch)
- ABS()           : nilai absolut selisih (berapa besar mismatch)
- ORDER BY DESC   : urutkan mismatch terbesar dulu
- LIMIT           : ambil top N kasus

## Grain / correctness notes
- Grain output: 1 row = 1 order yang mismatch.
- `item_cnt` dihitung dari jumlah baris di order_items per order_id.
- `num_of_item` adalah angka yang tersimpan di tabel orders (header).
- Jika hasil kosong (no rows), berarti tidak ada mismatch untuk kondisi `!=`.
- NULL handling: jika salah satu nilai NULL, ekspresi `!=` bisa jadi UNKNOWN dan tidak lolos filter.
  Kalau mau tangkap NULL mismatch, gunakan IFNULL/COALESCE.

## Cost-aware notes
- `item_counts` melakukan GROUP BY di seluruh order_items; ini bisa berat kalau tabel besar.
- Untuk hemat, bisa filter periode (mis. created_at range) dan join/filter pada subset order.

## Line-by-line
L1: WITH item_counts AS (
    - Mulai CTE "item_counts" untuk menghitung jumlah item per order.

L2:   SELECT
    - Definisikan kolom output CTE.

L3:     order_id,
    - Key agregasi: setiap order_id akan jadi 1 baris hasil.

L4:     COUNT(*) AS item_cnt,
    - Hitung berapa baris item (line items) per order_id.
    - AS item_cnt -> nama kolom hasil hitung.
    - Catatan: koma di akhir baris ini (setelah item_cnt) harus dihapus, karena akan bikin syntax error.

L5:   FROM `bigquery-public-data.thelook_ecommerce.order_items`
    - Sumber data untuk hitung item: tabel order_items.

L6:   GROUP BY order_id
    - Agregasi per order_id (1 baris per order).

L7: )
    - Tutup CTE item_counts.

L8: SELECT
    - Query utama: ambil order_id dan dua versi hitungan item.

L9:   o.order_id,
    - Tampilkan order_id dari tabel orders (alias o).

L10:  o.num_of_item,
    - Tampilkan nilai num_of_item yang tersimpan di tabel orders.

L11:  ic.item_cnt
    - Tampilkan item_cnt hasil hitungan dari CTE.

L12: FROM `bigquery-public-data.thelook_ecommerce.orders` o
    - Sumber utama: tabel orders, alias o.

L13: JOIN item_counts ic
    - Gabungkan dengan hasil agregasi item_counts, alias ic.

L14:   ON o.order_id = ic.order_id
    - Kondisi join: order_id harus sama.

L15: WHERE o.num_of_item != ic.item_cnt
    - Filter hanya order yang jumlah itemnya berbeda (mismatch).

L16: ORDER BY ABS(o.num_of_item - ic.item_cnt) DESC
    - Urutkan mismatch berdasarkan selisih absolut terbesar dulu.

L17: LIMIT 50;
    - Ambil 50 mismatch teratas.
