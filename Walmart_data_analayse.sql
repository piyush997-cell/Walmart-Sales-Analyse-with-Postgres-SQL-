select * from sales

-- ADD COLUMN 
ALTER TABLE sales
ADD COLUMN time_of_day VARCHAR(20);

-- UPDATE 'time_of_day'
UPDATE sales
SET time_of_day = 
	CASE 
		WHEN time >= '06:00:00' AND time < '12:00:00' THEN 'Morning'
		WHEN time >= '12:00:00' AND time < '18:00:00' THEN 'Afternoon'
		WHEN time >= '18:00:00' AND time < '23:59:00' THEN 'Evening'
		ELSE 'Night'
	END;
-- EXTRACT A DAY NAME 
ALTER TABLE sales
ADD COLUMN day_name VARCHAR(50);

UPDATE sales
SET day_name = TO_CHAR(date, 'Dy');

-- EXTRACT A MONTH NAME 

ALTER TABLE sales
ADD COLUMN month_name VARCHAR(20);

UPDATE sales
SET month_name = TO_CHAR(date, 'Mon')

-- Q.1 How Many Unique Cities does the data have?

		SELECT DISTINCT city
		FROM sales

-- Q.2 In Which City is Branch 

	SELECT branch, city
	FROM sales
	GROUP BY branch, city
	ORDER BY branch 

-- Q.3 How Many Unique product lines does the data have?

	SELECT DISTINCT product_line
	FROM sales

-- Q.4 What is the most common payment method?

	SELECT payment, COUNT(*) AS count
	FROM sales
	GROUP BY payment
	ORDER BY count DESC
	LIMIT 1;

-- Q.5 What is the most selling product line?

	SELECT product_line, SUM(quantity) AS total_qty
	FROM sales 
	GROUP BY product_line
	ORDER BY total_qty DESC 
	LIMIT 1;

-- Q.6 What is the total revenue by month?

	SELECT month_name, ROUND(SUM(total),2) AS revenue
	FROM sales
	GROUP BY month_name
	ORDER BY revenue DESC

-- Q.7 What month had the largest COGS?

	SELECT month_name, SUM(COGS) AS total_COGS
	FROM sales
	GROUP BY month_name 
	ORDER BY total_COGS DESC;

-- Q.8 What product line had the largest revenue?

	SELECT product_line, SUM(total) AS total_revenue 
	FROM sales
	GROUP BY product_line
	ORDER BY total_revenue DESC
	LIMIT 1;

-- Q.9 What is the city with the largest revenue?

	SELECT city, SUM(total) AS total_revenue
	FROM sales
	GROUP BY city
	ORDER BY total_revenue DESC
	LIMIT 1;

-- Q.9 What product line had the largest VAT?

	SELECT product_line, ROUND(SUM(total * tax_pct / 100),2) AS total_vat
	FROM sales
	GROUP BY product_line
	ORDER BY total_vat DESC
	LIMIT 1;

-- Q.10 Fetch each product line and add a column to those product 
-- line showing "Good", "Bad". Good if its greater than average sales


WITH average_sales AS (
SELECT AVG(total_sales) AS avg_sales 
	FROM (
	SELECT product_line, SUM(total) AS total_sales
	FROM sales
	GROUP BY product_line
	) subquery
),
	
product_line_sales AS (
	SELECT product_line, SUM(total) AS total_sales
	FROM sales
	GROUP BY product_line
	)
	
SELECT 
	p.product_line,
	CASE
		WHEN p.total_sales > a.avg_sales THEN 'Good'
		ELSE 'Bad'
	END AS perfomance 
FROM product_line_sales p, average_sales a;

-- Q.11 Which branch sold more products than average product sold?

WITH average_sales AS (
SELECT AVG(total_quantity) AS avg_quantity
	FROM (
	SELECT branch, SUM(quantity) AS total_quantity  
	FROM sales 
	GROUP BY branch
	) subquery 
),
	branch_sales AS (
	SELECT branch, SUM(quantity) AS total_quantity
	FROM sales 
	GROUP BY branch
)
SELECT 
	b.branch
FROM branch_sales b, average_sales a
WHERE b.total_quantity > a.avg_quantity;

-- Q.12 What is the most common product line by gender?

WITH ranked_product_lines AS (
SELECT gender, product_line, COUNT(*) AS product_line_count,
ROW_NUMBER() OVER(PARTITION BY gender ORDER BY COUNT(*) DESC) AS rank
FROM sales
GROUP BY gender, product_line
)
SELECT gender, product_line, product_line_count
FROM ranked_product_lines
WHERE rank = 1;

-- Q.13 What is the average rating of each product line?

SELECT product_line,
	AVG(rating) AS avg_rating
	FROM sales
	GROUP BY product_line

-- Q.14 Number of sales made in each time of the day per weekday ?

SELECT 
		time_of_day,
		COUNT(*) AS total_sales
FROM sales
WHERE day_name = 'Sun'
GROUP BY time_of_day
ORDER BY total_sales DESC

-- Q.15 Which of the customer types brings the most revenue?

	SELECT customer_type,
	ROUND(SUM(total),2) AS revenue
	FROM sales
	GROUP BY customer_type
	ORDER BY revenue DESC;

--Q.16 Which city has the largest tax percent/ VAT (Value Added Tax)?

SELECT city, ROUND(AVG(tax_pct),2) AS avg_tax_pct
from sales
GROUP BY city
ORDER BY avg_tax_pct DESC;

-- Q.17 Which customer type pays the most in VAT?

	SELECT customer_type, ROUND( AVG(tax_pct),2) AS avg_tax_pct
	FROM sales
	GROUP BY customer_type
	ORDER BY avg_tax_pct DESC;

-- Q.18 How many unique customer types does the data have?

	SELECT 
		DISTINCT customer_type 
	FROM sales

-- Q.19 How many unique payment methods does the data have?

	SELECT 
		DISTINCT payment
	FROM sales

-- Q.20 What is the most common customer type?

	SELECT customer_type, 
	ROUND(SUM(total),2) as revenue
	FROM sales
	GROUP BY customer_type
	ORDER BY revenue DESC
	Limit 1;

--Q.21  Which customer type buys the most?
	
	SELECT customer_type, 
	ROUND(SUM(total),2) AS revenue
	FROM sales
	GROUP BY customer_type
	ORDER BY revenue DESC;

-- Q.22 What is the gender of most of the customers?

	SELECT gender, COUNT(*) AS gender_cnt
	FROM sales
	GROUP BY gender
	ORDER BY gender_cnt DESC;

-- Q.23 What is the gender distribution per branch?

	SELECT  branch, gender, 
	COUNT(*) AS gender_cnt
	FROM sales
	GROUP bY branch, gender
	ORDER bY gender_cnt DESC;

-- Q.24 Which time of the day do customers give most ratings?

	SELECT time_of_day, COUNT(*) AS rating_count
	FROM sales
	GROUP bY time_of_day
	ORDER bY rating_count DESC;

-- Q.25 Which day of the week has the best avg ratings?

	SELECT day_name, ROUND(AVG(rating),2) AS avg_rating
	FROM sales
	GROUP bY day_name 
	ORDER bY avg_rating DESC;

-- Q.26 Which day of the week has the best average ratings per branch?

        SELECT 
        	day_name,
        	COUNT(day_name) total_sales
        FROM sales
        WHERE branch = 'C'
        GROUP BY day_name
        ORDER BY total_sales DESC;









	
	






