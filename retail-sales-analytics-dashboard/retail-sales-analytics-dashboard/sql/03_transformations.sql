-- ============================================================================
-- RETAIL SALES ANALYTICS DASHBOARD (Project Demo — Simulated Data)
-- 03_transformations.sql
-- Analytical transformations used for reporting and validation before the
-- data is loaded into Power BI. All results are illustrative/simulated.
-- ============================================================================

-- ----------------------------------------------------------------------------
-- 1) Analytics-ready sales line view
--    One row per order line with revenue, cost, and profit already computed.
-- ----------------------------------------------------------------------------
CREATE OR REPLACE VIEW vw_sales_line AS
SELECT
    oi.order_item_id,
    o.order_id,
    o.order_number,
    o.order_datetime,
    DATE_TRUNC('day', o.order_datetime)::DATE   AS order_date,
    o.order_channel,
    o.payment_method,
    o.order_status,
    c.customer_id,
    c.loyalty_tier,
    s.store_id,
    s.store_name,
    s.store_type,
    r.region_id,
    r.region_name,
    p.product_id,
    p.sku,
    p.product_name,
    pc.category_name,
    pc.department,
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
JOIN orders o        ON o.order_id = oi.order_id
JOIN customers c      ON c.customer_id = o.customer_id
JOIN stores s          ON s.store_id = o.store_id
JOIN regions r          ON r.region_id = s.region_id
JOIN products p          ON p.product_id = oi.product_id
JOIN product_categories pc ON pc.category_id = p.category_id
WHERE o.order_status = 'Completed';

-- ----------------------------------------------------------------------------
-- 2) Monthly sales & profit aggregation
--    Feeds Power BI trend visuals and MoM DAX measures.
-- ----------------------------------------------------------------------------
CREATE OR REPLACE VIEW vw_monthly_sales_profit AS
SELECT
    DATE_TRUNC('month', order_date)::DATE AS sales_month,
    region_name,
    COUNT(DISTINCT order_id)              AS order_count,
    SUM(net_revenue)                      AS total_revenue,
    SUM(gross_profit)                     AS total_profit,
    ROUND(SUM(gross_profit) / NULLIF(SUM(net_revenue), 0) * 100, 2) AS profit_margin_pct
FROM vw_sales_line
GROUP BY 1, 2
ORDER BY 1, 2;

-- ----------------------------------------------------------------------------
-- 3) Product profitability ranking
--    Ranks SKUs by gross profit within each category — feeds the Product
--    Performance dashboard page.
-- ----------------------------------------------------------------------------
CREATE OR REPLACE VIEW vw_product_profitability AS
SELECT
    sku,
    product_name,
    category_name,
    SUM(quantity)                                        AS units_sold,
    SUM(net_revenue)                                      AS total_revenue,
    SUM(gross_profit)                                      AS total_profit,
    ROUND(SUM(gross_profit) / NULLIF(SUM(net_revenue), 0) * 100, 2) AS profit_margin_pct,
    RANK() OVER (
        PARTITION BY category_name
        ORDER BY SUM(gross_profit) DESC
    ) AS profit_rank_in_category
FROM vw_sales_line
GROUP BY sku, product_name, category_name
ORDER BY category_name, profit_rank_in_category;

-- ----------------------------------------------------------------------------
-- 4) Customer segmentation summary
--    Recency / frequency / monetary base for the Customer Segmentation page.
-- ----------------------------------------------------------------------------
CREATE OR REPLACE VIEW vw_customer_rfm AS
SELECT
    customer_id,
    loyalty_tier,
    COUNT(DISTINCT order_id)                     AS order_count,
    SUM(net_revenue)                               AS lifetime_revenue,
    MAX(order_date)                                  AS last_order_date,
    (CURRENT_DATE - MAX(order_date))                   AS days_since_last_order
FROM vw_sales_line
GROUP BY customer_id, loyalty_tier;

-- ----------------------------------------------------------------------------
-- 5) Data-quality checks (run after each load)
-- ----------------------------------------------------------------------------
-- 5a. Order items referencing a completed order but missing from vw_sales_line
SELECT oi.order_item_id
FROM order_items oi
JOIN orders o ON o.order_id = oi.order_id
WHERE o.order_status = 'Completed'
  AND NOT EXISTS (SELECT 1 FROM vw_sales_line v WHERE v.order_item_id = oi.order_item_id);

-- 5b. Negative or zero net revenue rows (should be empty)
SELECT * FROM vw_sales_line WHERE net_revenue <= 0;

-- 5c. Orders with no order_items (orphaned headers)
SELECT o.order_id, o.order_number
FROM orders o
LEFT JOIN order_items oi ON oi.order_id = o.order_id
WHERE oi.order_item_id IS NULL;
