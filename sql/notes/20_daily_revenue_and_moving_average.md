# 20 - Daily Revenue + 7-Day Moving Average (MA7)
## Goal
- Hitung revenue harian dari order_items, lalu hitung moving average 7 hari (MA7) untuk smoothing trend.

## Tables
- bigquery-public-data.thelook_ecommerce.order_items

## Main concepts
- WITH (CTE)                 : bikin hasil agregasi harian sebagai input window function
- DATE()                     : konversi timestamp/datetime -> date (buang jam)
- SUM()                      : total revenue per hari (jumlah sale_price)
- GROUP BY                   : agregasi per hari
- AVG() OVER (...)           : window function untuk moving average
- ORDER BY (dalam OVER)      : urutan window berdasarkan tanggal
- ROWS BETWEEN ... AND ...   : frame window “7 baris terakhir” termasuk hari ini

## Grain / correctness notes
- Grain output: 1 row = 1 hari.
- revenue = SUM(sale_price) dari semua line items pada tanggal tersebut.
- revenue_MA7 = rata-rata revenue pada window 7 baris: hari ini + 6 hari sebelumnya.
- Untuk 6 hari pertama dataset, MA7 dihitung dari baris yang tersedia (kurang dari 7).
- `ROWS BETWEEN 6 PRECEDING` = 6 baris sebelumnya, bukan selalu “6 hari kalender”.
  Kalau ada hari yang tidak punya transaksi (tidak muncul row), window bisa “lompat”.
  Kalau butuh MA7 berbasis kalender (termasuk hari nol transaksi), perlu calendar table.

## Cost-aware notes
- Agregasi harian + window average biasanya masih wajar.
- Bisa hemat dengan filter periode (mis. last 90 days) sebelum agregasi.

## Line-by-line
L1: WITH daily AS (
    - Mulai CTE "daily" untuk membentuk revenue per hari.

L2:   SELECT
    - Pilih kolom yang akan jadi output CTE.

L3:     DATE(created_at) AS day,
    - Ambil tanggal saja dari created_at (tanpa waktu).
    - Alias kolom jadi "day".

L4:     SUM(sale_price) AS revenue
    - Jumlahkan sale_price semua item pada hari tersebut.
    - A
