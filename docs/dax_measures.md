# 📐 DAX Measures Reference

All 10 custom DAX measures used in the Power BI Sales Dashboard.

---

## Measure 1 — Total Sales

```dax
Total Sales = 
SUM(vw_powerbi_export[sales_amount])
```

**Use:** KPI card, bar charts  
**Description:** Gross sum of all sales before returns.

---

## Measure 2 — Total Returns

```dax
Total Returns = 
SUM(vw_powerbi_export[return_amount])
```

**Use:** Returns page KPI card  
**Description:** Sum of all return amounts across the filtered context.

---

## Measure 3 — Net Revenue

```dax
Net Revenue = 
[Total Sales] - [Total Returns]
```

**Use:** Primary KPI, all pages  
**Description:** True revenue after subtracting returns. This is the headline metric.

---

## Measure 4 — Return Rate %

```dax
Return Rate % = 
DIVIDE(
    [Total Returns],
    [Total Sales],
    0
) * 100
```

**Use:** KPI card, heatmap, trend line  
**Description:** Percentage of gross sales value that was returned. DIVIDE used for safe division.

---

## Measure 5 — YoY Sales Growth %

```dax
YoY Sales Growth % = 
VAR CurrentYear = [Net Revenue]
VAR PriorYear = 
    CALCULATE(
        [Net Revenue],
        DATEADD(DateTable[Date], -1, YEAR)
    )
RETURN
DIVIDE(
    CurrentYear - PriorYear,
    PriorYear,
    0
) * 100
```

**Use:** KPI card with trend arrow, line chart  
**Description:** Compares current period net revenue to the same period one year prior using time intelligence.

---

## Measure 6 — Avg Order Value

```dax
Avg Order Value = 
DIVIDE(
    [Net Revenue],
    DISTINCTCOUNT(vw_powerbi_export[transaction_id]),
    0
)
```

**Use:** Executive overview KPI  
**Description:** Average net revenue per unique transaction in the current filter context.

---

## Measure 7 — MoM Sales Change

```dax
MoM Sales Change = 
VAR CurrentMonth = [Net Revenue]
VAR PriorMonth = 
    CALCULATE(
        [Net Revenue],
        DATEADD(DateTable[Date], -1, MONTH)
    )
RETURN
CurrentMonth - PriorMonth
```

**Use:** Trend indicator, waterfall chart  
**Description:** Absolute month-over-month change in net revenue. Positive = growth, Negative = decline.

---

## Measure 8 — Regional Sales Rank

```dax
Regional Sales Rank = 
RANKX(
    ALL(vw_powerbi_export[region]),
    [Net Revenue],
    ,
    DESC,
    DENSE
)
```

**Use:** Regional matrix, map tooltip  
**Description:** Dense rank of each region by net revenue (descending). Rank 1 = highest revenue region.

---

## Measure 9 — % of Total Sales

```dax
% of Total Sales = 
DIVIDE(
    [Net Revenue],
    CALCULATE(
        [Net Revenue],
        ALL(vw_powerbi_export[region])
    ),
    0
) * 100
```

**Use:** Pie/donut chart, matrix visual  
**Description:** Each region's contribution as a percentage of overall net revenue, ignoring region filter.

---

## Measure 10 — Cumulative Sales (YTD)

```dax
Cumulative Sales YTD = 
CALCULATE(
    [Net Revenue],
    DATESYTD(DateTable[Date])
)
```

**Use:** Line chart (running total), executive summary  
**Description:** Year-to-date running total of net revenue from January 1 of the current year through the selected date.

---

## Supporting Date Table

All time intelligence measures require a dedicated Date Table:

```dax
DateTable = 
CALENDAR(
    DATE(2022, 1, 1),
    DATE(2025, 12, 31)
)
```

Mark it as a **Date Table** in Power BI (Table Tools → Mark as Date Table → Date column).

---

## Measure Dependency Map

```
Total Sales ──┐
              ├──► Net Revenue ──► YoY Growth %
Total Returns─┘         │──────► Avg Order Value
                         │──────► MoM Sales Change
                         │──────► Regional Sales Rank
                         │──────► % of Total Sales
                         └──────► Cumulative Sales YTD
```
