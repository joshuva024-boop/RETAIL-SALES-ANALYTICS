# DAX Measures Catalog — RETAIL SALES ANALYTICS

> [!NOTE]
> **Project Demo — Simulated Data**. All DAX measures are written for the star-schema model in Power BI.

---

## 1. Core Sales Measures

```dax
Total Sales =
SUM ( FactSales[net_revenue] )
```
*Description*: Calculates total net sales revenue after applying item discounts for the current filter context.

```dax
Total Orders =
DISTINCTCOUNT ( FactSales[order_id] )
```
*Description*: Counts distinct completed order IDs in the current filter context.

```dax
Average Order Value =
DIVIDE ( [Total Sales], [Total Orders], 0 )
```
*Description*: Calculates the average revenue generated per transaction. Uses `DIVIDE` to prevent zero division errors.

---

## 2. Profitability Measures

```dax
Total Profit =
SUM ( FactSales[gross_profit] )
```
*Description*: Calculates total gross profit (Net Revenue minus Cost of Goods Sold).

```dax
Profit Margin % =
DIVIDE ( [Total Profit], [Total Sales], 0 )
```
*Description*: Calculates the gross profit margin percentage.

---

## 3. Time Intelligence (Month-over-Month) Measures

```dax
Sales Previous Month =
CALCULATE (
    [Total Sales],
    DATEADD ( DimDate[date_key], -1, MONTH )
)
```
*Description*: Calculates total sales for the previous month using the `DimDate` relationship.

```dax
MoM Sales Growth % =
DIVIDE (
    [Total Sales] - [Sales Previous Month],
    [Sales Previous Month],
    0
)
```
*Description*: Calculates percentage growth in sales relative to the prior month.

```dax
Profit Previous Month =
CALCULATE (
    [Total Profit],
    DATEADD ( DimDate[date_key], -1, MONTH )
)
```
*Description*: Calculates total gross profit for the previous month.

```dax
MoM Profit Growth % =
DIVIDE (
    [Total Profit] - [Profit Previous Month],
    [Profit Previous Month],
    0
)
```
*Description*: Calculates percentage growth in gross profit relative to the prior month.

---

## 4. Operational & Inventory Measures

```dax
Sales per Store =
DIVIDE (
    [Total Sales],
    DISTINCTCOUNT ( FactSales[store_id] ),
    0
)
```
*Description*: Measures store productivity by computing average revenue generated per active store.

```dax
Inventory Turnover =
VAR UnitsSold = SUM ( FactSales[quantity] )
VAR AvgUnitsOnHand = AVERAGE ( FactInventory[units_on_hand] )
RETURN
    DIVIDE ( UnitsSold, AvgUnitsOnHand, 0 )
```
*Description*: Computes the annual inventory turnover ratio (units sold divided by average units on hand).
