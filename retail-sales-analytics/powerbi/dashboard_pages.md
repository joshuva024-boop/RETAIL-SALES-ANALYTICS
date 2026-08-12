# Power BI Dashboard Pages Specification — RETAIL SALES ANALYTICS

> [!NOTE]
> **Project Demo — Simulated Data**. All report pages, visual designs, and KPIs are project concepts using synthetic retail data.

---

## 1. Executive Overview
- **Objective**: C-suite executive dashboard summarizing top-line performance, overall profitability, sales momentum, and regional breakdown.
- **Key Visuals**:
  - **KPI Header**: Total Sales (`$4.82M`), Total Profit (`$612K`), Profit Margin (`12.7%`), MoM Growth (`+8.4%`), Order Count (`50K+`).
  - **Monthly Trend Chart**: Dual-axis line & combo bar chart showing Monthly Net Revenue vs. Gross Profit.
  - **Category Breakdown**: Donut chart of revenue share by Product Department (Technology, Living, Fashion, Recreation, Wellness).
  - **Regional Summary Table**: Store count, sales volume, profit margin %, and MoM growth rate per region.

---

## 2. Regional Sales Analysis
- **Objective**: Operational analysis of geographic store performance, channel distribution, and regional density.
- **Key Visuals**:
  - **Geographic Map / Filled Area Visual**: Sales revenue bubble map across North America, Europe, and Asia Pacific.
  - **Store Performance Matrix**: Sales per Store (`$535K avg`), Store Type (Flagship, Standard, Outlet, Online), Square Footage Productivity.
  - **Channel Split**: Stacked bar chart comparing In-Store vs. Online vs. Mobile App by Region.

---

## 3. Product Performance
- **Objective**: Category management analysis identifying revenue drivers, margin leaders, and pricing sensitivity.
- **Key Visuals**:
  - **Category & Subcategory Treemap**: Hierarchical layout of revenue by product category.
  - **Top 10 SKUs Bar Chart**: Ranked by Net Revenue and Gross Profit contribution.
  - **Discount vs. Profit Scatter Plot**: Relationship between discount percentage and gross profit margin to detect margin erosion.

---

## 4. Customer Segmentation
- **Objective**: Customer analytics tracking loyalty tier activity, repeat purchase frequency, and customer lifetime value.
- **Key Visuals**:
  - **Loyalty Tier Matrix**: Customer counts, average order frequency, and revenue for Standard, Silver, Gold, and Platinum members.
  - **RFM Distribution**: Recency vs. Frequency distribution histogram.
  - **Repeat Purchase Rate Card**: % of customers with 2+ completed orders.

---

## 5. Profitability Analysis
- **Objective**: Financial Deep Dive on margin protection, low-margin SKU detection, and discounting impact.
- **Key Visuals**:
  - **Waterfall Chart**: Gross Revenue → Discounts → Net Revenue → Cost of Goods Sold (COGS) → Realized Gross Profit.
  - **Low-Margin SKU Table**: Products operating under 10% margin threshold highlighted with conditional red status indicators.
  - **MoM Profit Growth Trend**: Line chart tracking MoM profit dollar change alongside sales growth.

---

## 6. Inventory Analytics
- **Objective**: Supply chain monitoring of stock levels, inventory turnover rates, and stock-out risks.
- **Key Visuals**:
  - **Inventory Turnover Gauge**: Actual turnover ratio (`4.2x`) vs target turnover benchmark (`5.0x`).
  - **Stock Risk Indicator Table**: Products with low units on hand relative to historical 30-day run rate.
  - **Store Reorder Status Chart**: Units reordered vs. units on hand across active warehouse locations.
