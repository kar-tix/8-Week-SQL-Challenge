-- How many pizzas were ordered?
-- Jak dużo pizz zostało zamówionych?



SELECT
    COUNT(order_id) as total_pizza
FROM customer_orders_temp;