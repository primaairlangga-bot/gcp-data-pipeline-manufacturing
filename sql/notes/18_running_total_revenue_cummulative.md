# 18 - Monthly Revenue + Running Total
## Goal
- Hitung revenue per bulan, lalu buat cumulative revenue (running total) dari bulan ke bulan.

## Tables
- bigquery-public-data.thelook_ecommerce.order_items

## Main concepts
- WITH (CTE)              : bikin subquery bernama untuk dipakai ulang
- DATE()                  : konversi timestamp/datetime -> date
- DATE_TRUNC(..., MONTH)  : bucket tanggal ke awal bulan
- SUM()                   : agregasi (revenue per bulan)
- Window SUM() OVER (...) : cumulative sum / running total
- ORDER BY (dalam OVER)   : menentukan urutan akumulasi
- GROUP BY                : agregasi per kelompok

## Grain / correctness notes
- Grain output: 1 row = 1 bulan.
- revenue = SUM(sale_price) dari semua line items di bulan tersebut.
- revenue_running_total = akumulasi revenue dari bulan pertama sampai bulan saat ini.
- DATE(created_at) untuk TIMESTAMP default pakai UTC.
- Bulan tanpa transaksi tidak muncul (butuh calendar table kalau mau lengkap semua bulan).

## Cost-aware notes
- Query scan order_items dan agregasi bulanan; biasanya masih manageable.
- Untuk hemat, tambahkan filter periode (mis. last 24 months).

## Line-by-line
L1: WITH monthly AS (
    - Mulai CTE "monthly" untuk menyimpan agregasi revenue per bulan.

L2:   SELECT
    - Pilih kolom yang akan jadi output CTE.

L3:     DATE_TRUNC(DATE(created_at), MONTH) AS month,
    - Konversi created_at -> DATE, lalu trunc ke awal bulan (YYYY-MM-01).
    - Alias kolom jadi "month".

L4:     SUM(sale_price) AS revenue
    - Jumlahkan sale_price semua item pada bulan tersebut.
    - Alias jadi "revenue".

L5:   FROM `bigquery-public-data.thelook_ecommerce.order_items`
    - Sumber data: order_items.

L6:   GROUP BY month
    - Agregasi revenue di level month.

L7: )
    - Tutup CTE "monthly".

L8: SELECT
    - Query utama: ambil month + revenue dan hitung running total.

L9:   month,
    - Tampilkan
