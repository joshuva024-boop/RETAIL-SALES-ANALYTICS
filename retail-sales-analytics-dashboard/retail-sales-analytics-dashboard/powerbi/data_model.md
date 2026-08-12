# Power BI Data Model — Retail Sales Analytics Dashboard
_Project demo using simulated retail data. All figures elsewhere in this project are illustrative._

## Star schema overview

```
                 ┌───────────────┐
                 │   DimDate     │
                 └───────┬───────┘
                         │ 1
        ┌────────────────┼────────────────┐
        │                │                │
        │ *              │ *              │ *
┌───────┴──────┐  ┌───────┴──────┐  ┌──────┴───────┐
│  DimCustomer │  │   DimStore   │  │  DimProduct  │
└───────┬──────┘  └───────┬──────┘  └──────┬───────┘
        │ 1               │ 1               │ 1
        └────────────────┐│┌────────────────┘
                          ▼▼
                    ┌───────────┐        ┌─────────────┐
                    │ FactSales │        │ DimRegion   │
                    └───────────┘        └──────┬──────┘
                                                 │ 1 : * (via DimStore)
                                          ┌──────┴──────┐
                                          │  DimStore   │
                                          └─────────────┘
```

A secondary fact table, `FactInventory`, connects to `DimDate`, `DimStore`, and `DimProduct` on the same conformed dimensions for stock and turnover analysis.

## Tables

### FactSales
- **Source view:** `pbi_fact_sales`
- **Grain:** one row per order line item (one product on one order)
- **Key measures base:** `net_revenue`, `total_cost`, `gross_profit`, `quantity`
- **Foreign keys:** `order_date` → DimDate, `customer_id` → DimCustomer, `store_id` → DimStore, `product_id` → DimProduct
- **Hidden technical columns:** `fact_sales_id` (hide from report view; keep for row-level uniqueness only)

### FactInventory
- **Source view:** `pbi_fact_inventory`
- **Grain:** one row per store × product × snapshot date
- **Key measures base:** `units_on_hand`, `units_reordered`
- **Foreign keys:** `snapshot_date` → DimDate, `store_id` → DimStore, `product_id` → DimProduct

### DimDate
- **Source view:** `pbi_dim_date`
- **Grain:** one row per calendar day, 2022-01-01 through 2025-12-31
- **Mark as date table:** Yes, on `date_key` (Table tools → Mark as date table)
- **Hidden technical columns:** none required; hide `weekday_number` from report view (kept for sort-by-column on `weekday_name`)
- **Sort-by-column:** `month_name` sorted by `month_number`; `weekday_name` sorted by `weekday_number`

### DimCustomer
- **Source view:** `pbi_dim_customer`
- **Grain:** one row per customer
- **Notable columns:** `loyalty_tier`, `home_region`, `signup_date`

### DimProduct
- **Source view:** `pbi_dim_product`
- **Grain:** one row per SKU
- **Notable columns:** `category_name`, `department`, `list_margin_pct` (list-price margin, distinct from realized `profit_margin_pct` measure)

### DimStore
- **Source view:** `pbi_dim_store`
- **Grain:** one row per store
- **Notable columns:** `store_type`, `square_footage` (used in per-square-foot productivity measures)

### DimRegion
- **Source view:** `pbi_dim_region`
- **Grain:** one row per region
- **Relationship:** DimStore → DimRegion is modeled as a snowflake off DimStore (region filters flow through DimStore to FactSales) to keep FactSales grain clean.

## Relationships & filter direction

| From          | To         | Cardinality | Cross-filter direction |
|---------------|-----------|-------------|--------------------------|
| DimDate       | FactSales  | 1 : *       | Single (Date → Fact)      |
| DimCustomer   | FactSales  | 1 : *       | Single                    |
| DimStore      | FactSales  | 1 : *       | Single                    |
| DimProduct    | FactSales  | 1 : *       | Single                    |
| DimStore      | DimRegion  | * : 1       | Single (Store → Region)   |
| DimDate       | FactInventory | 1 : *   | Single                    |
| DimStore      | FactInventory | 1 : *   | Single                    |
| DimProduct    | FactInventory | 1 : *   | Single                    |

All relationships are single-direction to keep the model predictable and avoid ambiguous filter paths — a common source of ballooning DAX complexity in star schemas. Region-level filtering flows through DimStore rather than a direct FactSales↔DimRegion relationship, which keeps FactSales' grain (order line item) untouched by the store↔region hierarchy.

## Why this model supports fast filtering & reliable DAX

- **Single-direction, one-to-many relationships** mean every filter has one unambiguous path to the fact table — Power BI's engine can resolve them without bidirectional-filter ambiguity or accidental many-to-many fan-out.
- **A dedicated, contiguous DimDate table** (rather than dates pulled from FactSales) is required for time-intelligence functions like `DATEADD`, `SAMEPERIODLASTYEAR`, and `PARALLELPERIOD` to behave correctly, and lets Inventory and Sales facts share one calendar for cross-fact time comparisons.
- **Surrogate, low-cardinality keys** on dimension tables keep join columns compact, which reduces the VertiPaq column-store footprint and speeds up cross-filtering.
- **Pre-aggregated cost/revenue/profit columns computed in SQL** (`net_revenue`, `total_cost`, `gross_profit`) push discount and cost logic upstream into the transformation layer, so DAX measures stay simple `SUM()`/`DIVIDE()` wrappers instead of re-deriving business logic at query time.

## Recommended data types

| Column                          | Power BI type       |
|----------------------------------|----------------------|
| `date_key`, `order_date`, `snapshot_date`, `signup_date`, `opened_date` | Date             |
| `net_revenue`, `total_cost`, `gross_profit`, `unit_price_at_sale`, `unit_cost_at_sale` | Fixed decimal number |
| `discount_pct`, `list_margin_pct` | Decimal number (percentage format) |
| `quantity`, `units_on_hand`, `units_reordered`, `year`, `month_number` | Whole number |
| `*_id`, `sku`, `store_code`, `customer_code` | Text (even numeric-looking IDs — prevents accidental aggregation) |
| `is_active`, `is_discontinued`, `is_weekend` | True/False |
