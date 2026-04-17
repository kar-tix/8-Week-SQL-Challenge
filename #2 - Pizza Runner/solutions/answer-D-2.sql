-- What if there was an additional $1 charge for any pizza extras? 
-- A co, gdyby za każdy dodatkowy składnik do pizzy pobierano dodatkową opłatę w wysokości 1 dolara?

WITH earnings_cte AS(
    SELECT
        SUM(
            CASE
                WHEN pizza_id = 1 THEN 12
                WHEN pizza_id = 2 THEN 10
                ELSE 0
            END
        ) as earnings_pizzas,
        SUM(
            CASE
                WHEN extras IS NULL THEN 0
                ELSE array_length(string_to_array(extras, ','), 1)
            END
        ) as earnings_extras
    FROM customer_orders_temp
    INNER JOIN runner_orders_temp
        ON customer_orders_temp.order_id = runner_orders_temp.order_id
    WHERE cancellation IS NULL
)

SELECT 
    earnings_extras + earnings_pizzas as total_earnings
FROM earnings_cte;