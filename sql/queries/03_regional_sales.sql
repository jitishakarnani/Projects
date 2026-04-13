-- =============================================================
-- FILE: sql/queries/03_regional_sales.sql
-- PURPOSE: Regional aggregations for Power BI visuals
-- =============================================================

-- ----------------------------
-- 1. Total sales and net revenue by region
-- ----------------------------
SELECT
    region,
    COUNT(transaction_id)               AS total_transactions,
    SUM(sales_amount)                   AS total_sales,
    SUM(return_amount)                  AS total_returns,
    SUM(net_revenue)                    AS net_revenue,
    ROUND(
        SUM(return_amount) / NULLIF(SUM(sales_amount), 0) * 100, 2
    )                                   AS return_rate_pct
FROM vw_sales_analysis
GROUP BY region
ORDER BY net_revenue DESC;


-- ----------------------------
-- 2. Region × Category breakdown
-- ----------------------------
SELECT
    region,
    category,
    COUNT(transaction_id)               AS transactions,
    SUM(sales_amount)                   AS total_sales,
    SUM(net_revenue)                    AS net_revenue,
    ROUND(AVG(sales_amount), 2)         AS avg_order_value
FROM vw_sales_analysis
GROUP BY region, category
ORDER BY region, net_revenue DESC;


-- ----------------------------
-- 3. Regional sales ranking (for Power BI RANKX equivalent)
-- ----------------------------
SELECT
    region,
    SUM(net_revenue)    AS net_revenue,
    RANK() OVER (ORDER BY SUM(net_revenue) DESC) AS sales_rank
FROM vw_sales_analysis
GROUP BY region;


-- ----------------------------
-- 4. Region % share of total sales
-- ----------------------------
SELECT
    region,
    SUM(net_revenue)    AS net_revenue,
    ROUND(
        SUM(net_revenue) / SUM(SUM(net_revenue)) OVER () * 100, 2
    )                   AS pct_of_total
FROM vw_sales_analysis
GROUP BY region
ORDER BY pct_of_total DESC;


-- ----------------------------
-- 5. Year-over-year regional comparison
-- ----------------------------
SELECT
    region,
    sale_year,
    SUM(net_revenue)    AS net_revenue,
    LAG(SUM(net_revenue)) OVER (
        PARTITION BY region ORDER BY sale_year
    )                   AS prior_year_revenue,
    ROUND(
        (SUM(net_revenue) - LAG(SUM(net_revenue)) OVER (
            PARTITION BY region ORDER BY sale_year
        )) / NULLIF(LAG(SUM(net_revenue)) OVER (
            PARTITION BY region ORDER BY sale_year
        ), 0) * 100, 2
    )                   AS yoy_growth_pct
FROM vw_sales_analysis
GROUP BY region, sale_year
ORDER BY region, sale_year;
