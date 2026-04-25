-- Counting total rows
SELECT COUNT(*) AS total_rows
FROM walmart_dataset;



-- Counting distinct stores and departments
SELECT 
COUNT(DISTINCT Store) AS total_stores,
COUNT(DISTINCT Dept) AS total_departments
FROM walmart_dataset;

--- Cleaning markdown nulls
SELECT
Store,
Dept,
Date,
Weekly_Sales,
IsHoliday,
Temperature,
Fuel_Price,
COALESCE(MarkDown1, 0) AS MarkDown1,
COALESCE(MarkDown2, 0) AS MarkDown2,
COALESCE(MarkDown3, 0) AS MarkDown3,
COALESCE(MarkDown4, 0) AS MarkDown4,
COALESCE(MarkDown5, 0) AS MarkDown5,
CPI,
Unemployment
FROM walmart_dataset;



---- Total sales by store
SELECT 
Store,
SUM(Weekly_Sales) AS total_sales
FROM walmart_dataset
GROUP BY Store
ORDER BY total_sales DESC;

-- Total sales by department
SELECT 
Dept,
SUM(Weekly_Sales) AS total_sales
FROM walmart_dataset
GROUP BY Dept
ORDER BY total_sales DESC;


--Highest average sales date
SELECT TOP 1
Date,
AVG(Weekly_Sales) AS avg_sales
FROM walmart_dataset
GROUP BY Date
ORDER BY avg_sales DESC;

--Creating new lookup table - containg the store region information
SELECT DISTINCT
Store,
CASE
 WHEN Store BETWEEN 1 AND 11 THEN 'North'
 WHEN Store BETWEEN 12 AND 22 THEN 'South'
 WHEN Store BETWEEN 23 AND 33 THEN 'East'
 ELSE 'West'
END AS Region
INTO Store_Info
FROM walmart_dataset;

--Checking the lookup table
SELECT *
FROM Store_Info;

SELECT Region, COUNT(*) AS stores_in_region
FROM Store_Info
GROUP BY Region;

-- joining the region table with store 
SELECT 
w.Store,
s.Region,
SUM(w.Weekly_Sales) AS total_sales
FROM walmart_dataset w
JOIN Store_Info s
ON w.Store = s.Store
GROUP BY w.Store, s.Region
ORDER BY total_sales DESC;


-- Holiday vs non-holidy salesn - Do holiday weeks perform better than non‑holiday weeks?
SELECT 
IsHoliday,
AVG(Weekly_Sales) AS avg_sales
FROM walmart_dataset
GROUP BY IsHoliday
HAVING AVG(Weekly_Sales) > 0;


--Which stores perform ABOVE the average store.
SELECT Store, SUM(Weekly_Sales) AS store_sales
FROM walmart_dataset
GROUP BY Store
HAVING SUM(Weekly_Sales) >
(
SELECT AVG(total_sales)
FROM (
SELECT SUM(Weekly_Sales) AS total_sales
FROM walmart_dataset
GROUP BY Store
) AS store_totals
);


--For each department, do holiday weeks have higher or lower average sales than non‑holiday weeks?
SELECT 
Dept,
IsHoliday,
AVG(Weekly_Sales) AS avg_sales
FROM walmart_dataset
GROUP BY Dept, IsHoliday
ORDER BY Dept, IsHoliday;

--Which store see the biggest holiday sales?
SELECT *
FROM (
SELECT 
Store,
IsHoliday,
AVG(Weekly_Sales) AS avg_sales
FROM walmart_dataset
GROUP BY Store, IsHoliday
) t
ORDER BY avg_sales DESC;

-- How much sales increase during holidays compared to normal weeks? (sales boost)
SELECT
Store,
AVG(CASE WHEN IsHoliday = 1 THEN Weekly_Sales END) -
AVG(CASE WHEN IsHoliday = 0 THEN Weekly_Sales END) AS holiday_boost
FROM walmart_dataset
GROUP BY Store
ORDER BY holiday_boost DESC;

-- Holiday boost in percentage
SELECT
Store,
AVG(CASE WHEN IsHoliday=1 THEN Weekly_Sales END) -
AVG(CASE WHEN IsHoliday=0 THEN Weekly_Sales END) AS holiday_boost,

100.0 *
(
AVG(CASE WHEN IsHoliday=1 THEN Weekly_Sales END) -
AVG(CASE WHEN IsHoliday=0 THEN Weekly_Sales END)
)
/AVG(CASE WHEN IsHoliday=0 THEN Weekly_Sales END) AS pct_boost
FROM walmart_dataset
GROUP BY Store
ORDER BY pct_boost DESC;

-- Store ranks based on total sales.
SELECT
Store,
SUM(Weekly_Sales) AS total_sales,
RANK() OVER (
ORDER BY SUM(Weekly_Sales) DESC
) store_rank
FROM walmart_dataset
GROUP BY Store;



-- ECONOMIC CONDITIONS ANALYSIS
--Analyze economic conditions across stores using average CPI and unemployment
-- Query 1 - Store-level sales performance and macroeconomic conditions
SELECT
Store,
ROUND(SUM(Weekly_Sales), 2) AS total_sales,
ROUND(AVG(CPI), 2) AS avg_cpi,
ROUND(AVG(Unemployment), 2) avg_unemp
FROM walmart_dataset
GROUP BY Store
ORDER BY avg_unemp DESC

-- Query 2 - looking at the unemployment
SELECT
CASE
WHEN AVG(Unemployment) > 10 THEN 'High'
WHEN AVG(Unemployment) > 7 THEN 'Medium'
ELSE 'Low'
END AS unemployment_level,
ROUND(SUM(Weekly_Sales), 2) AS total_sales
FROM walmart_dataset
GROUP BY Store


-- Query 3 -- Looking into how many stores fall into high, medium, and low unemployment groups?
SELECT
unemployment_level,
COUNT(*) Number_of_stores
FROM (
SELECT Store,
CASE
WHEN AVG(Unemployment) > 10 THEN 'High'
WHEN AVG(Unemployment) > 7 THEN 'Medium'
ELSE 'Low'
END AS unemployment_level
FROM walmart_dataset
GROUP BY Store
) t
GROUP BY unemployment_level
ORDER BY Number_of_stores


-- Sales of high unemplymnet stores? - high or low
SELECT
unemployment_level,
ROUND(AVG(store_sales),2) AS avg_store_sales
FROM
(
SELECT
Store,
CASE
WHEN AVG(Unemployment) > 10 THEN 'High'
WHEN AVG(Unemployment) > 7 THEN 'Medium'
ELSE 'Low'
END AS unemployment_level,

SUM(Weekly_Sales) AS store_sales

FROM walmart_dataset
GROUP BY Store
) stores_total

GROUP BY unemployment_level
ORDER BY avg_store_sales DESC;

