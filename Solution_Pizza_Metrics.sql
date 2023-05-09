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
