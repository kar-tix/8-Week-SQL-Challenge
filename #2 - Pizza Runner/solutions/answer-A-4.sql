-- How many of each type of pizza was delivered?
-- Ile każdego rodzaju pizzy dostało dostarczonych?

SELECT
    pizza_name,
    COUNT(customer_orders_temp.order_id) as total_delivered
FROM customer_orders_temp
INNER JOIN pizza_names
    ON pizza_names.pizza_id = customer_orders_temp.pizza_id
INNER JOIN runner_orders_temp
    ON customer_orders_temp.order_id = runner_orders_temp.order_id
WHERE cancellation IS NULL
GROUP BY pizza_name;