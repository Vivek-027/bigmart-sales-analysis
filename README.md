## BigMart Sales Analysis — End-to-End Data Analytics Project

An end-to-end data analytics project on the **BigMart Sales dataset**, solving the same 13 business questions and KPIs independently in **four tools** — Python, SQL, Power BI, and Excel/Google Sheets — with results cross-validated to match exactly across all of them.

---
##  Project Goal
Act as a retail analyst helping BigMart understand what drives sales performance across items and outlets, to support decisions on assortment, pricing, and store strategy.

---
## Dataset
- **Source:** BigMart Sales dataset (Kaggle)
- **Size:** 8,523 rows × 12 columns
- **Original (uncleaned):** [Dataset/Bigmart_sales_Raw_data.csv](Dataset/Bigmart_sales_Raw_data.csv)
- **Cleaned dataset:** [Dataset/bigmart_cleaned_dataset.csv](Dataset/bigmart_cleaned_dataset.csv)

---

| Column | Description |
|---|---|
| `Item_Identifier` | Unique product ID |
| `Item_Weight` | Weight of the product |
| `Item_Fat_Content` | Low Fat / Regular (originally inconsistent: `LF`, `low fat`, `reg`, etc.) |
| `Item_Visibility` | % of total display area allocated to the product in store |
| `Item_Type` | Product category (16 categories) |
| `Item_MRP` | Maximum Retail Price |
| `Outlet_Identifier` | Unique store ID |
| `Outlet_Establishment_Year` | Year the store was established |
| `Outlet_Size` | Small / Medium / High |
| `Outlet_Location_Type` | Tier 1 / Tier 2 / Tier 3 |
| `Outlet_Type` | Grocery Store / Supermarket Type1 / Type2 / Type3 |
| `Item_Outlet_Sales` | Sales of the product in that outlet (target variable) |

## Data quality issues handled during cleaning:
- Inconsistent `Item_Fat_Content` labels
- `Item_Weight` missing in ~17% of rows
- `Outlet_Size` missing in ~28% of rows
- Disguised missing values in `Item_Visibility` (literal 0s, not realistic for a stocked item)

---

## ❓ Business Questions & KPIs

**Outlet Performance**
1. Which outlet types generate the most sales?
2. Does outlet size affect sales performance?
3. Which location tier drives the most revenue?
4. Do older outlets outperform newer ones?

**Product Performance**
5. Which item types sell the most vs. least?
6. Does item visibility correlate with higher sales?
7. Does price (MRP) correlate with sales?
8. Does fat content impact sales?

**Overall KPIs & Cross-Cutting Analysis**
9. Total sales & average sales per outlet
10. Best outlet type + item type combination; top-outlet sales concentration (Pareto)
11. Average item MRP across the catalog
12. Total unique items and outlets
13. % of revenue from the top 20% of items (Pareto)

---

## 🔑 Key Results (identical across all four tools)

| Metric | Value |
|---|---|
| Total Sales | ₹18,591,125 |
| Average Sales per Outlet | ₹1,859,113 |
| Average Item MRP | ₹140.99 |
| Unique Items | 1,559 |
| Unique Outlets | 10 |
| Correlation: Visibility vs Sales | -0.134 (mild negative) |
| Correlation: MRP vs Sales | 0.568 (moderate positive) |
| Top 20% outlets' share of sales | 30.78% |
| Top 20% items' share of sales | 38.51% |

**Notable findings:**
- **Supermarket Type1** dominates total sales broadly across almost every item category, not on one standout product line.
- **Outlet age** shows no consistent trend — a sharp dip at age 15 is explained by outlet type (Grocery Store), not age itself.
- **Item visibility has a mild negative correlation with sales** — challenges the common assumption that more shelf visibility drives more sales.
- **Fat content has virtually no impact** on average sales.
- Revenue is moderately concentrated across both top outlets and top items — disproportionate, but not an extreme 80/20 split.

---

## 🛠️ Tools & What Each Contributed

| Tool | Role |
|---|---|
| **Python (pandas, matplotlib, seaborn)** | Full cleaning pipeline, EDA, all 13 Q/KPIs, 11 visualizations |
| **MySQL** | Data normalized into `items`, `outlets`, `sales` tables; all 13 Q/KPIs via joins, subqueries, CTEs, window functions |
| **Power BI** | 4-page interactive dashboard with slicers, navigation, and custom theming |
| **Excel / Google Sheets** | Pivot tables, `CORREL()`, `QUERY`/`OFFSET` Pareto formulas, and a summary dashboard sheet |

### Python
- Cleaning: standardized fat-content labels, imputed `Item_Weight` (item average) and `Outlet_Size` (outlet-type mode), corrected disguised-zero visibility (item-type average), engineered `Outlet_Age`.
- All 13 Q/KPIs via `groupby`, `.corr()`, and Pareto-style ranking.

### SQL
- Normalized schema (3NF-style): `items`, `outlets`, `sales`.
- Joins, GROUP BY, subqueries, CTEs, and `ROW_NUMBER() OVER` for Pareto queries.
- Manual Pearson correlation formula (MySQL has no built-in `CORR()`) — verified against Python's `.corr()`.

### Power BI
4-page dashboard, navy-blue theme, cross-page slicers (Outlet_Type, Outlet_Location_Type, Item_Type, Item_Fat_Content):
- **Overview** — KPI cards, sales-by-outlet-type chart, sales-share donut, top-5 item types, sales-by-tier table
- **Outlet Performance** — Q1–Q4
- **Product Performance** — Q5–Q8
- **Deep Dive** — Q10 combinations, Pareto gauges, full outlet ranking table

Data cleaned independently in Power Query (M), mirroring the Python logic.

### Excel / Google Sheets
- Pivot tables for Q1–Q5, Q8, Q10a.
- `CORREL()` for Q6–Q7, matching Python/SQL.
- `SUM`/`AVERAGE`/`COUNTUNIQUE`/`QUERY` formulas for KPIs 9, 11, 12.
- `QUERY` + `OFFSET`/`ROUNDUP` for Pareto shares (Q10b, Q13), matching SQL's window-function results.
- Dedicated `Dashboard` sheet mirroring the Power BI Overview page.

---

## 📁 Repository Structure
