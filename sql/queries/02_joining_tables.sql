-- =============================================================
-- FILE: sql/queries/02_joining_tables.sql
-- PURPOSE: Optimized joins across all 3 sales tables
-- Notes:
--   - LEFT JOIN on returns so non-returned rows are included
--   - COALESCE handles NULL return amounts safely
--   - Filter pushed to fact table for index utilization
-- =============================================================

-- ----------------------------
-- MAIN JOIN: analysis-ready flat dataset
-- ----------------------------
SELECT
    -- Transaction identifiers
    st.transaction_id,
    st.sale_date,
    DATE_PART('year',  st.sale_date)    AS sale_year,
    DATE_PART('month', st.sale_date)    AS sale_month,
    DATE_PART('quarter', st.sale_date)  AS sale_quarter,
    TO_CHAR(st.sale_date, 'Mon YYYY')   AS sale_month_label,

    -- Geography
    st.region,

    -- Product details
    st.product_id,
    p.product_name,
    p.category,
    p.sub_category,
    p.unit_cost,

    -- Financials
    st.quantity,
    st.unit_price,
    st.discount_pct,
    st.sales_amount,
    st.sales_amount - (st.quantity * p.unit_cost)   AS gross_profit,

    -- Return details (NULL-safe)
    COALESCE(r.return_amount, 0)                    AS return_amount,
    COALESCE(r.return_reason, 'No Return')          AS return_reason,
    CASE WHEN r.return_id IS NOT NULL THEN 1 ELSE 0 END AS is_returned,

    -- Net revenue after returns
    st.sales_amount - COALESCE(r.return_amount, 0)  AS net_revenue

FROM sales_transactions st

    -- Products: INNER JOIN — every transaction must have a valid product
    INNER JOIN products p
        ON st.product_id = p.product_id

    -- Returns: LEFT JOIN — not every transaction has a return
    LEFT JOIN returns r
        ON st.transaction_id = r.transaction_id

ORDER BY st.sale_date, st.region;


-- ----------------------------
-- CREATE VIEW: reusable analysis view
-- ----------------------------
CREATE OR REPLACE VIEW vw_sales_analysis AS
SELECT
    st.transaction_id,
    st.sale_date,
    DATE_PART('year',    st.sale_date)  AS sale_year,
    DATE_PART('month',   st.sale_date)  AS sale_month,
    DATE_PART('quarter', st.sale_date)  AS sale_quarter,
    st.region,
    p.category,
    p.sub_category,
    st.sales_amount,
    COALESCE(r.return_amount, 0)                    AS return_amount,
    st.sales_amount - COALESCE(r.return_amount, 0)  AS net_revenue,
    CASE WHEN r.return_id IS NOT NULL THEN 1 ELSE 0 END AS is_returned
FROM sales_transactions st
INNER JOIN products p ON st.product_id   = p.product_id
LEFT  JOIN returns  r ON st.transaction_id = r.transaction_id;
