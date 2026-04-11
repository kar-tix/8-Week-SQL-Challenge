-- Which item was purchased just before the customer became a member?
-- Który produkt został kupiony tuż przed tym, jak klient został członkiem?

WITH members_orders AS(
    SELECT
        sales.customer_id,
        sales.order_date,
        members.join_date,
        menu.product_name,
        DENSE_RANK() OVER
            (PARTITION BY sales.customer_id
            ORDER BY order_date) as rank_item
    FROM sales
    RIGHT JOIN members
        ON sales.customer_id = members.customer_id
    INNER JOIN menu
        ON sales.product_id = menu.product_id
    WHERE order_date < join_date
)

SELECT
    customer_id,
    order_date,
    product_name
FROM members_orders
WHERE rank_item = 1;