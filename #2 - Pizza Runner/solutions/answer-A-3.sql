-- How many successful orders were delivered by each runner?
-- Ile pomyślnie zrealizowanych zamówień dostarczył każdy kurier?

SELECT
    runner_id,
    COUNT(order_id) as delivered_orders
FROM runner_orders_temp
WHERE cancellation IS NULL
GROUP BY runner_id;