-- If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes - how much money has Pizza Runner made so far if there are no delivery fees?
-- Jeśli pizza „Meat Lovers” kosztuje 12 dolarów, a wegetariańska 10 dolarów i nie pobiera się żadnych opłat za zmiany w zamówieniu – ile pieniędzy zarobiła dotychczas firma Pizza Runner, zakładając, że nie pobiera opłat za dostawę?

SELECT
    SUM(
        CASE
            WHEN pizza_id = 1 THEN 12
            WHEN pizza_id = 2 THEN 10
            ELSE 0
        END
    ) as total_earnings
FROM customer_orders_temp
INNER JOIN runner_orders_temp
    ON customer_orders_temp.order_id = runner_orders_temp.order_id
WHERE cancellation IS NULL;
