-- ============================================================================
-- RETAIL SALES ANALYTICS (Project Demo — Simulated Data)
-- File: sql/04_powerbi_views.sql
-- Description: Analytics-ready views designed specifically for Power BI ingestion.
-- ============================================================================

-- 1. FactSales View for Power BI Star Schema
CREATE OR REPLACE VIEW vw_powerbi_fact_sales AS
SELECT
    oi.order_item_id,
    o.order_id,
    DATE_TRUNC('day', o.order_datetime)::DATE AS date_key,
    o.customer_id,
    o.store_id,
    oi.product_id,
    o.order_channel,
    o.payment_method,
    oi.quantity,
    oi.unit_price_at_sale,
    oi.unit_cost_at_sale,
    oi.discount_pct,
    ROUND(oi.quantity * oi.unit_price_at_sale * (1 - oi.discount_pct / 100.0), 2) AS net_revenue,
    ROUND(oi.quantity * oi.unit_cost_at_sale, 2)                                   AS total_cost,
    ROUND(
        oi.quantity * oi.unit_price_at_sale * (1 - oi.discount_pct / 100.0)
        - oi.quantity * oi.unit_cost_at_sale, 2
    ) AS gross_profit
FROM order_items oi
JOIN orders o ON o.order_id = oi.order_id
WHERE o.order_status = 'Completed';

-- 2. DimCustomer View
CREATE OR REPLACE VIEW vw_powerbi_dim_customer AS
SELECT
    c.customer_id,
    c.customer_code,
    c.first_name || ' ' || c.last_name AS full_name,
    c.email,
    c.signup_date,
    c.loyalty_tier,
    r.region_name AS home_region
FROM customers c
LEFT JOIN regions r ON r.region_id = c.home_region_id;

-- 3. DimProduct View
CREATE OR REPLACE VIEW vw_powerbi_dim_product AS
SELECT
    p.product_id,
    p.sku,
    p.product_name,
    pc.category_name,
    pc.department,
    p.unit_cost,
    p.unit_price,
    p.is_discontinued
FROM products p
JOIN product_categories pc ON pc.category_id = p.category_id;

-- 4. DimStore View
CREATE OR REPLACE VIEW vw_powerbi_dim_store AS
SELECT
    s.store_id,
    s.store_code,
    s.store_name,
    s.store_type,
    s.opened_date,
    s.square_footage,
    r.region_id,
    r.region_name,
    r.country
FROM stores s
JOIN regions r ON r.region_id = s.region_id;

-- 5. FactInventory View
CREATE OR REPLACE VIEW vw_powerbi_fact_inventory AS
SELECT
    snapshot_id,
    snapshot_date AS date_key,
    store_id,
    product_id,
    units_on_hand,
    units_reordered
FROM inventory_snapshots;
