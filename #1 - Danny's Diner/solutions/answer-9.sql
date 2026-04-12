-- If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
-- Jeśli każdy wydany 1 dolar odpowiada 10 punktom, a sushi ma mnożnik punktów 2x – ile punktów miałby każdy klient?

SELECT
    sales.customer_id,
    SUM(
        CASE
            WHEN menu.product_name = 'sushi' then menu.price * 20
            ELSE menu.price * 10
        END 
    )as points
FROM sales
INNER JOIN menu
    ON sales.product_id = menu.product_id
GROUP BY customer_id
ORDER BY customer_id;