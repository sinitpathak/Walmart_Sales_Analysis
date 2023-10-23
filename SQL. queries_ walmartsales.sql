 -- Create database------------------------------------------------------------
CREATE DATABASE Walmartsales;

 -- Use database---------------------------------------------------------------
 USE walmartsales;

 -- Create table----------------------------------------------------------------
 CREATE TABLE sales(
 invoice_id VARCHAR(40) NOT NULL PRIMARY KEY,
 branch VARCHAR(10) NOT NULL,
 city VARCHAR(40) NOT NULL,
 customer_type VARCHAR(40) NOT NULL,
 gender VARCHAR(40) NOT NULL,
 product_line VARCHAR(100) NOT NULL,
 unit_price DECIMAL(10,2) NOT NULL,
 quantity INT NOT NULL,
 tax_pct FLOAT(6,4) NOT NULL,
 total DECIMAL(10,4) NOT NULL,
 date DATETIME NOT NULL,
 time TIME NOT NULL,
 payment VARCHAR(20) NOT NULL,
 cogs DECIMAL(10,2) NOT NULL,
 gross_margin_pct FLOAT(15,10) NOT NULL,
 gross_income DECIMAL(15,5) NOT NULL,
 rating FLOAT(2,1) NOT NULL
 );
 
  -- Show all columns from table------------------------------------------------
 SELECT * FROM SALES;
 
 
 ---------------------------------------------------------------------------------------------------------------------------------------
 -------------------------------------------------- Engineering Feature ----------------------------------------------------------------

SELECT
	time,
	(CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END) AS time_of_day
FROM sales;
select * from sales;
-- Added new column(time_of_day) in sales table--------------------------------------
ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);


-- Insert data in day_of_day column---------------------------------------------------
UPDATE sales
SET time_of_day = (
	CASE 
        WHEN 'time' BETWEEN '00:00:00' AND '12:00:00' THEN 'morning'
        WHEN 'time' BETWEEN '12:01:00' AND '16:00:00' THEN 'afternoon'
        ELSE 'evening' 
        END);

-- Added new column(day_name) in table--------------------------------------------------
 ALTER TABLE sales ADD COLUMN day_name VARCHAR(20);
 
 UPDATE sales
 SET day_name = DAYNAME(date);
 
 -- Added new column(month_name) in table------------------------------------------------
ALTER TABLE SALES ADD COLUMN month_name VARCHAR(15);

UPDATE SALES
SET month_name = monthname(date);


-- ----------------------------------------------------------------------------------------------------------------------------------
-- ------------------------------- GENERIC ------------------------------------------------------------------------------------------
-- How many unique cities does the data have?
SELECT 
	distinct CITY
FROM SALES;
 
-- In which city is each branch?
SELECT
	DISTINCT city, branch
FROM sales;

-- -----------------------------------------------------------------------------------------------------------------------------------
-- ---------------------------------------------------- PRODUCTS ---------------------------------------------------------------------

-- How many unique product lines does the data have?
SELECT 
	COUNT(DISTINCT product_line)
FROM sales;


-- What is the most common payment method?
SELECT payment_method,
	COUNT(payment_method) AS count
FROM sales
GROUP BY payment_method
ORDER BY count DESC;

-- What is the most selling product line?
SELECT product_line,
	COUNT(product_line) AS count
FROM sales
GROUP BY product_line
ORDER BY count DESC;

-- What is the total revenue by month?
SELECT month_name AS month,
	SUM(total) AS total_revenue
FROM sales
GROUP BY month_name
ORDER BY total_revenue;

-- What month had the largest COGS?
SELECT month_name AS month,
	SUM(cogs) AS cogs
FROM sales
GROUP BY month_name
ORDER BY cogs DESC;

-- What product line had the largest revenue?
SELECT product_line,
	 SUM(total) AS total_revenue
FROM sales
GROUP BY product_line
ORDER BY total_revenue DESC;

-- What is the city with the largest revenue?
SELECT city, branch,
	SUM(total) AS largest_revenue
