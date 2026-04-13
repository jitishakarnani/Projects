-- =============================================================
-- FILE: sql/queries/06_final_dataset.sql
-- PURPOSE: Create the final Power BI-ready export view
--          This is the single table imported into Power BI
-- =============================================================

CREATE OR REPLACE VIEW vw_powerbi_export AS
SELECT
    -- Keys
    st.transaction_id,

    -- Date dimension
    st.sale_date,
    DATE_PART('year',    st.sale_date)::INT                         AS year,
    DATE_PART('quarter', st.sale_date)::INT                         AS quarter,
    DATE_PART('month',   st.sale_date)::INT                         AS month_num,
    TO_CHAR(st.sale_date, 'Mon')                                    AS month_short,
    TO_CHAR(st.sale_date, 'FMMonth')                                AS month_full,
    TO_CHAR(st.sale_date, 'YYYY-Q"Q"')                              AS year_quarter,
    TO_CHAR(st.sale_date, 'Mon YYYY')                               AS year_month,

    -- Geography
    st.region,

    -- Product
    p.product_name,
    p.category,
    p.sub_category,
    p.unit_cost,

    -- Transaction
    st.quantity,
    st.unit_price,
    st.discount_pct,
    st.sales_amount,

    -- Returns
    COALESCE(r.return_amount, 0)                                    AS return_amount,
    COALESCE(r.return_reason, 'No Return')                          AS return_reason,
    CASE WHEN r.return_id IS NOT NULL THEN 'Returned' ELSE 'Kept'
    END                                                             AS return_flag,

    -- Derived financials
    st.sales_amount - COALESCE(r.return_amount, 0)                  AS net_revenue,
    st.sales_amount - (st.quantity * p.unit_cost)                   AS gross_profit,
    (st.sales_amount - (st.quantity * p.unit_cost))
        - COALESCE(r.return_amount, 0)                              AS net_profit

FROM sales_transactions st
INNER JOIN products p ON st.product_id     = p.product_id
LEFT  JOIN returns  r ON st.transaction_id = r.transaction_id;


-- ----------------------------
-- Export to CSV (run in psql)
-- ----------------------------
-- \COPY (SELECT * FROM vw_powerbi_export ORDER BY sale_date) 
-- TO 'exports/sales_dashboard_data.csv' CSV HEADER;


-- ----------------------------
-- Verify export row count
-- ----------------------------
SELECT COUNT(*) AS export_rows FROM vw_powerbi_export;
