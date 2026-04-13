# 📊 Sales Dashboard for Regional Performance

> **Duration:** June 2025 – August 2025  
> **Tools:** SQL · Power BI  
> **Data Scale:** ~25,000 rows across 3 normalized sales tables

---

## 🧭 Project Overview

This project delivers an end-to-end **regional sales performance analytics solution** — from raw transactional data modeled in SQL to an interactive, multi-page Power BI dashboard used for business decision-making.

The dashboard enables stakeholders to:
- Monitor **regional sales performance** across time periods
- Analyze **product category trends** and return rates
- Drill down into **individual regions, categories, and date ranges** using dynamic slicers

---

## 📁 Repository Structure

```
sales-dashboard-project/
│
├── sql/
│   ├── schema/
│   │   └── create_tables.sql          # DDL: table definitions & indexes
│   ├── queries/
│   │   ├── 01_data_cleaning.sql       # Null handling, deduplication
│   │   ├── 02_joining_tables.sql      # Optimized multi-table joins
│   │   ├── 03_regional_sales.sql      # Regional aggregation queries
│   │   ├── 04_returns_analysis.sql    # Returns & refund rate analysis
│   │   ├── 05_time_series.sql         # Monthly/quarterly breakdowns
│   │   └── 06_final_dataset.sql       # Analysis-ready export view
│   
├── data/
│   └── sample_data.csv               # Anonymized 500-row sample dataset
│
├── powerbi/
│   └── sales_dashboard.pbix          # Power BI report file
│
├── docs/
│   ├── data_dictionary.md            # Column definitions & table relationships
│   ├── dax_measures.md               # All 10 DAX measures with explanations
│   └── dashboard_guide.md            # How to use the dashboard
│
├── assets/
│   └── screenshots/                  # Dashboard preview images
│
└── README.md
```

---

## 🗃️ Data Model

Three normalized tables were joined to build the analysis-ready dataset:

| Table | Rows (approx.) | Key Fields |
|---|---|---|
| `sales_transactions` | ~18,000 | transaction_id, date, region, amount, product_id |
| `products` | ~400 | product_id, category, sub_category, cost |
| `returns` | ~6,600 | return_id, transaction_id, return_date, reason |

**Entity Relationship:**
```
sales_transactions (transaction_id) ──< returns (transaction_id)
sales_transactions (product_id)     >── products (product_id)
```

---

## 🔍 SQL Highlights

### Optimized Multi-Table Join
```sql
-- See sql/queries/02_joining_tables.sql for full version
SELECT
    st.transaction_id,
    st.sale_date,
    st.region,
    st.sales_amount,
    p.category,
    p.sub_category,
    COALESCE(r.return_amount, 0)  AS return_amount,
    CASE WHEN r.return_id IS NOT NULL THEN 1 ELSE 0 END AS is_returned
FROM sales_transactions st
LEFT JOIN products      p ON st.product_id     = p.product_id
LEFT JOIN returns       r ON st.transaction_id = r.transaction_id
WHERE st.sale_date BETWEEN '2024-01-01' AND '2024-12-31';
```

**Performance optimizations applied:**
- Indexes on join keys (`product_id`, `transaction_id`)
- `LEFT JOIN` instead of subqueries for returns lookup
- `COALESCE` for null-safe arithmetic
- Date-range filter applied at the fact table level

---

## 📐 Power BI Dashboard — 10 DAX Measures

| # | Measure | Purpose |
|---|---|---|
| 1 | `Total Sales` | Sum of all sales amounts |
| 2 | `Total Returns` | Sum of all return amounts |
| 3 | `Net Revenue` | Total Sales − Total Returns |
| 4 | `Return Rate %` | Returns / Sales × 100 |
| 5 | `YoY Sales Growth %` | Year-over-year % change |
| 6 | `Avg Order Value` | Net Revenue / Transaction count |
| 7 | `MoM Sales Change` | Month-over-month delta |
| 8 | `Regional Sales Rank` | RANKX by region |
| 9 | `% of Total Sales` | Region share of overall sales |
| 10 | `Cumulative Sales (YTD)` | Running total within year |

> Full DAX code for all measures in [`docs/dax_measures.md`](docs/dax_measures.md)

---

## 🖥️ Dashboard Pages

### Page 1 — Executive Overview
- KPI cards: Net Revenue, Return Rate, Top Region, MoM Growth
- Bar chart: Sales by Region (with benchmark line)
- Line chart: Monthly Sales Trend (current vs. prior year)

### Page 2 — Regional Drill-Down
- Map visual: Sales intensity by region
- Matrix: Region × Category performance with conditional formatting
- Waterfall chart: Regional contribution to total

### Page 3 — Returns Analysis
- Return Rate % trend over time
- Top return reasons (horizontal bar)
- Category-level return heatmap

### Page 4 — Product Category View
- Category sales breakdown (treemap)
- Sub-category performance table
- Profit margin by category

---

## 🎛️ Interactivity & Filters

The report includes the following slicers for drill-down analysis:

- 📅 **Date Range** — Year / Quarter / Month selector
- 🗺️ **Region** — Multi-select region filter
- 🏷️ **Category** — Product category selector
- 🔁 **Transaction Type** — Include / Exclude returns toggle

All slicers are **cross-page synchronized**, meaning selections persist across all four report pages.

---

## 🚀 Getting Started

### Prerequisites
- **SQL**: PostgreSQL 14+ or MySQL 8+ (scripts are ANSI-compatible)
- **Power BI**: Power BI Desktop (free) — [Download here](https://powerbi.microsoft.com/desktop/)

### Setup Instructions

1. **Clone the repository**
   ```bash
   git clone https://github.com/YOUR_USERNAME/sales-dashboard-regional.git
   cd sales-dashboard-regional
   ```

2. **Set up the database**
   ```bash
   psql -U your_user -d your_db -f sql/schema/create_tables.sql
   ```

3. **Load sample data**
   ```bash
   psql -U your_user -d your_db -c "\COPY sales_transactions FROM 'data/sample_data.csv' CSV HEADER"
   ```

4. **Run the queries** in order (01 → 06) from `sql/queries/`

5. **Open Power BI**
   - Open `powerbi/sales_dashboard.pbix`
   - Update the data source connection string to your local DB
   - Click **Refresh**

---

## 💡 Key Insights Uncovered

- 📍 **North region** consistently outperformed others by 23% in Net Revenue
- 📉 **Return rates** peaked in Q4, driven largely by the Electronics category
- 📈 **YoY growth** of 18% observed in the South region between 2023–2024
- 🏷️ **Office Supplies** had the lowest return rate (2.1%) with stable MoM growth

---

## 🛠️ Tech Stack

![SQL](https://img.shields.io/badge/SQL-PostgreSQL-336791?style=flat&logo=postgresql&logoColor=white)
![Power BI](https://img.shields.io/badge/Power_BI-Dashboard-F2C811?style=flat&logo=powerbi&logoColor=black)


**Your Name**  
[LinkedIn](https://linkedin.com/in/yourprofile) · [GitHub](https://github.com/yourusername)
