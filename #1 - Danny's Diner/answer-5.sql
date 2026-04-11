-- Which item was the most popular for each customer?
-- Który produkt był najpopularniejszy dla każdego klienta?

WITH popular_product AS(
    SELECT
        sales.customer_id as customer,
        COUNT(sales.product_id) as count_product,
        menu.product_name as product_name,
        DENSE_RANK() OVER
            (PARTITION BY customer_id
            ORDER BY COUNT(sales.product_id) DESC) as rank_item
    FROM sales
    INNER JOIN menu
        ON sales.product_id = menu.product_id
    GROUP BY customer_id, product_name
    ORDER BY customer_id
)

SELECT
    customer,
    product_name,
    count_product
FROM popular_product
WHERE rank_item = 1