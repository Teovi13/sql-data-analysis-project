# SQL Data Analysis Project

Exploratory and analytical SQL scripts (T-SQL / SQL Server) built on top of
the Gold layer of my [Data Warehouse project](https://github.com/Teovi13/sql-data-waherouse-project).
This repository focuses on turning a dimensional model into business
answers: EDA, magnitude analysis, ranking, change-over-time, cumulative and
part-to-whole analysis, segmentation, and two consolidated reporting views.

Portfolio project built as part of my path into **Data Engineering**,
covering the analytical side of the stack — the queries and views an
analyst or a BI tool would run against a warehouse that is already built.

---

## Relationship to the Data Warehouse project

**This repository is not standalone.** Every script here queries the
`gold` schema (and, in the DDL script, the `silver` schema directly), which
only exist after running the ETL pipeline in
[`sql-data-waherouse-project`](https://github.com/Teovi13/sql-data-waherouse-project).

```
sql-data-waherouse-project          sql-data-analysis-project (this repo)
┌───────────────────────┐            ┌─────────────────────────────┐
│ Bronze → Silver → Gold│  ────────► │ EDA · Analytics · Reporting  │
│ (ETL, DDL, quality)   │            │ (this repository)            │
└───────────────────────┘            └─────────────────────────────┘
```

To run anything in this repo:

1. Clone and run **`sql-data-waherouse-project`** first (its own README has
   the full setup steps) until the `silver` schema is loaded.
2. Come back here and run [`scripts/gold_DDL.sql`](scripts/gold_DDL.sql) to
   create the `gold` views (`dim_customers`, `dim_products`, `fact_sales`)
   this project's analysis depends on.
3. Run any other script in [`scripts/`](scripts/) — they only read from
   `gold`, so they can be run in any order and as many times as needed.

No datasets are duplicated in this repository — the synthetic CSV data
lives in the Data Warehouse project, as the single source of truth.

---

## Repository structure

```
sql-data-analysis-project/
│
├── scripts/
│   ├── gold_DDL.sql                     # Creates the gold schema views (star schema)
│   ├── Gold_validations.sql             # Data quality checks on the gold views
│   │
│   ├── Explore_Tables.sql               # Metadata exploration (INFORMATION_SCHEMA)
│   ├── dim_exploring.sql                # Distinct values in dimensions (countries, categories)
│   ├── date_exploration.sql             # Date boundaries and customer age range
│   │
│   ├── measure_exp.sql                  # Core business measures (totals, averages, counts)
│   ├── magnitud.sql                     # Magnitude analysis by dimension (country, gender, category)
│   ├── rank_analysis.sql                # Top-N / bottom-N ranking (TOP vs. ROW_NUMBER)
│   │
│   ├── Change_Over_Time_analysis.sql    # Monthly trends (YEAR/MONTH vs. DATETRUNC)
│   ├── cummulative_analysis.sql         # Running totals and moving averages
│   ├── part-to-whole_analysis.sql       # Category share of total sales
│   ├── data_segmentation.sql            # Product cost ranges / customer spending segments
│   ├── performance_analysis.sql         # Year-over-year and vs.-average product performance
│   │
│   ├── report_customers.sql             # gold.report_customers — consolidated customer view
│   └── report_products.sql              # gold.report_products — consolidated product view
│
├── LICENSE
└── README.md
```

---

## What this project answers

Grouped by the kind of analytical technique each script demonstrates:

**Exploration (EDA)**
- What tables/views and columns exist in the database? (`Explore_Tables.sql`)
- Which countries do customers come from? Which categories/subcategories/products exist? (`dim_exploring.sql`)
- What's the date range of the sales data? What's the age range of customers? (`date_exploration.sql`)

**Magnitude analysis**
- Total customers by country and by gender, total products by category, average cost by category, total revenue by category and by customer, distribution of items sold by country (`magnitud.sql`)

**Ranking**
- Top 5 highest-revenue and bottom 5 lowest-revenue products, solved two ways: `TOP N` vs. `ROW_NUMBER()` window function (`rank_analysis.sql`)

**Change over time**
- Monthly sales trend, computed two ways: `YEAR()`/`MONTH()` vs. `DATETRUNC()` (`Change_Over_Time_analysis.sql`)

**Cumulative analysis**
- Running total of monthly sales and moving average of monthly price, using window functions with an ordered, unbounded frame (`cummulative_analysis.sql`)

**Part-to-whole analysis**
- Each category's share of total revenue, using a window function over an already-aggregated result (`part-to-whole_analysis.sql`)

**Segmentation**
- Products grouped into cost ranges; customers grouped into VIP / Regular / New based on lifespan and spending (`data_segmentation.sql`)

**Performance analysis**
- Each product's yearly sales compared to its own historical average and to the prior year, using `AVG() OVER()` and `LAG()` (`performance_analysis.sql`)

**Consolidated reports**
- `gold.report_customers`: one row per customer with segment, age group, recency, total orders/sales/quantity, average order value, and average monthly spend.
- `gold.report_products`: one row per product with performance segment, lifespan, recency, total orders/sales/quantity/customers, average selling price, average order revenue, and average monthly revenue.

---

## Technical highlights

- **Two-CTE report pattern** in `report_customers.sql` / `report_products.sql`: raw aggregation is kept separate from business-rule logic (segmentation, KPI formulas), making each view easier to read, test, and extend.
- **Window functions used deliberately for different purposes**: ranking (`ROW_NUMBER`), running totals and moving averages (`SUM`/`AVG` with an ordered frame), part-to-whole shares (`SUM() OVER ()` on pre-aggregated data), and period-over-period comparison (`LAG`).
- **Same question, two techniques, side by side**: ranking and monthly-trend scripts intentionally show both a simpler approach (`TOP N`, `YEAR()`/`MONTH()`) and a window-function equivalent (`ROW_NUMBER()`, `DATETRUNC()`), to compare trade-offs explicitly.
- **Standalone data quality gate** (`Gold_validations.sql`): checks surrogate-key uniqueness and referential integrity between `fact_sales` and its dimensions before trusting any downstream report.
- **Metadata-driven exploration**: uses the ANSI-standard `INFORMATION_SCHEMA` views rather than SQL Server–specific system views, keeping the exploration scripts portable to other relational engines.

---

## Credits

Course material and project structure based on the SQL Server course by
**Data with Baraa**. All queries in this repository were written and
adapted by me against my own Data Warehouse project
([`sql-data-waherouse-project`](https://github.com/Teovi13/sql-data-waherouse-project)).

---

## License

This project is licensed under the [MIT License](LICENSE).
