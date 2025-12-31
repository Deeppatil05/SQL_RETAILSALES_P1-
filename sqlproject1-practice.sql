-- SQL RETAIL SALES ANALYSIS---

--CREATE TABLE--
drop table if exists retail_sales
create table retail_sales
         (
           transactions_id int primary key ,	
           sale_date date,
           sale_time time,
           customer_id int,
           gender varchar(15),
           age int, 
           category varchar(15),
           quantiy int,
           price_per_unit float,
           cogs float,
           total_sale float  

         );

 select * from retail_sales
 limit 10;

 select count(*) from retail_sales

 
--- DATA CLEANING---

 select * from retail_sales
 where
     transactions_id is null
	 or
	 sale_date is null
	 or
	 sale_time is null
	 or 
	 customer_id is null
	 or
	 gender is null
	 or
	 age is null
	 or
	 category is null
	 or 
	 quantiy is null
	 or
	 total_sale is null
	 limit 5;

delete from retail_sales
 where
     transactions_id is null
	 or
	 sale_date is null
	 or
	 sale_time is null
	 or 
	 customer_id is null
	 or
	 gender is null
	 or
	 age is null
	 or
	 category is null
	 or 
	 quantiy is null
	 or
	 total_sale is null;

	 
  --DATA EXPLORATION---

  
select count(*) total_sale from retail_sales

select count ( distinct customer_id)  from retail_sales
	 
select count(distinct category) from retail_sales


           --DATA ANALYSIS----

-- Que 1.write query to describe all columns for sales made on 2022-11-05

select * from retail_sales
 where sale_date = '2022-11-05';

 --QUE 2. Show all transaction where category = clothing and quantity > than 4 in month of november 2022

 select * from retail_sales
 where 
     category = 'Clothing'
	 and
	 quantiy < 4
	 and
	 TO_CHAR (sale_date, 'yyyy-mm')= '2022-11';


 --Que 3. calculate total sales (total sale) for each category

 select 
    category, sum(total_sale) as total_sale
	from retail_sales
	group by category;

--Que 4. Find the avg age of customers who purchased items from beauty category

--(round--used when we want round of numbers to avoid large return)
select 
  round(avg(age),2) as average_age
   from retail_sales 
     where 
	  lower (category) = 'beauty';

--QUE 5. fIND all transaction where total sales < 1000

select * from retail_sales 
where total_sale > 1000
limit 10;

--Que 6.  Find total no.of transaction (transaction_id) made by each gender in each category

select category , gender,
  count(*) as total_transaction
   from retail_sales
    group by category,gender;

--Que 7. find avg sale for each month and find best selling month in each year
select 
 year, month, avg_sales
 from 
(
 select 
    extract (year from sale_date) as Year,
	extract (month from sale_date)as month,
	avg(total_sale) as avg_sales,
	rank() over(partition by extract (year from sale_date) order by avg(total_sale)desc) as rank 
	from retail_sales
	group by
	  year,month 
 )as t1 
   where rank = 1


--Que 8. Find top 5 customers based on highest total sales
select customer_id , sum(total_sale) as total_sales
from retail_sales
group by customer_id
order by 2 desc
limit 5;

--Que 9. Find the no. of unique customers who purchased items from each category

select 
  count(distinct customer_id),
  category
   from retail_sales
   group by category;

 --Que 10. Write sql query to create each shift and number of orders (example: Morning <=12 , afternoon between 12 and 17 , evening >17)

 with hourly_sales
 as
 (
  select * ,
    case   
	 when extract(hour from sale_time) < 12 then 'Morning'
	 when extract(hour from sale_time) between 12 and 17 then 'Afternoon'
	 else 'Evening'
	end as shift 
  from retail_sales
  )
select 
  shift,
  count(*) as total_sales
  from hourly_sales
  group by shift

--same without cte--
  select 
    case   
	 when extract(hour from sale_time) < 12 then 'Morning'
	 when extract(hour from sale_time) between 12 and 17 then 'Afternoon'
	 else 'Evening'
	end as shift,
	count(transactions_id) as no_fo_orders
  from retail_sales
  group by shift;


 
