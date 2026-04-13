-- =============================================================
-- FILE: sql/schema/create_tables.sql
-- PURPOSE: Create normalized sales tables with indexes
-- =============================================================

-- ----------------------------
-- TABLE 1: products
-- ----------------------------
CREATE TABLE IF NOT EXISTS products (
    product_id      SERIAL PRIMARY KEY,
    product_name    VARCHAR(150)    NOT NULL,
    category        VARCHAR(80)     NOT NULL,
    sub_category    VARCHAR(80),
    unit_cost       NUMERIC(10, 2)  NOT NULL DEFAULT 0.00,
    created_at      TIMESTAMP       NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_products_category ON products (category);

-- ----------------------------
-- TABLE 2: sales_transactions
-- ----------------------------
CREATE TABLE IF NOT EXISTS sales_transactions (
    transaction_id  SERIAL PRIMARY KEY,
    sale_date       DATE            NOT NULL,
    region          VARCHAR(50)     NOT NULL,
    sales_rep       VARCHAR(100),
    product_id      INT             NOT NULL REFERENCES products(product_id),
    quantity        INT             NOT NULL DEFAULT 1,
    unit_price      NUMERIC(10, 2)  NOT NULL,
    sales_amount    NUMERIC(12, 2)  GENERATED ALWAYS AS (quantity * unit_price) STORED,
    discount_pct    NUMERIC(5, 2)   DEFAULT 0.00,
    customer_id     INT,
    created_at      TIMESTAMP       NOT NULL DEFAULT NOW()
);

-- Indexes for join & filter performance
CREATE INDEX idx_sales_product_id     ON sales_transactions (product_id);
CREATE INDEX idx_sales_date           ON sales_transactions (sale_date);
CREATE INDEX idx_sales_region         ON sales_transactions (region);
CREATE INDEX idx_sales_customer       ON sales_transactions (customer_id);

-- ----------------------------
-- TABLE 3: returns
-- ----------------------------
CREATE TABLE IF NOT EXISTS returns (
    return_id       SERIAL PRIMARY KEY,
    transaction_id  INT             NOT NULL REFERENCES sales_transactions(transaction_id),
    return_date     DATE            NOT NULL,
    return_amount   NUMERIC(12, 2)  NOT NULL,
    return_reason   VARCHAR(200),
    processed_by    VARCHAR(100),
    created_at      TIMESTAMP       NOT NULL DEFAULT NOW()
);

-- Index for join performance
CREATE INDEX idx_returns_transaction_id ON returns (transaction_id);
CREATE INDEX idx_returns_date           ON returns (return_date);
