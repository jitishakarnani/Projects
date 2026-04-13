-- =============================================================
-- FILE: sql/queries/04_returns_analysis.sql
-- PURPOSE: Return rate trends and root cause analysis
-- =============================================================

-- ----------------------------
-- 1. Overall return rate summary
-- ----------------------------
SELECT
    COUNT(DISTINCT transaction_id)                          AS total_transactions,
    SUM(CASE WHEN is_returned = 1 THEN 1 ELSE 0 END)       AS returned_transactions,
    ROUND(
        SUM(CASE WHEN is_returned = 1 THEN 1 ELSE 0 END)::NUMERIC
        / COUNT(DISTINCT transaction_id) * 100, 2
    )                                                       AS return_rate_pct,
    SUM(return_amount)                                      AS total_return_value,
    ROUND(
        SUM(return_amount) / NULLIF(SUM(sales_amount), 0) * 100, 2
    )                                                       AS return_value_rate_pct
FROM vw_sales_analysis;


-- ----------------------------
-- 2. Return reasons breakdown
-- ----------------------------
SELECT
    return_reason,
    COUNT(*)                        AS occurrences,
    SUM(return_amount)              AS total_return_value,
    ROUND(
        COUNT(*)::NUMERIC / SUM(COUNT(*)) OVER () * 100, 2
    )                               AS pct_of_returns
FROM vw_sales_analysis
WHERE is_returned = 1
GROUP BY return_reason
ORDER BY occurrences DESC;


-- ----------------------------
-- 3. Category-level return analysis
-- ----------------------------
SELECT
    category,
    COUNT(transaction_id)               AS total_transactions,
    SUM(CASE WHEN is_returned = 1 THEN 1 ELSE 0 END) AS returns,
    ROUND(
        SUM(CASE WHEN is_returned = 1 THEN 1 ELSE 0 END)::NUMERIC
        / COUNT(transaction_id) * 100, 2
    )                                   AS return_rate_pct,
    SUM(return_amount)                  AS total_return_value
FROM vw_sales_analysis
GROUP BY category
ORDER BY return_rate_pct DESC;


-- ----------------------------
-- 4. Monthly return rate trend
-- ----------------------------
SELECT
    sale_year,
    sale_month,
    TO_DATE(sale_year::TEXT || '-' || sale_month::TEXT || '-01', 'YYYY-MM-DD') AS month_date,
    COUNT(transaction_id)               AS total_transactions,
    SUM(return_amount)                  AS total_returns,
    SUM(sales_amount)                   AS total_sales,
    ROUND(
        SUM(return_amount) / NULLIF(SUM(sales_amount), 0) * 100, 2
    )                                   AS monthly_return_rate_pct
FROM vw_sales_analysis
GROUP BY sale_year, sale_month
ORDER BY sale_year, sale_month;


-- ----------------------------
-- 5. Region × Category return heatmap data
-- ----------------------------
SELECT
    region,
    category,
    ROUND(
        SUM(CASE WHEN is_returned = 1 THEN 1 ELSE 0 END)::NUMERIC
        / NULLIF(COUNT(transaction_id), 0) * 100, 2
    )   AS return_rate_pct
FROM vw_sales_analysis
GROUP BY region, category
ORDER BY region, return_rate_pct DESC;
