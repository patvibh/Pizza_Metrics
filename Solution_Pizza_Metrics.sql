-- Copying table to new table
drop table if exists customer_orders1;
create table customer_orders1 as
(select order_id, customer_id, pizza_id, exclusions, extras, order_time 
from customer_orders);
-- Cleaning data
update customer_orders1
set 
exclusions = case exclusions when 'null' then null else exclusions end,
extras = case extras when 'null' then null else extras end;

-- Copying table and cleaning data
drop table if exists runner_orders1;
create table runner_orders1 as 
(select order_id, runner_id, pickup_time,
case
 when distance like '%km' then trim('km' from distance)
 else distance 
end as distance,
case
 when duration like '%minutes' then trim('minutes' from duration)
 when duration like '%mins' then trim('mins' from duration)
 when duration like '%minute' then trim('minute' from duration)
 else duration
end as duration, cancellation 
from runner_orders);
-- cleaning data
update runner_orders1
set 
pickup_time = case pickup_time when 'null' then null else pickup_time end,
distance = case distance when 'null' then null else distance end,
duration = case duration when 'null' then null else duration end,
cancellation = case cancellation when 'null' then null else cancellation end;
-- cleaning data
update runner_orders1
set 
pickup_time = case pickup_time when 'null' then null else pickup_time end,
distance = case distance when 'null' then null else distance end,
duration = case duration when 'null' then null else duration end,
cancellation = case cancellation when 'null' then null else cancellation end;

-- Q1. How many pizzas were ordered?
select count(pizza_id) as Total_Pizza_Ordered 
from customer_orders1;

-- Q2. How many unique customer orders were made?
select count(distinct order_id) as Total_Orders
from customer_orders1;

-- Q3. How many successful orders were delivered by each runner?
select runner_id, count(order_id) as Orders_Delivered
from runner_orders1
where distance is not null
group by runner_id;

-- Q4. How many of each type of pizza was delivered?
select pizza_names.pizza_name, count(customer_orders1.pizza_id) as TotalDelivered
from customer_orders1
inner join runner_orders1
on customer_orders1.order_id = runner_orders1.order_id
inner join pizza_names
on pizza_names.pizza_id = customer_orders1.pizza_id
where runner_orders1.distance is not null
group by pizza_names.pizza_name;

-- Q5. How many Vegetarian and Meatlovers were ordered by each customer?
select customer_orders1.customer_id, pizza_names.pizza_name, count(customer_orders1.pizza_id) as TotalPizzaOrdered
from customer_orders1
inner join pizza_names
on customer_orders1.pizza_id = pizza_names.pizza_id
group by customer_orders1.customer_id, pizza_names.pizza_name
order by customer_orders1.customer_id;

-- Q6. What was the maximum number of pizzas delivered in a single order?
select runner_orders1.order_id, count(customer_orders1.pizza_id) as TotalDelivered
from runner_orders1
inner join customer_orders1
on customer_orders1.order_id = runner_orders1.order_id
where runner_orders1.distance is not null
group by runner_orders1.order_id
order by Totaldelivered desc
limit 1;

-- Q7. What was the total volume of pizzas ordered for each hour of the day?
select extract(hour from order_time) as Hourlydata, count(order_id) as TotalPizzaOrdered
from customer_orders1
group by Hourlydata
order by Hourlydata;

-- Q8. What was the volume of orders for each day of the week?
SELECT TO_CHAR(order_time, 'Day') AS day_of_week, 
  COUNT(*) AS vol_per_dow
FROM customer_orders
GROUP BY day_of_week;

-- Q9. If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes — how much money has Pizza Runner made so far if there are no delivery fees?
select sum(case 
when c.pizza_id = 1 then 12
else 10
end) as TotalAmount
from runner_orders1 as r
inner join customer_orders1 as c
on c.order_id = r.order_id
where r.distance is not null;

-- Q10. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
SELECT registration_date, 
   EXTRACT(WEEK FROM registration_date) AS week_of_year
FROM runners;
