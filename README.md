# walmart-sales-econ-sql-analysis
SQL project analyzing Walmart sales, holiday demand patterns, and macroeconomic conditions using store-level retail data.


# Retail Sales and Economic Conditions Analysis Using SQL

## Project Overview
This project analyzes Walmart weekly sales data using SQL to explore store performance, holiday demand patterns, and the relationship between macroeconomic conditions and retail sales.

Using SQL, I investigate how factors such as unemployment, inflation (CPI), holidays, and regional differences relate to sales performance across 45 stores.

---

## Dataset
This dataset includes:

- 45 Walmart stores  
- Weekly sales data (2010–2012)  
- Department-level sales  
- CPI and unemployment indicators  
- Fuel prices and temperature  
- Holiday flags  
- Promotional markdown variables  

---

## Business Questions Explored

### Sales Performance
- Which stores generate the highest total sales?
- Which departments perform best?
- Which stores perform above average?
- How concentrated is store performance?

### Holiday Demand Effects
- Do holiday weeks generate higher sales?
- Which stores experience the biggest holiday sales boost?
- What percentage lift do holidays generate?

### Economic Conditions
- Do high-unemployment stores have lower sales?
- How are stores distributed across unemployment groups?
- How do macroeconomic conditions relate to store performance?

### Regional Analysis
- How do sales vary across regional groupings?

---

## SQL Concepts Used
- Aggregations (`SUM`, `AVG`, `COUNT`)
- `GROUP BY` and `HAVING`
- `CASE WHEN`
- Subqueries
- JOINs
- Window Functions (`RANK`)
- `COALESCE` for null handling

---

## Key Insights
- Sales performance varies significantly across stores.
- Holidays create measurable sales boosts.
- High-unemployment stores show lower average sales.
- Sales are unevenly distributed across stores.
- Regional sales patterns vary across groups.

---

## Files
- `sql/walmart_analysis.sql` — SQL analysis queries
- `data/walmart_dataset.csv` — Dataset

---

## Example Query

```sql
SELECT
Store,
SUM(Weekly_Sales) AS total_sales,
RANK() OVER (
ORDER BY SUM(Weekly_Sales) DESC
) AS store_rank
FROM walmart_dataset
GROUP BY Store;
```

---

## Future Improvements
- Add Power BI/Tableau visualizations
- Extend economic analysis using regression in Python/R
- Explore markdown promotions and price effects further

---

## Author
Shubhi Bhardwaj  
MA Economics | SQL | Data Analysis
