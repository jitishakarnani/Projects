# 📖 Data Dictionary

Complete column definitions, data types, and table relationships.

---

## Table: `sales_transactions`

| Column | Type | Nullable | Description |
|---|---|---|---|
| `transaction_id` | INT (PK) | No | Unique identifier for each sale |
| `sale_date` | DATE | No | Date the sale occurred |
| `region` | VARCHAR(50) | No | Geographic region (North, South, East, West) |
| `sales_rep` | VARCHAR(100) | Yes | Name of the sales representative |
| `product_id` | INT (FK) | No | References `products.product_id` |
| `quantity` | INT | No | Number of units sold |
| `unit_price` | NUMERIC(10,2) | No | Price per unit at time of sale |
| `sales_amount` | NUMERIC(12,2) | Computed | `quantity × unit_price` (generated column) |
| `discount_pct` | NUMERIC(5,2) | Yes | Discount percentage applied (0–100) |
| `customer_id` | INT | Yes | Customer identifier (anonymized) |
| `created_at` | TIMESTAMP | No | Record creation timestamp |

---

## Table: `products`

| Column | Type | Nullable | Description |
|---|---|---|---|
| `product_id` | INT (PK) | No | Unique product identifier |
| `product_name` | VARCHAR(150) | No | Descriptive product name |
| `category` | VARCHAR(80) | No | High-level category (Electronics, Office Supplies, Furniture, Clothing) |
| `sub_category` | VARCHAR(80) | Yes | Detailed sub-category |
| `unit_cost` | NUMERIC(10,2) | No | Cost to the company per unit |
| `created_at` | TIMESTAMP | No | Record creation timestamp |

---

## Table: `returns`

| Column | Type | Nullable | Description |
|---|---|---|---|
| `return_id` | INT (PK) | No | Unique return record identifier |
| `transaction_id` | INT (FK) | No | References `sales_transactions.transaction_id` |
| `return_date` | DATE | No | Date the return was processed |
| `return_amount` | NUMERIC(12,2) | No | Value of goods returned |
| `return_reason` | VARCHAR(200) | Yes | Customer-stated reason for return |
| `processed_by` | VARCHAR(100) | Yes | Staff member who processed the return |
| `created_at` | TIMESTAMP | No | Record creation timestamp |

---

## View: `vw_powerbi_export` (Power BI import table)

Flat denormalized view combining all 3 tables.

| Column | Source | Description |
|---|---|---|
| `transaction_id` | sales_transactions | Transaction key |
| `sale_date` | sales_transactions | Sale date |
| `year` | Derived | Calendar year |
| `quarter` | Derived | Quarter number (1–4) |
| `month_num` | Derived | Month number (1–12) |
| `month_short` | Derived | Abbreviated month (Jan, Feb…) |
| `year_month` | Derived | Label for axis (Jan 2024) |
| `region` | sales_transactions | Geographic region |
| `product_name` | products | Product name |
| `category` | products | Product category |
| `sub_category` | products | Product sub-category |
| `unit_cost` | products | Cost per unit |
| `sales_amount` | sales_transactions | Gross sale value |
| `return_amount` | returns | Return value (0 if no return) |
| `return_reason` | returns | Return reason text |
| `return_flag` | Derived | 'Returned' or 'Kept' |
| `net_revenue` | Derived | `sales_amount − return_amount` |
| `gross_profit` | Derived | `sales_amount − (qty × unit_cost)` |
| `net_profit` | Derived | `gross_profit − return_amount` |

---

## Region Values

| Value | Coverage |
|---|---|
| North | Northern states/territory |
| South | Southern states/territory |
| East | Eastern states/territory |
| West | Western states/territory |
| Central | Central states/territory |

---

## Product Categories

| Category | Sub-categories |
|---|---|
| Electronics | Phones, Laptops, Accessories, Tablets |
| Office Supplies | Paper, Binders, Pens, Storage |
| Furniture | Chairs, Desks, Bookcases, Tables |
| Clothing | Men's, Women's, Kids', Accessories |

---

## Return Reasons

| Reason | Description |
|---|---|
| Defective Product | Item arrived damaged or malfunctioned |
| Wrong Item Shipped | Customer received incorrect product |
| Not As Described | Product differed from listing |
| Changed Mind | Customer no longer wanted item |
| Late Delivery | Order arrived past agreed date |
| No Return | (Sentinel value for non-returned transactions) |
