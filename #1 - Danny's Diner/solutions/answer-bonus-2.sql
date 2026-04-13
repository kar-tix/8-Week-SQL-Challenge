-- Rank All The Things
-- Uporzadkuj Wszystkie Rzeczy

WITH all_joined AS (
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
    ORDER BY sales.customer_id, sales.order_date, menu.price DESC
)

SELECT *,
    CASE
        WHEN members = 'N' THEN NULL
        ELSE DENSE_RANK() OVER
            (PARTITION BY customer_id, members
            ORDER BY order_date)
    END as ranking
FROM all_joined;