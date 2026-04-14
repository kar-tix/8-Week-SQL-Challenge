-- What was the maximum number of pizzas delivered in a single order?
-- Jaka była największa liczba pizz dostarczonych w ramach jednego zamówienia?

SELECT
    c.order_id,
    COUNT(pizza_id) as pizzas
FROM customer_orders_temp as c
INNER JOIN runner_orders_temp
    ON c.order_id = runner_orders_temp.order_id
WHERE cancellation IS NULL
GROUP BY c.order_id
ORDER BY pizzas DESC LIMIT 1;