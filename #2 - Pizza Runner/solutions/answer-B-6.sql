-- What was the average speed for each runner for each delivery and do you notice any trend for these values?
-- Jaka była średnia prędkość poszczególnych kurierów przy każdym zamówieniu i czy dostrzegasz jakąś tendencję w tych wartościach?

SELECT
    runner_id,
    order_id,
    ROUND(AVG(distance::NUMERIC / NULLIF(duration::NUMERIC / 60, 0)), 2) as avg_speed
FROM runner_orders_temp
WHERE cancellation IS NULL
GROUP BY order_id, runner_id
ORDER BY runner_id;