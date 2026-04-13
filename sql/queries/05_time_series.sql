-- =============================================================
-- FILE: sql/queries/05_time_series.sql
-- PURPOSE: Monthly, quarterly, and YTD time-based aggregations
-- =============================================================

-- ----------------------------
-- 1. Monthly sales summary
-- ----------------------------
SELECT
    sale_year,
    sale_month,
    TO_DATE(sale_year::TEXT || '-' || LPAD(sale_month::TEXT,2,'0') || '-01','YYYY-MM-DD') AS period_date,
    COUNT(DISTINCT transaction_id)      AS transactions,
    SUM(sales_amount)                   AS gross_sales,
    SUM(return_amount)                  AS returns,
    SUM(net_revenue)                    AS net_revenue,
    ROUND(AVG(net_revenue), 2)          AS avg_order_value
FROM vw_sales_analysis
GROUP BY sale_year, sale_month
ORDER BY sale_year, sale_month;


-- ----------------------------
-- 2. Quarterly summary
-- ----------------------------
SELECT
    sale_year,
    sale_quarter,
    SUM(sales_amount)                   AS gross_sales,
    SUM(net_revenue)                    AS net_revenue,
    SUM(return_amount)                  AS total_returns,
    COUNT(DISTINCT transaction_id)      AS total_orders
FROM vw_sales_analysis
GROUP BY sale_year, sale_quarter
ORDER BY sale_year, sale_quarter;


-- ----------------------------
-- 3. Month-over-month change
-- ----------------------------
WITH monthly AS (
    SELECT
        sale_year,
        sale_month,
        SUM(net_revenue) AS net_revenue
    FROM vw_sales_analysis
    GROUP BY sale_year, sale_month
)
SELECT
    sale_year,
    sale_month,
    net_revenue,
    LAG(net_revenue) OVER (ORDER BY sale_year, sale_month) AS prior_month_revenue,
    net_revenue - LAG(net_revenue) OVER (ORDER BY sale_year, sale_month) AS mom_change,
    ROUND(
        (net_revenue - LAG(net_revenue) OVER (ORDER BY sale_year, sale_month))
        / NULLIF(LAG(net_revenue) OVER (ORDER BY sale_year, sale_month), 0) * 100, 2
    )   AS mom_change_pct
FROM monthly
ORDER BY sale_year, sale_month;


-- ----------------------------
-- 4. Year-to-date (YTD) cumulative sales
-- ----------------------------
WITH daily AS (
    SELECT
        sale_date,
        sale_year,
        SUM(net_revenue) AS daily_revenue
    FROM vw_sales_analysis
    GROUP BY sale_date, sale_year
)
SELECT
    sale_date,
    sale_year,
    daily_revenue,
    SUM(daily_revenue) OVER (
        PARTITION BY sale_year
        ORDER BY sale_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    )   AS ytd_revenue
FROM daily
ORDER BY sale_date;


-- ----------------------------
-- 5. Current year vs prior year comparison (monthly)
-- ----------------------------
SELECT
    curr.sale_month,
    curr.net_revenue                    AS current_year_revenue,
    prior.net_revenue                   AS prior_year_revenue,
    curr.net_revenue - prior.net_revenue AS variance,
    ROUND(
        (curr.net_revenue - prior.net_revenue)
        / NULLIF(prior.net_revenue, 0) * 100, 2
    )                                   AS yoy_growth_pct
FROM (
    SELECT sale_month, SUM(net_revenue) AS net_revenue
    FROM vw_sales_analysis
    WHERE sale_year = DATE_PART('year', CURRENT_DATE)
    GROUP BY sale_month
) curr
LEFT JOIN (
    SELECT sale_month, SUM(net_revenue) AS net_revenue
    FROM vw_sales_analysis
    WHERE sale_year = DATE_PART('year', CURRENT_DATE) - 1
    GROUP BY sale_month
) prior ON curr.sale_month = prior.sale_month
ORDER BY curr.sale_month;
