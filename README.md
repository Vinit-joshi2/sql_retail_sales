# Retail Sales Analysis SQL Project

## Project Overview

**Project Title**: Retail Sales Analysis  

This project is designed to demonstrate SQL skills and techniques typically used by data analysts to explore, clean, and analyze retail sales data. The project involves setting up a retail sales database, performing exploratory data analysis (EDA), and answering specific business questions through SQL queries.

## Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Table Creation**: A table named `retail_sales` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql
CREATE DATABASE sql_project;

CREATE TABLE retail_Sales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);
```

### 2. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.

```sql
-- How many sales we have??
select count(*) as total_sales from retail_sales

-- How many unique customer we have??
select count(distinct(customer_id))   from retail_sales

-- How many catorgy we have?
select count(distinct(category))   from retail_sales
select distinct(category)  from retail_sales
```

## 3. Data Cleaning
```sql
select * from retail_sales
where transactions_id is null

select * from retail_sales
where sale_date is null

-- Null data in table
select * from retail_sales
where
	transactions_id is null or
	sale_date is null or
	sale_time is null or
	gender is null or
	category is null or
	quantiy is null or
	cogs is null or
	total_sale is null 
```
```sql
-- deleting Null data from table
delete from retail_sales
where
	transactions_id is null or
	sale_date is null or
	sale_time is null or
	gender is null or
	category is null or
	quantiy is null or
	cogs is null or
	total_sale is null
```


### 4. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

1. **write a sql query to retrieve all colummns for sales made on '2022-11-05'**:
```sql
select * from retail_sales
where  sale_date = '2022-11-05';
```

2. **write a sql query to retreive all transactions where categoty is 'Clothing' and the quantity sold is more than 4 in the month of nov-2022**:
```sql
select *   from retail_sales
where category = 'Clothing' and to_char(sale_date , 'YYYY-MM') = '2022-11' and quantiy >= 4

```

3. **write a sql query to calculate the total sales (total_sales) from each category.**:
```sql
select category , sum(total_sale) , count(*) as total_orders   from retail_sales
group by category
```

4. **write a sql query to find the avg age of customer who puarchased item from the 'Beauty' category.**:
```sql
select round(avg(age),2) as avg_age from retail_sales
where category = 'Beauty'
```

5. **write a sql query to find all transactions where the total_sale is greater than 1000.**:
```sql
select * from retail_sales
where total_sale > 1000
```

6. **write a sql query to find the total number of trabsaction (transaction_id) made by each gender in each category.**:
```sql
select count(*) as total_trasaction, category , gender from retail_sales
group by   category , gender
order by 1
```

7. **write a sql query to calculate the average sale for each month .Find out the best selling month in each year**:
```sql
select year , month , avg_sale from
(
select 
	Extract(YEAR from sale_date) as year,
	Extract(MONTH from sale_date) as month,
	Avg(total_sale) as avg_sale,
	RANK() over(PARTITION BY Extract(YEAR from sale_date) order by Avg(total_sale) desc) as rank
	
from retail_sales
group by 1,2

) as t1
where t1.rank = 1
```

8. **write a sql query to find the top 5 customer based on th highest total sales**:
```sql
select customer_id, sum(total_sale) from retail_sales
group by customer_id
order by 2  desc
limit 5
```

9. **write a sql query to find the number of unique customers who puchased items from each  category.**:
```sql
select count(distinct(customer_id)) as count_of_unique_customer , category from retail_sales
group by category
```

10. **write a sql query to create each shift and number of orders (Example Morning <= 12 , Afternoon between 12 & 17 , Evening > 17)**:
```sql
with hourly_sale
as
(
select * ,
	case
		when  Extract(HOUR FROM sale_time) < 12  then 'Morning'
		when  Extract(HOUR FROM sale_time) BETWEEN 12 AND 17   THEN 'Afternoon'
		else 'Evening'
	END as shift
from retail_sales
)
select 
	shift,
  	count(*) as total_orders
from hourly_sale
group by shift
```
11. **Total sales by day**:

``` sql
with day_sale
as 
(
select *,
	case extract(dow from sale_date)
		when 0 then 'Sunday'
		when 1 then 'Monday'
		when 2 then 'Tuesday'
		when 3 then 'Wednesday'
		when 4 then 'Thursday'
		when 5 then 'Friday'
		when 6 then 'Saturday'
		
	end as day_name		
from retail_sales
)
select day_name,
		 count(total_sale) as total_sales_by_day

from day_sale
group by day_name

```

## Findings

- **Customer Demographics**: The dataset includes customers from various age groups, with sales distributed across different categories such as Clothing and Beauty.
- **High-Value Transactions**: Several transactions had a total sale amount greater than 1000, indicating premium purchases.
- **Sales Trends**: Monthly analysis shows variations in sales, helping identify peak seasons.
- **Customer Insights**: The analysis identifies the top-spending customers and the most popular product categories.

## Reports

- **Sales Summary**: A detailed report summarizing total sales, customer demographics, and category performance.
- **Trend Analysis**: Insights into sales trends across different months and shifts.
- **Customer Insights**: Reports on top customers and unique customer counts per category.

## Conclusion

This project serves as a comprehensive introduction to SQL for data analysts, covering database setup, data cleaning, exploratory data analysis, and business-driven SQL queries. The findings from this project can help drive business decisions by understanding sales patterns, customer behavior, and product performance.
