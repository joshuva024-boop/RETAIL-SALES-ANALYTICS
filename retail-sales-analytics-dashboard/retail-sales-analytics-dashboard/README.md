# RETAIL SALES ANALYTICS

A portfolio-ready retail sales analytics project demonstrating end-to-end data pipeline development: PostgreSQL database schema and transformations, a Power BI star-schema data model, custom DAX KPI measures, and a responsive web case study.

> [!IMPORTANT]
> **Project Demo Disclaimer**: All data, transactions, regional metrics, and business insights presented in this repository are **Simulated** and **Illustrative** for portfolio demonstration purposes.

---

## 📁 Repository Structure

```text
retail-sales-analytics/
├── README.md
├── website/
│   ├── index.html
│   ├── styles.css
│   ├── script.js
│   └── assets/
├── sql/
│   ├── 01_create_schema.sql
│   ├── 02_seed_demo_data.sql
│   ├── 03_transformations.sql
│   └── 04_powerbi_views.sql
├── powerbi/
│   ├── data_model.md
│   ├── dashboard_pages.md
│   └── dax_measures.md
└── docs/
    └── project_plan.md
```

---

## 🎯 Key Dashboard Modules & Features

### 1. Executive KPI Summary
- **Total Revenue & Gross Margin**: Real-time visibility into overall sales, net profit, and average profit margins.
- **Average Order Value (AOV)**: Tracks the average spend per customer transaction.
- **Sales Growth Rates**: Period-over-period performance (Day-over-Day, Month-over-Month, Year-over-Year).
- **Target vs. Actual Tracker**: Visual progress bars comparing sales targets against actual revenue.

### 2. Product & Inventory Analytics
- **Top & Bottom Performers**: Rankings for best-selling items, highest-margin products, and slow-moving inventory.
- **Sell-Through & Turnover Rates**: Metrics measuring how quickly stock is sold and replaced over a set period.
- **Stock Level Alerts**: Low-stock indicators and out-of-stock risk predictions to prevent lost sales.
- **Category Performance Breakdown**: Visual distributions of sales across categories and sub-categories.

### 3. Customer & Purchasing Insights
- **Customer Lifetime Value (LTV)**: Estimates total revenue expected from an individual customer account.
- **New vs. Returning Customer Ratio**: Tracks repeat customer rates and brand loyalty trends.
- **Basket Analysis (Cross-Selling)**: Insights into products frequently purchased together to optimize bundling.

### 4. Store & Channel Performance
- **Multi-Store / Multi-Channel Comparison**: Side-by-side analysis for physical stores versus e-commerce platforms.
- **Geographic Sales Heatmap**: Location-based analysis showing revenue density across regions or cities.
- **Peak Hour / Peak Day Analysis**: Identifies busy operational hours to optimize store staffing and promotions.

---

## 🛠️ Technology Stack Recommendations

| Layer | Recommended Technologies | Purpose & Capabilities |
| :--- | :--- | :--- |
| **Frontend** | React / Next.js + Tailwind CSS | Fast, responsive UI components with server-side rendering and utility-first styling. |
| **Data Viz** | Chart.js, Recharts, or Apache ECharts | Interactive charts, geographic heatmaps, treemaps, and real-time dashboard gauges. |
| **Backend** | Node.js (Express) or Python (FastAPI) | Efficient REST/GraphQL APIs for analytical data processing and aggregation endpoints. |
| **Database** | PostgreSQL or Snowflake | High-performance relational transactional storage & analytical cloud data warehousing. |

---

## 🚀 Quick Setup & Execution Guide

### 1. PostgreSQL Database Setup
```bash
# Create database
createdb retail_analytics_demo

# Run scripts in order
psql -d retail_analytics_demo -f sql/01_create_schema.sql
psql -d retail_analytics_demo -f sql/02_seed_demo_data.sql
psql -d retail_analytics_demo -f sql/03_transformations.sql
psql -d retail_analytics_demo -f sql/04_powerbi_views.sql
```

### 2. Power BI Connection
1. Open **Power BI Desktop**.
2. Select **Get Data → PostgreSQL database**.
3. Import the 5 reporting views:
   - `vw_powerbi_fact_sales`
   - `vw_powerbi_dim_customer`
   - `vw_powerbi_dim_product`
   - `vw_powerbi_dim_store`
   - `vw_powerbi_fact_inventory`
4. Apply the relationships documented in [`powerbi/data_model.md`](powerbi/data_model.md).
5. Load the DAX measures documented in [`powerbi/dax_measures.md`](powerbi/dax_measures.md).

### 3. Website Case Study
Simply open `website/index.html` in any web browser to explore the portfolio case study.

---

## 📊 Key Simulated Metrics

- **Total Sales**: `$4.82M` (Simulated)
- **Total Profit**: `$612K` (Simulated)
- **Profit Margin**: `12.7%` (Simulated)
- **MoM Growth**: `8.4%` (Simulated)
- **Transactions**: `50,000+` (Simulated)
