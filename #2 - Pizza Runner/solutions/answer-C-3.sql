-- What was the most common exclusion?
-- Co najczęściej było odrzucane?

WITH toppings_cte as(
    SELECT
        order_id,
        STRING_TO_TABLE(exclusions, ', ')::INTEGER as toppings_id
    FROM customer_orders_temp
    WHERE exclusions IS NOT NULL
)

SELECT
    topping_name,
    COUNT(toppings_id) as how_many_removed
FROM toppings_cte
INNER JOIN pizza_toppings
    ON toppings_cte.toppings_id = pizza_toppings.topping_id
GROUP BY topping_name
ORDER BY how_many_removed DESC
-- LIMIT 1;