-- For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
-- Dla każdego klienta, ile dostarczonych pizz miało chociaż 1 zmianę i ile nie miało żadnych zmian?

SELECT
    customer_id,
    SUM(
        CASE
            WHEN exclusions IS NOT NULL OR extras IS NOT NULL THEN 1
            ELSE 0
        END 
    ) as min_1_changes,
    SUM(
        CASE
            WHEN exclusions IS NULL AND extras IS NULL THEN 1
            ELSE 0
        END 
    ) as no_changes
FROM customer_orders_temp
INNER JOIN runner_orders_temp
    ON customer_orders_temp.order_id = runner_orders_temp.order_id
WHERE cancellation IS NULL
GROUP BY customer_id
ORDER BY customer_id;
