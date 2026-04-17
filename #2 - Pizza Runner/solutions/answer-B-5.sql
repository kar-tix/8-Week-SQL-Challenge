-- What was the difference between the longest and shortest delivery times for all orders?
-- Jaka była różnica między najdłuższym a najkrótszym czasem realizacji wszystkich zamówień?


SELECT
    MAX(duration) - MIN(duration) as diff_time
FROM runner_orders_temp;