
---

## 📷 Dashboard Previews

**Power BI**

| Overview | Outlet Performance |
|---|---|
| ![Overview](screenshots/powerbi_overview.png) | ![Outlet Performance](screenshots/powerbi_outlet_performance.png) |

| Product Performance | Deep Dive |
|---|---|
| ![Product Performance](screenshots/powerbi_product_performance.png) | ![Deep Dive](screenshots/powerbi_deep_dive.png) |

**Excel / Google Sheets**

![Sheets Dashboard](screenshots/sheets_dashboard.png)

---

## ▶️ How to Reproduce

**Python**
```bash
pip install pandas numpy matplotlib seaborn
python bigmart_analysis.py
# or open Python/BigMart_EDA_Cleaning.ipynb in Jupyter/Colab
```

**SQL**
1. Import `bigmart_cleaned.csv` into MySQL Workbench as a staging table via the Table Data Import Wizard.
2. Run `Sql/bigmart_sql_schema_and_queries.sql` to build the schema and run all queries.

**Power BI**
Open `Powerbi/BigMart_PowerBI_Dashboard.pbix` in Power BI Desktop. Refresh by re-pointing Power Query to `Bigmart_sales_data.csv`.

---

## 🧠 Skills Demonstrated
- Data cleaning: missing values, inconsistent categories, disguised missing values (pandas, Power Query/M, business-logic fills)
- Exploratory data analysis and correlation analysis
- Relational database design (normalization) and advanced SQL (joins, subqueries, CTEs, window functions)
- Interactive BI dashboard design (multi-page navigation, slicers, DAX, consistent theming)
- Cross-tool validation — proving identical results across four independent tools

---

## 👤 Author
Built as an end-to-end analytics portfolio project.
