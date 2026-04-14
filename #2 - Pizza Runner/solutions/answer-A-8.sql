-- How many pizzas were delivered that had both exclusions and extras?
-- Ile pizz dostarczono, które zawierały zarówno składniki pominięte, jak i dodatkowe?

SELECT
    COUNT(pizza_id) as pizzas_with_exclusions_and_extras
FROM customer_orders_temp
INNER JOIN runner_orders_temp
    ON customer_orders_temp.order_id = runner_orders_temp.order_id
WHERE cancellation IS NULL AND exclusions IS NOT NULL AND extras IS NOT NULL;
