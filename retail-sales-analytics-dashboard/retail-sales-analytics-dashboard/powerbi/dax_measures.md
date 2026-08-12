# DAX Measures — Retail Sales Analytics Dashboard
_Project demo using simulated retail data. All results are illustrative._

All measures below are written against `FactSales` (and `FactInventory` where noted), assuming `DimDate` is marked as the model's date table.

```DAX
Total Sales =
SUM ( FactSales[net_revenue] )
```
Sums net revenue (after discount) across whatever filter context — date range, region, product — is currently applied.

```DAX
Total Profit =
SUM ( FactSales[gross_profit] )
```
Sums realized gross profit (net revenue minus cost of goods sold) for the current filter context.

```DAX
Profit Margin % =
DIVIDE ( [Total Profit], [Total Sales], 0 )
```
Profit as a percentage of sales. `DIVIDE` guards against a divide-by-zero blank when a filter context has no sales.

```DAX
Total Orders =
DISTINCTCOUNT ( FactSales[order_date] )
```
_Note: in the full model this counts `order_id` from an unhidden key column; shown here against `order_date` only where a distinct order key is not exposed to the report. Prefer counting the true order key when available._

```DAX
Average Order Value =
DIVIDE ( [Total Sales], [Total Orders], 0 )
```
Average revenue per order — a core efficiency KPI on the Executive Overview page.

```DAX
Sales Previous Month =
CALCULATE (
    [Total Sales],
    DATEADD ( DimDate[date_key], -1, MONTH )
)
```
Shifts the current filter context back one month using the DimDate time-intelligence relationship.

```DAX
MoM Sales Growth % =
DIVIDE (
    [Total Sales] - [Sales Previous Month],
    [Sales Previous Month],
    0
)
```
Month-over-month percentage change in sales, used on the Executive Overview KPI card.

```DAX
Profit Previous Month =
CALCULATE (
    [Total Profit],
    DATEADD ( DimDate[date_key], -1, MONTH )
)
```
Same shift pattern applied to profit, feeding the Profitability Analysis page.

```DAX
MoM Profit Growth % =
DIVIDE (
    [Total Profit] - [Profit Previous Month],
    [Profit Previous Month],
    0
)
```
Month-over-month percentage change in gross profit.

```DAX
Sales per Store =
DIVIDE (
    [Total Sales],
    DISTINCTCOUNT ( FactSales[store_id] ),
    0
)
```
Average revenue per active store in the current filter context — used on the Regional Sales Analysis page to compare store productivity independent of region size.

```DAX
Inventory Turnover =
VAR UnitsSold = SUM ( FactSales[quantity] )
VAR AvgUnitsOnHand = AVERAGE ( FactInventory[units_on_hand] )
RETURN
    DIVIDE ( UnitsSold, AvgUnitsOnHand, 0 )
```
Approximates how many times inventory "turns over" in the selected period — units sold divided by average units on hand — feeding the Inventory Analytics page. In production this is typically computed against a matched date window between the two fact tables.

---

## Measure organization

All measures live in a dedicated, hidden `_Measures` table (a best practice for keeping the Fields pane clean) and are grouped into display folders: `Sales`, `Profitability`, `Operations`, mirroring the dashboard pages they support.
