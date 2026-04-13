# 🖥️ Dashboard User Guide

How to navigate and use the Sales Regional Performance Dashboard in Power BI.

---

## Opening the Report

1. Download and install [Power BI Desktop](https://powerbi.microsoft.com/desktop/) (free)
2. Open `powerbi/sales_dashboard.pbix`
3. If prompted about data source credentials, update the connection string to your database (see README for setup)
4. Click **Home → Refresh** to load the latest data

---

## Page 1 — Executive Overview

**Purpose:** High-level snapshot for leadership — what happened this period at a glance.

| Visual | Description |
|---|---|
| KPI Cards (top row) | Net Revenue · Return Rate % · YoY Growth · Avg Order Value |
| Bar Chart | Net Revenue by Region with a target benchmark line |
| Line Chart | Monthly Sales Trend — current year vs. prior year |
| Table | Top 5 products by net revenue |

**Tips:**
- The KPI arrows are green (above target) or red (below target)
- Hover over any bar to see the % of Total Sales tooltip
- The benchmark line is set to the average across all regions

---

## Page 2 — Regional Drill-Down

**Purpose:** Deep dive into each region's performance.

| Visual | Description |
|---|---|
| Filled Map | Sales intensity shaded by region — darker = higher revenue |
| Matrix | Region × Category grid with conditional color formatting |
| Waterfall Chart | Each region's contribution/drag on total revenue |
| Scatter Plot | Transactions vs. Net Revenue by region (bubble size = return rate) |

**Tips:**
- Click any region on the map to cross-filter all visuals on the page
- In the matrix, red cells = below-average performance for that category
- The waterfall chart totals always equal the Net Revenue KPI on Page 1

---

## Page 3 — Returns Analysis

**Purpose:** Understand return patterns and identify problem areas.

| Visual | Description |
|---|---|
| KPI Cards | Total Returns · Return Rate % · Most Common Reason |
| Line Chart | Monthly return rate trend over time |
| Horizontal Bar | Return reasons ranked by frequency |
| Heatmap Matrix | Region × Category return rate (color scale: white→red) |

**Tips:**
- Filter by a single category to see which regions drive returns for that product type
- The heatmap cells show return rate %; hover for absolute return value
- Use the Date slicer to isolate seasonal spikes (e.g., Q4 holiday returns)

---

## Page 4 — Product Category View

**Purpose:** Product and category-level performance analysis.

| Visual | Description |
|---|---|
| Treemap | Category and sub-category sales area proportional to revenue |
| Bar + Line Combo | Monthly sales vs. return rate by category |
| Table | Sub-category detail: Sales, Returns, Net Revenue, Gross Profit, Return Rate % |
| Donut Chart | Category share of total net revenue |

**Tips:**
- Click a category in the treemap to filter the table to only that category's sub-categories
- The combo chart line (return rate) uses the secondary axis — check the right-side scale

---

## Using the Slicers

All four slicers are panel-based and sync across all pages:

| Slicer | Type | Location |
|---|---|---|
| 📅 Date Range | Date slider + dropdown | Top of every page |
| 🗺️ Region | Multi-select buttons | Left filter panel |
| 🏷️ Category | Multi-select dropdown | Left filter panel |
| 🔁 Include Returns | Toggle switch | Left filter panel |

**To reset all filters:** Click the **Clear All Filters** button (eraser icon, top-right of each page).

---

## Keyboard Shortcuts

| Action | Shortcut |
|---|---|
| Navigate pages | `Ctrl + F6` |
| Toggle focus mode on visual | `Alt + Shift + F` |
| Export visual data | Right-click → Export data |
| Spotlight a visual | Right-click → Spotlight |

---

## Refreshing Data

If connected to a live database:
1. Go to **Home → Transform Data → Data Source Settings**
2. Update connection credentials if needed
3. Click **Home → Refresh** (or press `F5`)

For scheduled refresh (Power BI Service), publish the report and configure a gateway connection.
