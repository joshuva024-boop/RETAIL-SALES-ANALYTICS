-- ============================================================================
-- RETAIL SALES ANALYTICS (Project Demo — Simulated Data)
-- File: sql/02_seed_demo_data.sql
-- Description: PL/pgSQL data generator script for 50,000+ simulated transactions.
-- ============================================================================

BEGIN;

-- Seed Regions
INSERT INTO regions (region_name, country, time_zone) VALUES
('North America East', 'United States', 'EST'),
('North America West', 'United States', 'PST'),
('Central', 'United States', 'CST'),
('Europe West', 'United Kingdom', 'GMT'),
('Asia Pacific', 'Japan', 'JST')
ON CONFLICT (region_name) DO NOTHING;

-- Seed Product Categories
INSERT INTO product_categories (category_name, department) VALUES
('Consumer Electronics', 'Technology'),
('Home Appliances', 'Living'),
('Apparel & Accessories', 'Fashion'),
('Sports & Outdoors', 'Recreation'),
('Beauty & Personal Care', 'Wellness')
ON CONFLICT (category_name) DO NOTHING;

-- Seed Stores
INSERT INTO stores (store_code, store_name, region_id, store_type, opened_date, square_footage) VALUES
('ST-101', 'Manhattan Flagship', 1, 'Flagship', '2019-03-15', 25000),
('ST-102', 'Boston Central', 1, 'Standard', '2020-06-10', 12000),
('ST-201', 'San Francisco Bay', 2, 'Flagship', '2018-11-01', 22000),
('ST-202', 'Seattle Storefront', 2, 'Standard', '2021-01-20', 10500),
('ST-301', 'Chicago Loop', 3, 'Standard', '2019-08-14', 15000),
('ST-302', 'Dallas Galleria', 3, 'Outlet', '2020-10-05', 18000),
('ST-401', 'London Regent St', 4, 'Flagship', '2019-01-12', 20000),
('ST-501', 'Tokyo Ginza', 5, 'Flagship', '2020-02-18', 21000),
('ST-900', 'Direct Online Store', 1, 'Online', '2017-05-01', NULL)
ON CONFLICT (store_code) DO NOTHING;

-- Seed Products
INSERT INTO products (sku, product_name, category_id, unit_cost, unit_price, launch_date) VALUES
('TECH-4K-55', 'UltraHD 55-inch Smart TV', 1, 320.00, 599.99, '2021-01-15'),
('TECH-AUDIO-BT', 'Noise-Canceling Headphones', 1, 75.00, 189.99, '2021-04-10'),
('TECH-LAPTOP-14', 'Pro Book 14-inch Laptop', 1, 650.00, 1199.00, '2020-09-01'),
('HOME-ROBOT-V', 'Smart Robot Vacuum Cleaner', 2, 140.00, 329.50, '2021-02-28'),
('HOME-COFFEE-EX', 'Espresso Barista Machine', 2, 110.00, 249.00, '2020-11-15'),
('HOME-AIR-PUR', 'HEPA Air Purifier Pro', 2, 60.00, 149.99, '2021-05-01'),
('FASH-JACKET-W', 'All-Weather Thermal Parka', 3, 45.00, 129.00, '2020-10-01'),
('FASH-SNEAK-RUN', 'Pro Runner Sneakers', 3, 30.00, 89.95, '2021-03-01'),
('SPORT-BIKE-MTB', 'Mountain Trail Bicycle', 4, 280.00, 599.00, '2020-04-12'),
('WELL-SKIN-SET', 'Hydrating Skincare Bundle', 5, 18.00, 65.00, '2021-06-01')
ON CONFLICT (sku) DO NOTHING;

-- Data Generation Procedure for Simulated Transactions (50,000+ items)
DO $$
DECLARE
    v_cust_id INT;
    v_store_id INT;
    v_order_id BIGINT;
    v_order_date TIMESTAMP;
    v_channel TEXT;
    v_payment TEXT;
    v_channels TEXT[] := ARRAY['In-Store', 'Online', 'Mobile App'];
    v_payments TEXT[] := ARRAY['Card', 'Cash', 'Digital Wallet', 'Gift Card'];
    v_tiers TEXT[]    := ARRAY['Standard', 'Silver', 'Gold', 'Platinum'];
    v_i INT;
    v_j INT;
    v_num_items INT;
    v_prod_id INT;
    v_cost NUMERIC(10,2);
    v_price NUMERIC(10,2);
    v_disc NUMERIC(5,2);
BEGIN
    -- Seed Customers if empty
    IF (SELECT COUNT(*) FROM customers) < 100 THEN
        FOR v_i IN 1..500 LOOP
            INSERT INTO customers (customer_code, first_name, last_name, email, signup_date, loyalty_tier, home_region_id)
            VALUES (
                'CUST-' || LPAD(v_i::TEXT, 5, '0'),
                'Customer_' || v_i,
                'User_' || (v_i % 50),
                'user' || v_i || '@example-simulated.com',
                '2021-01-01'::DATE + (v_i % 700 * INTERVAL '1 day')::INTERVAL,
                v_tiers[1 + (v_i % 4)],
                1 + (v_i % 5)
            ) ON CONFLICT DO NOTHING;
        END LOOP;
    END IF;

    -- Seed 20,000 Orders with 2-3 items each (~50,000+ Order Items)
    IF (SELECT COUNT(*) FROM orders) < 5000 THEN
        FOR v_i IN 1..18000 LOOP
            v_cust_id := 1 + (v_i % 500);
            v_store_id := 1 + (v_i % 9);
            v_order_date := '2022-01-01 08:00:00'::TIMESTAMP + (v_i * INTERVAL '50 minutes');
            v_channel := v_channels[1 + (v_i % 3)];
            v_payment := v_payments[1 + (v_i % 4)];

            INSERT INTO orders (order_number, customer_id, store_id, order_datetime, order_channel, payment_method, order_status)
            VALUES ('ORD-2022-' || LPAD(v_i::TEXT, 6, '0'), v_cust_id, v_store_id, v_order_date, v_channel, v_payment, 'Completed')
            RETURNING order_id INTO v_order_id;

            v_num_items := 1 + (v_i % 3);
            FOR v_j IN 1..v_num_items LOOP
                v_prod_id := 1 + ((v_i + v_j) % 10);
                SELECT unit_cost, unit_price INTO v_cost, v_price FROM products WHERE product_id = v_prod_id;
                v_disc := CASE WHEN (v_i + v_j) % 5 = 0 THEN 10.0 ELSE 0.0 END;

                INSERT INTO order_items (order_id, product_id, quantity, unit_price_at_sale, unit_cost_at_sale, discount_pct)
                VALUES (v_order_id, v_prod_id, 1 + ((v_i + v_j) % 4), v_price, v_cost, v_disc);
            END LOOP;
        END LOOP;
    END IF;
END $$;

COMMIT;
