-- ============================================================================
-- RETAIL SALES ANALYTICS DASHBOARD (Project Demo — Simulated Data)
-- 02_seed_demo_data.sql
-- Seed / demo-data guidance. All rows below are synthetic examples used to
-- illustrate shape and volume — not real transactions. In a full build,
-- these hand-written INSERTs are the seed for a generator script that
-- produces 50,000+ simulated order_items rows across ~24 months.
-- ============================================================================

BEGIN;

-- ----------------------------------------------------------------------------
-- REGIONS (5)
-- ----------------------------------------------------------------------------
INSERT INTO regions (region_name, country, time_zone) VALUES
    ('Northeast',  'USA', 'America/New_York'),
    ('Southeast',  'USA', 'America/New_York'),
    ('Midwest',    'USA', 'America/Chicago'),
    ('West',       'USA', 'America/Los_Angeles'),
    ('National Online', 'USA', 'America/Chicago')
ON CONFLICT (region_name) DO NOTHING;

-- ----------------------------------------------------------------------------
-- STORES (sample of a larger simulated chain)
-- ----------------------------------------------------------------------------
INSERT INTO stores (store_code, store_name, region_id, store_type, opened_date, square_footage, is_active) VALUES
    ('NE-001', 'Boston Downtown',      1, 'Flagship', '2018-03-01', 18500, TRUE),
    ('NE-002', 'Hartford Commons',     1, 'Standard', '2019-06-15', 9200,  TRUE),
    ('SE-001', 'Atlanta Peachtree',    2, 'Flagship', '2017-11-10', 21000, TRUE),
    ('SE-002', 'Orlando Outlet',       2, 'Outlet',   '2020-01-20', 7000,  TRUE),
    ('MW-001', 'Chicago Loop',         3, 'Flagship', '2016-09-05', 19800, TRUE),
    ('MW-002', 'Columbus Crossing',    3, 'Standard', '2019-02-18', 8800,  TRUE),
    ('WE-001', 'Los Angeles Fairfax',  4, 'Flagship', '2015-05-12', 22500, TRUE),
    ('WE-002', 'Seattle Pike',         4, 'Standard', '2018-08-22', 9600,  TRUE),
    ('ON-001', 'Online Storefront',    5, 'Online',   '2016-01-01', NULL,  TRUE)
ON CONFLICT (store_code) DO NOTHING;

-- ----------------------------------------------------------------------------
-- PRODUCT CATEGORIES
-- ----------------------------------------------------------------------------
INSERT INTO product_categories (category_name, department) VALUES
    ('Men''s Apparel',    'Apparel'),
    ('Women''s Apparel',  'Apparel'),
    ('Footwear',          'Apparel'),
    ('Home & Living',     'Home'),
    ('Electronics',       'Electronics'),
    ('Beauty & Personal Care', 'Health & Beauty')
ON CONFLICT (category_name) DO NOTHING;

-- ----------------------------------------------------------------------------
-- PRODUCTS (illustrative subset — a full build seeds 300–500 SKUs)
-- ----------------------------------------------------------------------------
INSERT INTO products (sku, product_name, category_id, unit_cost, unit_price, launch_date, is_discontinued) VALUES
    ('APM-1001', 'Classic Oxford Shirt',        1, 14.50, 39.99, '2021-02-01', FALSE),
    ('APM-1002', 'Slim Chino Pants',             1, 18.00, 44.99, '2021-02-01', FALSE),
    ('APW-2001', 'Wrap Midi Dress',              2, 16.75, 54.99, '2021-03-15', FALSE),
    ('APW-2002', 'Cropped Denim Jacket',         2, 21.00, 64.99, '2022-01-10', FALSE),
    ('FTW-3001', 'Everyday Running Shoe',        3, 27.00, 79.99, '2020-09-01', FALSE),
    ('FTW-3002', 'Leather Chelsea Boot',         3, 41.00, 119.99,'2021-10-05', FALSE),
    ('HOM-4001', 'Ceramic Pour-Over Set',        4, 9.25,  29.99, '2022-04-01', FALSE),
    ('HOM-4002', 'Linen Throw Blanket',          4, 12.00, 34.99, '2021-11-20', FALSE),
    ('ELE-5001', 'Wireless Earbuds Pro',         5, 32.00, 89.99, '2022-06-01', FALSE),
    ('ELE-5002', 'Smart Fitness Band',           5, 24.00, 69.99, '2023-01-15', FALSE),
    ('BPC-6001', 'Vitamin C Serum 30ml',         6, 4.50,  24.99, '2021-05-01', FALSE),
    ('BPC-6002', 'Repair Shampoo & Conditioner', 6, 3.75,  18.99, '2020-07-01', FALSE)
