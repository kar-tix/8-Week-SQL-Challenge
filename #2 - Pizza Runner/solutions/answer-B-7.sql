-- What is the successful delivery percentage for each runner?
-- Jaki jest procent udanych dostaw dla każdego kuriera?

SELECT
    runner_id,
    ((COUNT(order_id)::FLOAT - COUNT(cancellation)::FLOAT) / COUNT(order_id)::FLOAT) * 100 as delivered_percent
FROM runner_orders_temp
GROUP BY runner_id
ORDER BY runner_id;