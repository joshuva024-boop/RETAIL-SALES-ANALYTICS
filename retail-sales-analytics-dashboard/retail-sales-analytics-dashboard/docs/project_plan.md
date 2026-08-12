# Project Plan — Retail Sales Analytics Dashboard
_Project demo using simulated retail data. Timeline and deliverables are illustrative of a realistic junior-to-mid data analyst engagement._

## Week 1 — Requirements & PostgreSQL data model
- Define stakeholder questions across sales, profitability, product, region, customer, and inventory reporting.
- Design the normalized transactional schema: `customers`, `products`, `product_categories`, `stores`, `regions`, `orders`, `order_items`, `inventory_snapshots`.
- Set primary/foreign keys, constraints, and indexes; document grain and relationships.
- Deliverable: `sql/01_create_schema.sql`

## Week 2 — SQL pipeline & data-quality checks
- Seed simulated demo data (regions, stores, products, customers, orders, order items, inventory snapshots) scaled toward 50,000+ order-line rows.
- Build transformation views: `vw_sales_line`, `vw_monthly_sales_profit`, `vw_product_profitability`, `vw_customer_rfm`.
- Write data-quality checks: orphaned order lines, non-positive revenue, orders with no line items.
- Deliverable: `sql/02_seed_demo_data.sql`, `sql/03_transformations.sql`

## Week 3 — Power BI star schema & DAX
- Build flattened, import-ready views for each star-schema table (`pbi_fact_sales`, `pbi_dim_date`, `pbi_dim_customer`, `pbi_dim_product`, `pbi_dim_store`, `pbi_dim_region`, `pbi_fact_inventory`).
- Load into Power BI, set relationships and cross-filter directions, mark `DimDate` as the date table.
- Write and test DAX measures: Total Sales, Total Profit, Profit Margin %, Total Orders, Average Order Value, MoM growth measures, Sales per Store, Inventory Turnover.
- Deliverable: `sql/04_powerbi_views.sql`, `powerbi/data_model.md`, `powerbi/dax_measures.md`

## Week 4 — Dashboard polish, documentation & case-study website
- Build the six dashboard pages (Executive Overview, Regional Sales Analysis, Product Performance, Customer Segmentation, Profitability Analysis, Inventory Analytics), synced slicers, tooltips, and conditional formatting.
- Finalize `powerbi/dashboard_pages.md` with visuals, slicers, and interaction behavior per page.
- Design and build the responsive case-study website (`website/`) summarizing the pipeline, SQL, model, dashboard design, and illustrative KPIs.
- Write `README.md` with setup instructions; label every metric across the project as Illustrative / Simulated / Project-demo.

## Milestones summary

| Week | Focus | Key deliverable |
|------|-------|------------------|
| 1 | Requirements + schema | `01_create_schema.sql` |
| 2 | Seed data + transformations | `02_seed_demo_data.sql`, `03_transformations.sql` |
| 3 | Star schema + DAX | `04_powerbi_views.sql`, `data_model.md`, `dax_measures.md` |
| 4 | Dashboard + website | `dashboard_pages.md`, `website/`, `README.md` |

## Assumptions & scope notes
- Data is entirely simulated; no real customer, store, or transaction records are used at any stage.
- The Power BI `.pbix` file itself is not included in this repository — the model, measures, and page specs are documented in Markdown so the dashboard can be rebuilt directly from these files in Power BI Desktop.
- The case-study website mocks dashboard visuals with HTML/CSS/SVG; it does not embed a live Power BI report.
