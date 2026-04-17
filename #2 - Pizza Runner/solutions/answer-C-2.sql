-- What was the most commonly added extra?
-- Jaki był najczęściej wybierany dodatek?

WITH toppings_cte as(
    SELECT
        order_id,
        STRING_TO_TABLE(extras, ', ')::INTEGER as toppings_id
    FROM customer_orders_temp
    WHERE extras IS NOT NULL
)

SELECT
    topping_name,
    COUNT(toppings_id) as how_many_added
FROM toppings_cte
INNER JOIN pizza_toppings
    ON toppings_cte.toppings_id = pizza_toppings.topping_id
GROUP BY topping_name
ORDER BY how_many_added DESC;