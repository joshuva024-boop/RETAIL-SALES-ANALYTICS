-- ============================================================================
-- RETAIL SALES ANALYTICS DASHBOARD (Project Demo — Simulated Data)
-- 04_powerbi_views.sql
-- Flattened, Power BI-ready views. Power BI connects to these views (not the
-- raw transactional tables) via Import mode, one view per star-schema table.
-- ============================================================================

-- ----------------------------------------------------------------------------
-- FactSales — grain: one row per order line item
-- ----------------------------------------------------------------------------
CREATE OR REPLACE VIEW pbi_fact_sales AS
SELECT
    order_item_id  AS fact_sales_id,
    order_date,
    customer_id,
    store_id,
    product_id,
    order_channel,
    payment_method,
    quantity,
    unit_price_at_sale,
    unit_cost_at_sale,
    discount_pct,
    net_revenue,
    total_cost,
    gross_profit
FROM vw_sales_line;

-- ----------------------------------------------------------------------------
-- DimDate — contiguous calendar table, mark as a Power BI date table on load
-- ----------------------------------------------------------------------------
CREATE OR REPLACE VIEW pbi_dim_date AS
SELECT
    d::DATE                                   AS date_key,
    EXTRACT(YEAR FROM d)::INT                 AS year,
    EXTRACT(QUARTER FROM d)::INT              AS quarter,
    EXTRACT(MONTH FROM d)::INT                AS month_number,
    TO_CHAR(d, 'Month')                       AS month_name,
    TO_CHAR(d, 'YYYY-MM')                     AS year_month,
    EXTRACT(ISODOW FROM d)::INT               AS weekday_number,
    TO_CHAR(d, 'Day')                         AS weekday_name,
    (EXTRACT(ISODOW FROM d) IN (6, 7))        AS is_weekend
FROM GENERATE_SERIES('2022-01-01'::DATE, '2025-12-31'::DATE, '1 day') AS d;

-- ----------------------------------------------------------------------------
-- DimCustomer
-- ----------------------------------------------------------------------------
CREATE OR REPLACE VIEW pbi_dim_customer AS
SELECT
    c.customer_id,
    c.customer_code,
    c.first_name || ' ' || c.last_name AS customer_name,
    c.loyalty_tier,
    c.signup_date,
    r.region_name AS home_region,
    c.is_active
FROM customers c
LEFT JOIN regions r ON r.region_id = c.home_region_id;

-- ----------------------------------------------------------------------------
-- DimProduct
-- ----------------------------------------------------------------------------
CREATE OR REPLACE VIEW pbi_dim_product AS
SELECT
    p.product_id,
    p.sku,
    p.product_name,
    pc.category_name,
    pc.department,
    p.unit_cost,
    p.unit_price,
    ROUND((p.unit_price - p.unit_cost) / NULLIF(p.unit_price, 0) * 100, 2) AS list_margin_pct,
    p.is_discontinued
FROM products p
JOIN product_categories pc ON pc.category_id = p.category_id;

-- ----------------------------------------------------------------------------
-- DimStore
-- ----------------------------------------------------------------------------
CREATE OR REPLACE VIEW pbi_dim_store AS
SELECT
    s.store_id,
    s.store_code,
    s.store_name,
    s.store_type,
    s.opened_date,
    s.square_footage,
    s.region_id,
    s.is_active
FROM stores s;

-- ----------------------------------------------------------------------------
-- DimRegion
-- ----------------------------------------------------------------------------
CREATE OR REPLACE VIEW pbi_dim_region AS
SELECT
    region_id,
    region_name,
    country,
    time_zone
FROM regions;

-- ----------------------------------------------------------------------------
-- Inventory fact (secondary fact table, joins to DimDate/DimStore/DimProduct)
-- ----------------------------------------------------------------------------
CREATE OR REPLACE VIEW pbi_fact_inventory AS
SELECT
    snapshot_id AS fact_inventory_id,
    snapshot_date,
    store_id,
    product_id,
    units_on_hand,
    units_reordered
FROM inventory_snapshots;
