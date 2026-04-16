-- Is there any relationship between the number of pizzas and how long the order takes to prepare?
-- Czy istnieje jakiś związek między liczbą pizz a czasem potrzebnym na przygotowanie zamówienia?


WITH prep_time_cte AS(
    SELECT
        customer_orders_temp.order_id,
        DATE_PART('minute', pickup_time - order_time) as prep_time,
        COUNT(pizza_id) as number_of_pizzas
    FROM customer_orders_temp
    INNER JOIN runner_orders_temp
        ON customer_orders_temp.order_id = runner_orders_temp.order_id
    WHERE pickup_time IS NOT NULL
    GROUP BY customer_orders_temp.order_id, prep_time
)

SELECT
    number_of_pizzas,
    AVG(prep_time) as avg_prep_time
FROM prep_time_cte
GROUP BY number_of_pizzas;