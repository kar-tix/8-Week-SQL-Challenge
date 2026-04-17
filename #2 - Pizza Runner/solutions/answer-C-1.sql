-- What are the standard ingredients for each pizza?
-- Jakie są standardowe składniki każdej pizzy?

WITH toppings_cte as(
    SELECT
        pizza_id,
        STRING_TO_TABLE(toppings, ', ')::INTEGER as toppings_id
    FROM pizza_recipes
)

SELECT
    pizza_name,
    --toppings_id,
    STRING_AGG(topping_name, ', ') as ingredients_name
FROM toppings_cte
INNER JOIN pizza_names
    ON toppings_cte.pizza_id = pizza_names.pizza_id
INNER JOIN pizza_toppings
    ON toppings_cte.toppings_id = pizza_toppings.topping_id
GROUP BY pizza_name;