ON CONFLICT (sku) DO NOTHING;

-- ----------------------------------------------------------------------------
-- CUSTOMERS (illustrative subset — a full build seeds 5,000–10,000 customers)
-- ----------------------------------------------------------------------------
INSERT INTO customers (customer_code, first_name, last_name, email, signup_date, loyalty_tier, home_region_id, is_active) VALUES
    ('CUST-00001', 'Jordan',  'Reyes',    'jordan.demo@example.com',  '2021-01-12', 'Gold',     1, TRUE),
    ('CUST-00002', 'Priya',   'Nair',     'priya.demo@example.com',   '2021-03-22', 'Platinum', 4, TRUE),
    ('CUST-00003', 'Marcus',  'Ola',      'marcus.demo@example.com',  '2022-05-02', 'Standard', 2, TRUE),
    ('CUST-00004', 'Elena',   'Voss',     'elena.demo@example.com',   '2020-11-30', 'Silver',   3, TRUE),
    ('CUST-00005', 'Tyler',   'Brooks',   'tyler.demo@example.com',   '2023-02-14', 'Standard', 5, TRUE)
ON CONFLICT (customer_code) DO NOTHING;

-- ----------------------------------------------------------------------------
-- ORDERS + ORDER_ITEMS (illustrative sample — full pipeline generates
-- 50,000+ order_items rows spanning ~24 months across all stores)
-- ----------------------------------------------------------------------------
INSERT INTO orders (order_number, customer_id, store_id, order_datetime, order_channel, payment_method, order_status) VALUES
    ('ORD-100001', 1, 1, '2024-01-05 10:14:00', 'In-Store', 'Card',           'Completed'),
    ('ORD-100002', 2, 9, '2024-01-06 14:02:00', 'Online',   'Digital Wallet', 'Completed'),
    ('ORD-100003', 3, 3, '2024-01-06 16:45:00', 'In-Store', 'Cash',           'Completed'),
    ('ORD-100004', 4, 5, '2024-01-07 11:30:00', 'In-Store', 'Card',           'Refunded'),
    ('ORD-100005', 5, 9, '2024-01-08 09:05:00', 'Mobile App','Digital Wallet','Completed')
ON CONFLICT (order_number) DO NOTHING;

INSERT INTO order_items (order_id, product_id, quantity, unit_price_at_sale, unit_cost_at_sale, discount_pct) VALUES
    (1, 1, 2, 39.99, 14.50, 0),
    (1, 5, 1, 79.99, 27.00, 10),
    (2, 9, 1, 89.99, 32.00, 0),
    (3, 3, 1, 54.99, 16.75, 0),
    (4, 6, 1, 119.99,41.00, 0),
    (5, 11,2, 24.99, 4.50,  15);

-- ----------------------------------------------------------------------------
-- INVENTORY SNAPSHOTS (illustrative — full build snapshots weekly per store)
-- ----------------------------------------------------------------------------
INSERT INTO inventory_snapshots (snapshot_date, store_id, product_id, units_on_hand, units_reordered) VALUES
    ('2024-01-01', 1, 1, 120, 0),
    ('2024-01-01', 1, 5, 45,  20),
    ('2024-01-01', 3, 3, 80,  0),
    ('2024-01-01', 5, 6, 30,  15),
    ('2024-01-01', 9, 9, 200, 50)
ON CONFLICT (snapshot_date, store_id, product_id) DO NOTHING;

COMMIT;

-- Generator guidance for reaching 50,000+ simulated order_items rows:
--   1. Loop over ~24 months x ~9 stores x ~40 orders/day (weighted by store type).
--   2. For each order, attach 1–4 order_items with product mix weighted by
--      category popularity and a seasonal multiplier (e.g., +30% Nov–Dec).
--   3. Vary discount_pct (0, 10, 15, 20) with an 80/20 no-discount/discount split.
--   4. Assign order_status as 3% Refunded, 1% Cancelled, 96% Completed.
--   5. Use PostgreSQL's generate_series() + random() to script this in a
--      procedural block or an external Python/SQL loader.
