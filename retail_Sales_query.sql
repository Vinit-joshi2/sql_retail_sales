select * from retail_sales

select count(*) from retail_Sales

-- Data Cleaning
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


-- Data Exploration


-- How many sales we have??
select count(*) as total_sales from retail_sales

-- How many unique customer we have??
select count(distinct(customer_id))   from retail_sales

-- How many catorgy we have?
select count(distinct(category))   from retail_sales
select distinct(category)  from retail_sales


-- Data analysis / business key problems & Answers

-- Q1 write a sql query to retrieve all colummns for sales made on '2022-11-05'
select * from retail_sales
where  sale_date = '2022-11-05';


-- Q2  write a sql query to retreive all transactions where categoty is 'Clothing' and the quantity sold is more than
--    4 in the month of nov-2022

select *   from retail_sales
where category = 'Clothing' and to_char(sale_date , 'YYYY-MM') = '2022-11' and quantiy >= 4


-- Q3 write a sql query to calculate the total sales (total_sales) from each category

select category , sum(total_sale) , count(*) as total_orders   from retail_sales
group by category


-- Q4  write a sql query to find the avg age of customer who puarchased item from the 'Beauty' category

select round(avg(age),2) as avg_age from retail_sales
where category = 'Beauty'

-- Q5 write a sql query to find all transactions where the total_sale is greater than 1000
select * from retail_sales
where total_sale > 1000


-- Q6 write a sql query to find the total number of trabsaction (transaction_id) made by each gender in each category

select count(*) as total_trasaction, category , gender from retail_sales
group by   category , gender
order by 1

-- Q7 write a swl query to calculate the average sale for each month .Find out the best selling month in each year
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


-- Q8 write a sql query to find the top 5 customer based on th highest total sales
select customer_id, sum(total_sale) from retail_sales
group by customer_id
order by 2  desc
limit 5


-- Q9 write a sql query to find the number of unique customers who puchased items from each  category

select count(distinct(customer_id)) as count_of_unique_customer , category from retail_sales
group by category

-- Q10 write a sql query to create each shift and number of orders (Example Morning <= 12 , Afternoon between 12 & 17
--      , Evening > 17)

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


-- --------------------------------------
-- Total sales by day

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

