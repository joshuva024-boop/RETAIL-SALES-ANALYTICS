# Power BI Star Schema Data Model — RETAIL SALES ANALYTICS

> [!NOTE]
> **Project Demo — Simulated Data**. All data models, relationships, and metadata definitions are based on synthetic transactions.

---

## Model Overview

The Power BI data model is designed using a **Star Schema** architecture optimized for fast analytical performance, clean DAX measure evaluation, and intuitive ad-hoc slicing.

```text
               ┌─────────────┐
               │   DimDate   │
               └──────┬──────┘
                      │ (1:N)
 ┌─────────────┐      │      ┌─────────────┐
 │ DimCustomer ├──────┼──────┤ DimProduct  │
 └─────────────┘(1:N) │ (1:N)└─────────────┘
                      ▼
               ┌─────────────┐
               │  FactSales  │
               └──────▲──────┘
                      │ (1:N)
               ┌──────┴──────┐
               │  DimStore   │
               └─────────────┘
```

---

## Fact Table Grain

### `FactSales`
- **Grain**: One record per line item (`order_item_id`) within a completed order.
- **Source View**: `vw_powerbi_fact_sales`
- **Key Columns**: `date_key`, `customer_id`, `store_id`, `product_id`
- **Measures / Additive Metrics**: `quantity`, `net_revenue`, `total_cost`, `gross_profit`, `discount_pct`.

### `FactInventory`
- **Grain**: One record per store, product, and snapshot date (`snapshot_id`).
- **Source View**: `vw_powerbi_fact_inventory`
- **Key Columns**: `date_key`, `store_id`, `product_id`.

---

## Relationships & Cardinality

| Foreign Key (Fact) | Target Table (Dimension) | Target Column | Cardinality | Cross Filter Direction |
| :--- | :--- | :--- | :--- | :--- |
| `FactSales[date_key]` | `DimDate` | `date_key` | Many to One (`*:1`) | Single |
| `FactSales[customer_id]` | `DimCustomer` | `customer_id` | Many to One (`*:1`) | Single |
| `FactSales[product_id]` | `DimProduct` | `product_id` | Many to One (`*:1`) | Single |
| `FactSales[store_id]` | `DimStore` | `store_id` | Many to One (`*:1`) | Single |
| `FactInventory[date_key]` | `DimDate` | `date_key` | Many to One (`*:1`) | Single |
| `FactInventory[store_id]` | `DimStore` | `store_id` | Many to One (`*:1`) | Single |
| `FactInventory[product_id]`| `DimProduct` | `product_id` | Many to One (`*:1`) | Single |

> [!IMPORTANT]
> All relationships use **Single Direction** filtering (Dimension → Fact). Bi-directional relationships are strictly avoided to prevent ambiguous filter paths and DAX context side effects.

---

## Date Table Setup

- `DimDate` is designated as the **Official Model Date Table** in Power BI (`Mark as Date Table`).
- **Date Range**: January 1, 2021 to December 31, 2024.
- **Key Columns**: `date_key` (Date format `YYYY-MM-DD`), `Year`, `Quarter`, `Month`, `MonthName`, `DayOfWeek`, `IsWeekend`, `FiscalYear`.

---

## Column Formatting & Hidden Key Columns

To maintain clean report views and prevent accidental aggregation of primary/foreign key surrogate IDs:

- **Hidden Columns**: `FactSales[customer_id]`, `FactSales[product_id]`, `FactSales[store_id]`, `FactSales[order_id]`, `FactSales[order_item_id]`.
- **Currency Columns**: Formatted as `$#,##0.00` (`net_revenue`, `total_cost`, `gross_profit`).
- **Percentage Columns**: Formatted as `0.0%` (`discount_pct`, `Profit Margin %`).
- **Quantities**: Formatted as integer `#,#0`.
