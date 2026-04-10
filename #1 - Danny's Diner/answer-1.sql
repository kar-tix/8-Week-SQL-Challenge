-- What is the total amount each customer spent at the restaurant?
-- Jaka była całkowita kwota, jaką każdy klient wydał w restauracji?

SELECT
    sales.customer_id AS customer,
    SUM(menu.price) AS total_amount
FROM sales
INNER JOIN menu
    ON sales.product_id = menu.product_id
GROUP BY customer
ORDER BY customer