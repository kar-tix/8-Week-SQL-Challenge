-- Join All The Things
-- Połącz Wszystkie Elementy

SELECT
    sales.customer_id,
    sales.order_date,
    menu.product_name,
    menu.price,
    CASE
        WHEN sales.order_date >= members.join_date THEN 'Y'
        WHEN sales.order_date < members.join_date THEN 'N'
        ELSE 'N'
    END as members
FROM sales
INNER JOIN menu
    ON sales.product_id = menu.product_id
LEFT JOIN members
    ON sales.customer_id = members.customer_id
ORDER BY sales.customer_id, sales.order_date, menu.price DESC;