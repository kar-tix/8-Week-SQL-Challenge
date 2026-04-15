-- What was the total volume of pizzas ordered for each hour of the day?
-- Jaka była łączna liczba zamówionych pizz w każdej godzinie dnia?

SELECT
    DATE_PART('hour', order_time) as hours,
    COUNT(order_id) as pizzas
FROM customer_orders_temp
GROUP BY hours
ORDER BY hours;