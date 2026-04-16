-- What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
-- Ile minut średnio zajmowało każdemu kurierowi dotarcie do Pizza Runner w celu odebrania zamówienia?

SELECT
    runner_id,
    DATE_PART('minute', AVG(pickup_time - order_time)) as avg_pickup_time
FROM runner_orders_temp
INNER JOIN customer_orders_temp
    ON runner_orders_temp.order_id = customer_orders_temp.order_id
WHERE pickup_time IS NOT NULL
GROUP BY runner_id
ORDER BY runner_id;