FROM sales
GROUP BY city, branch
ORDER BY largest_revenue DESC;

-- What product line had the largest VAT?
SELECT product_line,
	AVG(tax_pct) AS avg_tax
FROM sales
GROUP BY product_line
ORDER BY avg_tax  DESC;

-- Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales
SELECT 
	AVG(quantity) AS avg_qnty
FROM sales;

SELECT
	product_line,
	CASE
		WHEN AVG(quantity) > 6 THEN "Good"
        ELSE "Bad"
    END AS remark
FROM sales
GROUP BY product_line;


-- Which branch sold more products than average product sold?
SELECT branch,
	SUM(quantity) AS qty
FROM sales
GROUP BY branch
HAVING SUM(quantity) > (SELECT AVG(quantity) FROM sales);

-- What is the most common product line by gender?
SELECT
	gender,
    product_line,
    COUNT(gender) AS total_cnt
FROM saleS
GROUP BY gender, product_line
ORDER BY total_cnt DESC;

-- What is the average rating of each product line?
SELECT 
	ROUND(AVG(rating), 2) AS avg_rating,
	product_line
FROM sales
GROUP BY product_line
ORDER BY avg_rating;


-- --------------------------------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------- SALES ------------------------------------------------------

-- Number of sales made in each time of the day per weekday
SELECT
	time_of_day,
    COUNT(*) AS total_sales
FROM sales
WHERE day_name = 'SUNDAY'
GROUP BY time_of_day
ORDER BY total_sales DESC;

-- Which of the customer types brings the most revenue?
SELECT
	customer_type,
    SUM(total) AS total_revenue
FROM sales
GROUP BY customer_type
ORDER BY total_revenue DESC;

-- Which city has the largest tax percent/ VAT (Value Added Tax)?
SELECT
	city,
    AVG(TAX_PCT) AS largest_vat
FROM sales
GROUP BY city
ORDER BY largest_vat DESC;
 
 -- Which customer type pays the most in VAT?
 SELECT
	customer_type,
    AVG(TAX_PCT) AS largest_vat
FROM sales
GROUP BY customer_type
ORDER BY largest_vat DESC;
 
 
 -- -------------------------------------------------------------------------------------------------------------------------------
 -- -------------------------------------------- CUSTOMER -------------------------------------------------------------------------
 -- How many unique customer types does the data have?
 SELECT
	DISTINCT customer_type
FROM sales;

-- How many unique payment methods does the data have?
 SELECT
	DISTINCT payment
FROM sales;

-- What is the most common customer type?
SELECT
	customer_type,
	count(*) as count
FROM sales
GROUP BY customer_type
ORDER BY count DESC;

-- Which customer type buys the most?
SELECT
	customer_type,
    COUNT(*) AS customer_count
FROM sales
GROUP BY customer_type;

-- What is the gender of most of the customers?
SELECT
	gender,
    COUNT(*) AS gender_cnt
FROM sales
GROUP BY gender;

-- What is the gender distribution per branch?
SELECT
	gender,
    COUNT(*) AS gender_cnt
FROM sales
WHERE branch = 'C'
GROUP BY gender;

-- Which time of the day do customers give most ratings?
SELECT 
	time_of_day,
    AVG(rating) AS avg_rating
FROM sales
GROUP BY time_of_day
ORDER BY avg_rating;

-- Which time of the day do customers give most ratings per branch?
SELECT 
	time_of_day,
    ROUND(AVG(rating), 2) AS avg_rating
FROM sales
WHERE branch = 'C'
GROUP BY time_of_day
ORDER BY avg_rating;

-- Which day fo the week has the best avg ratings?
SELECT
	day_name,
    AVG(rating) AS avg_count
FROM sales
GROUP BY day_name
ORDER BY avg_count DESC;

-- Which day of the week has the best average ratings per branch?
SELECT
	day_name,
    AVG(rating) AS avg_count
FROM sales
WHERE branch = 'A'
GROUP BY day_name
ORDER BY avg_count DESC;

 
 