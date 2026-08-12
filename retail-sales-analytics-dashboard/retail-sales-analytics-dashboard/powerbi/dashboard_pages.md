# Power BI Dashboard — Page Specification
_Project demo using simulated retail data. All figures elsewhere in this project are illustrative._

Six report pages, each answering a distinct set of stakeholder questions, sharing a common global slicer panel (Date range, Region, Store type) synced across pages via Power BI's "Sync slicers" pane.

---

## 1. Executive Overview
**User questions answered**
- How is the business performing right now vs. last month and last year?
- Where do sales and profit stand against a rolling trend?

**Visuals**
- KPI cards: Total Sales, Total Profit, Profit Margin %, MoM Sales Growth %
- Line chart: Net revenue by month (last 24 months), with a secondary line for gross profit
- Column chart: Revenue by region
- Donut chart: Revenue share by order channel (In-Store / Online / Mobile App)

**Slicers:** Date range, Region
**Interaction behavior:** Clicking a region column cross-filters the trend line and channel donut to that region only; KPI cards respond to the active slicer/filter context.

---

## 2. Regional Sales Analysis
**User questions answered**
- Which regions and stores are over- or under-performing?
- How does store type (Flagship / Standard / Outlet / Online) affect productivity?

**Visuals**
- Filled map: Revenue by region
- Bar chart: Revenue per square foot by store (excludes Online)
- Matrix: Store × month revenue with conditional-formatting heat map
- KPI card: Sales per Store (average)

**Slicers:** Region, Store type
**Interaction behavior:** Map selection filters the matrix and bar chart; matrix supports drill-down from Region → Store.

---

## 3. Product Performance
**User questions answered**
- Which products and categories drive the most revenue and profit?
- What's selling well but priced too thin, or priced well but not moving?

**Visuals**
- Treemap: Revenue by category → product
- Table: Top 20 products ranked by gross profit (from `vw_product_profitability`)
- Scatter chart: Units sold (x) vs. profit margin % (y), bubble size = total profit
- KPI card: Average Order Value

**Slicers:** Category, Date range
**Interaction behavior:** Treemap click filters the ranked table and scatter chart to the selected category.

---

## 4. Customer Segmentation
**User questions answered**
- Who are the highest-value customers, and which loyalty tier drives the most revenue?
- How recent and frequent is customer purchasing behavior?

**Visuals**
- Stacked bar: Revenue by loyalty tier
- Card visuals: Active customers, Repeat purchase rate
- Table: Customer RFM summary (order count, lifetime revenue, days since last order) from `vw_customer_rfm`
- Column chart: New vs. returning customer revenue by month

**Slicers:** Loyalty tier, Region
**Interaction behavior:** Loyalty-tier bar click filters the RFM table to that tier.

---

## 5. Profitability Analysis
**User questions answered**
- Where is margin being won or lost — by category, store, or discount level?
- How does discounting affect realized profit?

**Visuals**
- Line + column combo: Monthly revenue (column) vs. profit margin % (line)
- Matrix: Category × discount band, showing gross profit and margin %
- KPI cards: Total Profit, Profit Margin %, MoM Profit Growth %
- Waterfall chart: Profit bridge from prior month to current month

**Slicers:** Date range, Category
**Interaction behavior:** Waterfall and combo chart respond to date-range slicer; matrix supports export-to-CSV for finance follow-up.

---

## 6. Inventory Analytics
**User questions answered**
- Which products are at risk of stockout or overstock?
- How efficiently is inventory turning relative to sales velocity?

**Visuals**
- Bar chart: Inventory Turnover by category (from DAX measure)
- Table: Units on hand vs. units sold (last 30 days) by product, flagged low-stock (<15 units)
- Line chart: Units on hand trend by store over time
- KPI card: Average Inventory Turnover

**Slicers:** Store, Category
**Interaction behavior:** Low-stock rows conditionally highlighted in red; clicking a store in the trend chart filters the units-on-hand table.

---

## Global design notes
- All pages share a fixed header with page navigation buttons (bookmarks) and the global slicer panel.
- Tooltips use a custom tooltip page showing a mini trend sparkline for the hovered data point.
- Every KPI card that reflects simulated figures is labeled "Illustrative" in its subtitle, consistent with the case-study website.
