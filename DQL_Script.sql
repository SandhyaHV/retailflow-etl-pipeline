-- Sample data review

SELECT * FROM df_orders
LIMIT 50;

--Total record count

SELECT Count(1) FROM df_orders;

--Find top 10 highest grossing products

SELECT product_id, SUM(revenue) as total_revenue
FROM df_orders
GROUP BY product_id
ORDER BY total_revenue  desc
LIMIT 10;

--Find top 5 highest selling products in each region

WITH revenue_by_product AS (
    SELECT 
        region,
        product_id,
        SUM(revenue) AS total_revenue,
        ROW_NUMBER() OVER (PARTITION BY region ORDER BY SUM(revenue) DESC) AS rn
    FROM df_orders
    GROUP BY region, product_id
)
SELECT *
FROM revenue_by_product
WHERE rn <= 5;

--View monthly revenue of 2022 and 2023 side-by-side with YOY growth

WITH monthly_rev as (
	SELECT strftime('%Y', order_date) as year, 
	strftime('%m', order_date)as month, 
	SUM(revenue) as total_revenue
	FROM df_orders
	GROUP BY year, month
),

pivot as (
	SELECT month,
	SUM(CASE WHEN year='2022' THEN total_revenue ELSE 0 end) as y2022,
	SUM(CASE WHEN year='2023' THEN total_revenue ELSE 0 end) as y2023
	FROM monthly_rev
	GROUP BY month
)

SELECT * , 
ROUND(((y2023-y2022)/y2022)*100,2) as Growth
FROM pivot
ORDER by month;

--Find MoM growth of revenue for each month

WITH monthly_revenue AS (
    SELECT 
        strftime('%Y', order_date) AS year,
        strftime('%m', order_date) AS month,
        SUM(revenue) AS total_revenue
    FROM df_orders
    WHERE year IN ('2022', '2023')
    GROUP BY year, month
),
growth AS (
    SELECT 
        year,
        month,
        total_revenue,
        LAG(total_revenue) OVER (PARTITION BY year ORDER BY month) AS prev_month_revenue,
        ROUND(
            (total_revenue - LAG(total_revenue) OVER (PARTITION BY year ORDER BY month)) 
            * 100.0 / LAG(total_revenue) OVER (PARTITION BY year ORDER BY month), 
            2
        ) AS mom_growth_percent
    FROM monthly_revenue
)
SELECT * 
FROM growth
ORDER BY year, month;

--Which month had the highest profit in each category?

WITH cat_rev as (
SELECT category,strftime('%Y%m', order_date) AS year_month,
SUM(profit) as total_profit
FROM df_orders
GROUP BY category,year_month)

SELECT category, year_month, total_profit
FROM(
SELECT *,
ROW_NUMBER() OVER (PARTITION BY category ORDER BY total_profit desc) as rn
FROM cat_rev
)
where rn=1;

