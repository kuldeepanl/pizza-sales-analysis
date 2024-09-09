create database project1
use project1
---all tables
select * from order_details
select * from orders
select * from pizza_types
select * from pizzas
---Retrieve the total number of orders placed.
select COUNT(order_id) as total_order from orders


---Calculate the total revenue generated from pizza sales

select round(sum(order_details.quantity * pizzas.price),2) as total_sales 
from order_details join pizzas
on order_details.pizza_id=pizzas.pizza_id


---Identify the highest-priced pizza.

select top 1 pizzas.price,pizza_types.name
from pizzas join pizza_types 
on pizzas.pizza_type_id=pizzas.pizza_type_id 
order by pizzas.price desc 





---Identify the most common pizza size ordered.
select sum(order_details.quantity) as pizza_count,pizzas.size
from order_details 
join pizzas 
on order_details.pizza_id=pizzas.pizza_id 
group by pizzas.size 


----List the top 5 most ordered pizza types along with their quantities.

select top 5 pizza_types.name,sum(order_details.quantity) as num_pizza 
from pizza_types 
join pizzas 
on pizza_types.pizza_type_id=pizzas.pizza_type_id 
join order_details 
on pizzas.pizza_id=order_details.pizza_id
group by pizza_types.name 
order by num_pizza desc



----Join the necessary tables to find the total quantity of each pizza category ordered.

select pizza_types.category,sum(order_details.quantity)  as num_pizza
from pizza_types  
join pizzas 
on pizza_types.pizza_type_id=pizzas.pizza_type_id 
join order_details 
on pizzas.pizza_id=order_details.pizza_id 
group by pizza_types.category 
order by num_pizza desc



---Determine the distribution of orders by hour of the day.
select count(order_details.quantity) as num_order,datepart(hour,time) as hour_ 
from order_details 
join orders 
on order_details.order_id=orders.order_id 
group by datepart(hour,time) order by hour_


---Join relevant tables to find the category-wise distribution of pizzas.

select count(name) as num_type,category from pizza_types group by category



---Group the orders by date and calculate the average number of pizzas ordered per day.
select avg(num_pizza) as num_avg_pizza_perday from
(select date,sum(quantity) as num_pizza from orders 
join order_details 
on orders.order_id=order_details.order_id 
group by date
) as order_q



----Determine the top 3 most ordered pizza types based on revenue.

select top 3 pizzas.pizza_type_id,sum(order_details.quantity *pizzas.price) as total_reve_based_on_pizza
from order_details join pizzas 
on order_details.pizza_id=pizzas.pizza_id 
group by pizzas.pizza_type_id 
order by total_reve_based_on_pizza desc 



---Calculate the percentage contribution of each pizza type to total revenue.

select pizza_types.category,round((sum(order_details.quantity*pizzas.price)/817860.05)*100,2) as rev
from order_details join pizzas on order_details.pizza_id=pizzas.pizza_id 
join pizza_types 
on pizzas.pizza_type_id=pizza_types.pizza_type_id 
group by pizza_types.category




---Determine the top 3 most ordered pizza types based on revenue for each pizza category.

select top 3 category,name,revenue, rank() over(partition by category order by revenue desc) as rnk from
(select pizza_types.category, pizza_types.name,sum(order_details.quantity*pizzas.price) as revenue from pizza_types join pizzas on pizza_types.pizza_type_id=pizzas.pizza_type_id join order_details 
on pizzas.pizza_id=order_details.pizza_id group by pizza_types.category,pizza_types.name) as a

