-- How many unique customer orders were made?
-- Ile zostało złożonych unikalnych zamówień?

SELECT
    COUNT(DISTINCT order_id) as unique_orders
FROM customer_orders_temp;