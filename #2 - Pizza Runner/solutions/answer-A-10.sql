-- What was the volume of orders for each day of the week?
-- Jaka była liczba zamówień w poszczególne dni tygodnia?

SELECT
    TO_CHAR(order_time, 'Day') as days,
    COUNT(order_id) as orders
FROM customer_orders_temp
GROUP BY days;