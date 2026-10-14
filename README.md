# SQL Data Analysis Project

Exploratory and analytical SQL scripts (T-SQL / SQL Server) built on top of
the Gold layer of my [Data Warehouse project](https://github.com/Teovi13/sql-data-warehouse-project).
This repository focuses on turning a dimensional model into business
answers: EDA, magnitude analysis, ranking, change-over-time, cumulative and
part-to-whole analysis, segmentation, and two consolidated reporting views.

Portfolio project built as part of my path into **Data Engineering**,
covering the analytical side of the stack — the queries and views an
analyst or a BI tool would run against a warehouse that is already built.

---

## Relationship to the Data Warehouse project

**This repository is not standalone.** Every script here queries the
`gold` schema, which only exists after running the ETL pipeline in
[`sql-data-warehouse-project`](https://github.com/Teovi13/sql-data-warehouse-project).

```
sql-data-warehouse-project          sql-data-analysis-project (this repo)
┌───────────────────────┐            ┌─────────────────────────────┐
│ Bronze → Silver → Gold│  ────────► │ EDA · Analytics · Reporting  │
│ (ETL, DDL, quality)   │            │ (this repository)            │
└───────────────────────┘            └─────────────────────────────┘
```

To run anything in this repo:

1. Clone and run **`sql-data-warehouse-project`** first (its own README has
   the full setup steps), including `scripts/gold/ddl_gold.sql`, which
   creates the `gold` views (`dim_customers`, `dim_products`,
   `fact_sales`) that every script here reads. Run the quality checks in
   its `tests/quality_checks_gold.sql` before trusting any result.
2. Run any script in [`scripts/`](scripts/). The numbers show the order in
   which the analysis builds up, but the scripts are independent: they can
   be run in any order and as many times as needed. Most of them only
   read from `gold`; `12_report_customers.sql` and
   `13_report_products.sql` create the views `gold.report_customers` and
   `gold.report_products` (with `CREATE OR ALTER`, so running them again
   is safe).

Requirements: SQL Server 2022 or later (the scripts that use `DATETRUNC`
need it) and a database named `DataWarehouse`: every script starts with
`USE DataWarehouse;`.

No datasets are duplicated in this repository — the synthetic CSV data
lives in the Data Warehouse project, as the single source of truth.

---

## Repository structure

```
sql-data-analysis-project/
│
├── scripts/
│   ├── 01_explore_tables.sql            # Metadata exploration (INFORMATION_SCHEMA)
│   ├── 02_dimensions_exploration.sql    # Distinct values in dimensions (countries, categories)
│   ├── 03_date_exploration.sql          # Date boundaries and customer age range
│   │
│   ├── 04_measures_exploration.sql      # Core business measures (totals, averages, counts)
│   ├── 05_magnitude_analysis.sql        # Magnitude analysis by dimension (country, gender, category)
│   ├── 06_ranking_analysis.sql          # Top-N / bottom-N ranking (TOP vs. ROW_NUMBER)
│   │
│   ├── 07_change_over_time_analysis.sql # Monthly trends (YEAR/MONTH vs. DATETRUNC)
│   ├── 08_cumulative_analysis.sql       # Running totals and running averages
│   ├── 09_part_to_whole_analysis.sql    # Category share of total sales
│   ├── 10_data_segmentation.sql         # Product cost ranges / customer spending segments
│   ├── 11_performance_analysis.sql      # Year-over-year and vs.-average product performance
│   │
│   ├── 12_report_customers.sql          # gold.report_customers — consolidated customer view
│   └── 13_report_products.sql           # gold.report_products — consolidated product view
│
├── .gitignore
├── LICENSE
└── README.md
```

---

## What this project answers

Grouped by the kind of analytical technique each script demonstrates:

**Exploration (EDA)**
- What tables/views and columns exist in the database? (`01_explore_tables.sql`)
- Which countries do customers come from? Which categories/subcategories/products exist? (`02_dimensions_exploration.sql`)
- What's the date range of the sales data? What's the age range of customers? (`03_date_exploration.sql`)

**Magnitude analysis**
- Total customers by country and by gender, total products by category, average cost by category, total revenue by category and by customer, distribution of items sold by country (`05_magnitude_analysis.sql`)

**Ranking**
- Top 5 highest-revenue and bottom 5 lowest-revenue products, solved two ways: `TOP N` vs. `ROW_NUMBER()` window function (`06_ranking_analysis.sql`)

**Change over time**
- Monthly sales trend, computed two ways: `YEAR()`/`MONTH()` vs. `DATETRUNC()` (`07_change_over_time_analysis.sql`)

**Cumulative analysis**
- Running total of monthly sales and running (cumulative) average of monthly price, using window functions with an ordered, unbounded frame (`08_cumulative_analysis.sql`)

**Part-to-whole analysis**
- Each category's share of total revenue, using a window function over an already-aggregated result (`09_part_to_whole_analysis.sql`)

**Segmentation**
- Products grouped into cost ranges; customers grouped into VIP / Regular / New based on lifespan and spending (`10_data_segmentation.sql`)

**Performance analysis**
- Each product's yearly sales compared to its own historical average and to the prior year, using `AVG() OVER()` and `LAG()` (`11_performance_analysis.sql`)

**Consolidated reports**
- `gold.report_customers`: one row per customer with segment, age group, recency, total orders/sales/quantity, average order value, and average monthly spend.
- `gold.report_products`: one row per product with performance segment, lifespan, recency, total orders/sales/quantity/customers, average selling price, average order revenue, and average monthly revenue.

Age and recency are measured at the latest order in the data (November 2024),
not at today's date, so the reports and `03_date_exploration.sql` give the
same result on any day they are run.

---

## Technical highlights

- **Layered CTE report pattern** in `12_report_customers.sql` / `13_report_products.sql`: raw aggregation is kept separate from business-rule logic (segmentation, KPI formulas), making each view easier to read, test, and extend.
- **Window functions used deliberately for different purposes**: ranking (`ROW_NUMBER`), running totals and running averages (`SUM`/`AVG` with an ordered frame), part-to-whole shares (`SUM() OVER ()` on pre-aggregated data), and period-over-period comparison (`LAG`).
- **Same question, two techniques, side by side**: ranking and monthly-trend scripts intentionally show both a simpler approach (`TOP N`, `YEAR()`/`MONTH()`) and a window-function equivalent (`ROW_NUMBER()`, `DATETRUNC()`), to compare trade-offs explicitly.
- **Reproducible results**: the reports take "now" from the data itself (`MAX(order_date)` in a `reference_date` CTE) instead of `GETDATE()`, so ages and recency do not drift as the calendar moves.
- **Metadata-driven exploration**: uses the ANSI-standard `INFORMATION_SCHEMA` views rather than SQL Server–specific system views, keeping the exploration scripts portable to other relational engines.

---

## Credits

Course material and project structure based on the SQL Server course by
**Data with Baraa**. All queries in this repository were written and
adapted by me against my own Data Warehouse project
([`sql-data-warehouse-project`](https://github.com/Teovi13/sql-data-warehouse-project)).

---

## License

This project is licensed under the [MIT License](LICENSE).
