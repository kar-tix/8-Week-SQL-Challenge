-- What was the average distance travelled for each customer?
-- Jaka była średnia odległość do pokonana dla każdego klienta?

SELECT
    customer_id,
    AVG(distance) as avg_distance
FROM runner_orders_temp
INNER JOIN customer_orders_temp
    ON runner_orders_temp.order_id = customer_orders_temp.order_id
GROUP BY customer_id
ORDER BY customer_id;