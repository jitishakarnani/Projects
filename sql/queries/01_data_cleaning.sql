-- =============================================================
-- FILE: sql/queries/01_data_cleaning.sql
-- PURPOSE: Null handling, deduplication, and data validation
-- =============================================================

-- ----------------------------
-- 1. Check for NULL values in critical columns
-- ----------------------------
SELECT
    COUNT(*)                                        AS total_rows,
    SUM(CASE WHEN sale_date    IS NULL THEN 1 END)  AS null_dates,
    SUM(CASE WHEN region       IS NULL THEN 1 END)  AS null_regions,
    SUM(CASE WHEN product_id   IS NULL THEN 1 END)  AS null_product_ids,
    SUM(CASE WHEN sales_amount IS NULL THEN 1 END)  AS null_amounts,
    SUM(CASE WHEN unit_price   <= 0    THEN 1 END)  AS invalid_prices
FROM sales_transactions;

-- ----------------------------
-- 2. Identify duplicate transactions
-- ----------------------------
SELECT
    transaction_id,
    sale_date,
    product_id,
    sales_amount,
    COUNT(*) AS duplicate_count
FROM sales_transactions
GROUP BY transaction_id, sale_date, product_id, sales_amount
HAVING COUNT(*) > 1;

-- ----------------------------
-- 3. Remove duplicate records (keep lowest rowid)
-- ----------------------------
DELETE FROM sales_transactions
WHERE ctid NOT IN (
    SELECT MIN(ctid)
    FROM sales_transactions
    GROUP BY transaction_id, sale_date, product_id, sales_amount
);

-- ----------------------------
-- 4. Validate region values — flag unexpected entries
-- ----------------------------
SELECT DISTINCT region
FROM sales_transactions
ORDER BY region;

-- Standardize region casing
UPDATE sales_transactions
SET region = INITCAP(TRIM(region))
WHERE region != INITCAP(TRIM(region));

-- ----------------------------
-- 5. Handle out-of-range dates
-- ----------------------------
SELECT COUNT(*) AS future_dated_rows
FROM sales_transactions
WHERE sale_date > CURRENT_DATE;

-- Move suspicious future-dated rows to a staging table
CREATE TABLE IF NOT EXISTS sales_transactions_staging AS
SELECT * FROM sales_transactions WHERE sale_date > CURRENT_DATE;

DELETE FROM sales_transactions WHERE sale_date > CURRENT_DATE;

-- ----------------------------
-- 6. Validate returns don't exceed original sale amount
-- ----------------------------
SELECT
    r.return_id,
    r.transaction_id,
    r.return_amount,
    st.sales_amount
FROM returns r
JOIN sales_transactions st ON r.transaction_id = st.transaction_id
WHERE r.return_amount > st.sales_amount;

-- ----------------------------
-- 7. Summary: row counts after cleaning
-- ----------------------------
SELECT
    'sales_transactions' AS table_name, COUNT(*) AS row_count FROM sales_transactions
UNION ALL
SELECT 'products',  COUNT(*) FROM products
UNION ALL
SELECT 'returns',   COUNT(*) FROM returns;
