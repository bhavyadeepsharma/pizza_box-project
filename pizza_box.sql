CREATE DATABASE pizza_box;
USE pizza_box;

CREATE TABLE orders(
order_id INT NOT NULL PRIMARY KEY,
order_date DATE NOT NULL,
order_time TIME NOT NULL
);
show tables;


-- Retrieve the total number of orders placed.

SELECT 
    COUNT(order_id) Total_orders
FROM
    orders;
    
-- Calculate the total revenue generated from pizza sales.

SELECT 
    ROUND(SUM(od.quantity * p.price), 2) Total_Sales
FROM
    order_details od
        JOIN
    pizzas p ON od.pizza_id = p.pizza_id;
    
-- Identify the highest-priced pizza.

SELECT 
    pt.name, p.price
FROM
    pizzas p
        JOIN
    pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
ORDER BY p.price DESC
LIMIT 1;

-- Identify the most common pizza size ordered.

SELECT 
    p.size, COUNT(od.order_details_id) order_count
FROM
    pizzas p
        JOIN
    order_details od ON p.pizza_id = od.pizza_id
GROUP BY p.size
ORDER BY order_count DESC;

-- List the top 5 most ordered pizza types along with their quantities.
SELECT 
    pt.name, SUM(od.quantity) Quantity
FROM
    pizza_types pt
        JOIN
    pizzas p ON pt.pizza_type_id = p.pizza_type_id
        JOIN
    order_details od ON od.pizza_id = p.pizza_id
GROUP BY pt.name
ORDER BY Quantity DESC
LIMIT 5;

-- Join the necessary tables to find the total quantity of each pizza Category ordered.

SELECT 
    pt.category, SUM(od.quantity) Quantity_ordered
FROM
    order_details od
        JOIN
    pizzas p ON od.pizza_id = p.pizza_id
        JOIN
    pizza_types pt ON pt.pizza_type_id = p.pizza_type_id
GROUP BY pt.category
ORDER BY Quantity_ordered DESC;

-- Determine the distribution of orders by hour of the day.
SELECT 
    HOUR(order_time) hour, COUNT(order_id) order_count
FROM
    orders
GROUP BY hour;

-- Join relevant tables to find the category wise distribution of pizzas.
SELECT 
    category, COUNT(name) count_name
FROM
    pizza_types
GROUP BY category;

-- Group the orders by date and calculate the average number of pizzas ordered per day.


SELECT 
    ROUND(AVG(quantity), 0) as Avg_pizza_ordered_per_day
FROM
    (SELECT 
        orders.order_date, SUM(order_details.quantity) AS quantity
    FROM
        orders
    JOIN order_details ON orders.order_id = order_details.order_id
    GROUP BY orders.order_date) AS order_quantity;
    
-- Determine the top 3 most ordered pizza types based on revenue.

SELECT 
    pt.name, SUM(od.quantity * p.price) revenue
FROM
    order_details od
        JOIN
    pizzas p ON p.pizza_id = od.pizza_id
        JOIN
    pizza_types pt ON pt.pizza_type_id = p.pizza_type_id
GROUP BY pt.name
ORDER BY revenue DESC
LIMIT 3;