-- What was the first item from the menu purchased by each customer?
-- Co było pierwszą pozycją z menu zakupioną przez każdego klienta?

WITH rank_sales AS(
    SELECT
        sales.customer_id as customer,
        sales.order_date as order_date,
        menu.product_name as product,
        DENSE_RANK() OVER
            (PARTITION BY customer_id
            ORDER BY  order_date) as rank_item
    FROM sales
    INNER JOIN menu
        ON menu.product_id = sales.product_id
)

SELECT
    customer,
    product
FROM rank_sales
WHERE rank_item = 1
GROUP BY customer, product
ORDER BY customer;