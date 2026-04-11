-- How many days has each customer visited the restaurant?
-- Przez ile dni każdy klient odwiedzał restaurację?

SELECT
    sales.customer_id as customer,
    COUNT(DISTINCT sales.order_date) as count_date
FROM sales
GROUP BY customer_id
ORDER BY customer;