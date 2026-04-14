-- How many Vegetarian and Meatlovers were ordered by each customer?
-- Ile Vegetarian i Meatlovers zostało zamówionych przez każdego klienta?

SELECT
    customer_id,
    pizza_name,
    COUNT(order_id) as total_ordered
FROM pizza_names
INNER JOIN customer_orders_temp
    ON pizza_names.pizza_id = customer_orders_temp.pizza_id
GROUP BY customer_id, pizza_name
ORDER BY customer_id, pizza_name;