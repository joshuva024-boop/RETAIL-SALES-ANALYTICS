-- ============================================================================
-- RETAIL SALES ANALYTICS DASHBOARD (Project Demo — Simulated Data)
-- 01_create_schema.sql
-- Normalized PostgreSQL transactional schema for a simulated multi-region
-- retail chain. All data created by this pipeline is synthetic.
-- ============================================================================

BEGIN;

CREATE TABLE IF NOT EXISTS regions (
    region_id       SERIAL PRIMARY KEY,
    region_name     VARCHAR(60)  NOT NULL UNIQUE,
    country         VARCHAR(60)  NOT NULL,
    time_zone       VARCHAR(40)  NOT NULL DEFAULT 'UTC'
);

CREATE TABLE IF NOT EXISTS stores (
    store_id        SERIAL PRIMARY KEY,
    store_code      VARCHAR(10)  NOT NULL UNIQUE,
    store_name      VARCHAR(100) NOT NULL,
    region_id       INTEGER      NOT NULL REFERENCES regions(region_id),
    store_type      VARCHAR(30)  NOT NULL CHECK (store_type IN ('Flagship','Standard','Outlet','Online')),
    opened_date     DATE         NOT NULL,
    square_footage  INTEGER      CHECK (square_footage > 0),
    is_active       BOOLEAN      NOT NULL DEFAULT TRUE
);
CREATE INDEX IF NOT EXISTS idx_stores_region ON stores(region_id);

CREATE TABLE IF NOT EXISTS customers (
    customer_id     SERIAL PRIMARY KEY,
    customer_code   VARCHAR(12)  NOT NULL UNIQUE,
    first_name      VARCHAR(50)  NOT NULL,
    last_name       VARCHAR(50)  NOT NULL,
    email           VARCHAR(120) UNIQUE,
    signup_date     DATE         NOT NULL,
    loyalty_tier    VARCHAR(20)  NOT NULL DEFAULT 'Standard'
                     CHECK (loyalty_tier IN ('Standard','Silver','Gold','Platinum')),
    home_region_id  INTEGER      REFERENCES regions(region_id),
    is_active       BOOLEAN      NOT NULL DEFAULT TRUE
);
CREATE INDEX IF NOT EXISTS idx_customers_region ON customers(home_region_id);
CREATE INDEX IF NOT EXISTS idx_customers_tier ON customers(loyalty_tier);

CREATE TABLE IF NOT EXISTS product_categories (
    category_id     SERIAL PRIMARY KEY,
    category_name   VARCHAR(60) NOT NULL UNIQUE,
    department      VARCHAR(60) NOT NULL
);

CREATE TABLE IF NOT EXISTS products (
    product_id       SERIAL PRIMARY KEY,
    sku              VARCHAR(20)   NOT NULL UNIQUE,
    product_name     VARCHAR(150)  NOT NULL,
    category_id      INTEGER       NOT NULL REFERENCES product_categories(category_id),
    unit_cost        NUMERIC(10,2) NOT NULL CHECK (unit_cost >= 0),
    unit_price       NUMERIC(10,2) NOT NULL CHECK (unit_price >= 0),
    launch_date      DATE,
    is_discontinued  BOOLEAN NOT NULL DEFAULT FALSE
);
CREATE INDEX IF NOT EXISTS idx_products_category ON products(category_id);

CREATE TABLE IF NOT EXISTS orders (
    order_id        BIGSERIAL PRIMARY KEY,
    order_number     VARCHAR(20) NOT NULL UNIQUE,
    customer_id       INTEGER     NOT NULL REFERENCES customers(customer_id),
    store_id           INTEGER     NOT NULL REFERENCES stores(store_id),
    order_datetime       TIMESTAMP   NOT NULL,
    order_channel          VARCHAR(20) NOT NULL DEFAULT 'In-Store'
                            CHECK (order_channel IN ('In-Store','Online','Mobile App')),
    payment_method             VARCHAR(20) NOT NULL
                            CHECK (payment_method IN ('Card','Cash','Digital Wallet','Gift Card')),
    order_status                  VARCHAR(20) NOT NULL DEFAULT 'Completed'
                            CHECK (order_status IN ('Completed','Refunded','Cancelled'))
);
CREATE INDEX IF NOT EXISTS idx_orders_customer ON orders(customer_id);
CREATE INDEX IF NOT EXISTS idx_orders_store ON orders(store_id);
CREATE INDEX IF NOT EXISTS idx_orders_datetime ON orders(order_datetime);

CREATE TABLE IF NOT EXISTS order_items (
    order_item_id      BIGSERIAL PRIMARY KEY,
    order_id            BIGINT        NOT NULL REFERENCES orders(order_id) ON DELETE CASCADE,
    product_id            INTEGER       NOT NULL REFERENCES products(product_id),
    quantity                INTEGER       NOT NULL CHECK (quantity > 0),
    unit_price_at_sale        NUMERIC(10,2) NOT NULL CHECK (unit_price_at_sale >= 0),
    unit_cost_at_sale            NUMERIC(10,2) NOT NULL CHECK (unit_cost_at_sale >= 0),
    discount_pct                    NUMERIC(5,2) NOT NULL DEFAULT 0 CHECK (discount_pct BETWEEN 0 AND 100)
);
CREATE INDEX IF NOT EXISTS idx_order_items_order ON order_items(order_id);
CREATE INDEX IF NOT EXISTS idx_order_items_product ON order_items(product_id);

CREATE TABLE IF NOT EXISTS inventory_snapshots (
    snapshot_id      BIGSERIAL PRIMARY KEY,
    snapshot_date     DATE      NOT NULL,
    store_id            INTEGER   NOT NULL REFERENCES stores(store_id),
    product_id             INTEGER   NOT NULL REFERENCES products(product_id),
    units_on_hand              INTEGER   NOT NULL CHECK (units_on_hand >= 0),
    units_reordered               INTEGER   NOT NULL DEFAULT 0,
    UNIQUE (snapshot_date, store_id, product_id)
);
CREATE INDEX IF NOT EXISTS idx_inventory_date ON inventory_snapshots(snapshot_date);
CREATE INDEX IF NOT EXISTS idx_inventory_store_product ON inventory_snapshots(store_id, product_id);

COMMIT;

-- NOTE: This schema models a simulated retail chain for a portfolio project.
-- No real customer, store, or transaction data is represented.
