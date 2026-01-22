# 11 - Monthly AOV (Average Order Value)
## Goal
- Hitung AOV per bulan = revenue per bulan / jumlah order unik per bulan.

## Tables
- bigquery-public-data.thelook_ecommerce.order_items

## Main concepts
- WITH (CTE)              : bikin subquery bernama untuk dipakai ulang
- SELECT                  : memilih kolom output
- DATE()                  : konversi timestamp/datetime -> date
- DATE_TRUNC(..., MONTH)  : bucket ke awal bulan
- COUNT(DISTINCT ...)     : hitung jumlah nilai unik (dedup order_id)
- SUM()                   : total revenue (jumlah sale_price)
- SAFE_DIVIDE(a, b)       : pembagian aman (kalau b=0 hasil NULL, bukan error)
- GROUP BY                : agregasi per kelompok
- ORDER BY                : urutkan hasil

## Grain / correctness notes
- Grain output: 1 row = 1 bulan.
- orders dihitung dari COUNT(DISTINCT order_id) di order_items (1 order bisa punya banyak item).
- revenue = SUM(sale_price) dari semua item pada bulan tersebut.
- AOV = revenue / orders.
- Jika ada return/cancel, AOV bisa bias jika sale_price tetap tercatat.
- DATE(created_at) untuk TIMESTAMP default pakai UTC.

## Cost-aware notes
- Scan seluruh order_items; hemat dengan filter tanggal di CTE:
  WHERE created_at >= TIMESTAMP("YYYY-MM-01")
- COUNT(DISTINCT) lebih berat daripada COUNT(*), jadi gunakan hanya jika perlu (di sini perlu).

## Line-by-line
L1: WITH monthly AS (
    - Mulai CTE bernama "monthly" (tabel sementara hasil agregasi bulanan).

L2:   SELECT
    - Pilih kolom yang akan membentuk output CTE.

L3:     DATE_TRUNC(DATE(created_at), MONTH) AS month,
    - Konversi created_at -> DATE, lalu trunc ke awal bulan.
    - Alias kolom jadi "month".

L4:     COUNT(DISTINCT(order_id)) AS orders,
    - Hitung jumlah order unik per bulan (dedup order_id).
    - Alias jadi "orders".

L5:     SUM(sale_price) AS revenue
    - Jumlahkan sale_price semua item per bulan.
    - Alias jadi "revenue".

L6:   FROM `bigquery-public-data.thelook_ecommerce.order_items`
    - Sumber data: tabel order_items.

L7:   GROUP BY month
    - Agregasi di level month (karena ada COUNT/SUM).

L8: )
    - Tutup definisi CTE "monthly".

L9: SELECT
    - Query utama yang membaca hasil dari CTE.

L10:   month,
    - Tampilkan kolom month dari CTE.

L11:   revenue,
    - Tampilkan revenue dari CTE.

L12:   SAFE_DIVIDE(revenue, orders) AS aov
    - Hitung average order value.
    - SAFE_DIVIDE mencegah error kalau orders = 0.
    - Alias hasil jadi "aov".

L13: FROM monthly
    - Ambil data dari CTE "monthly".

L14: ORDER BY month;
    - Urutkan output berdasarkan bulan (ascending).
