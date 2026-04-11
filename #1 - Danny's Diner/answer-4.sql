-- What is the most purchased item on the menu and how many times was it purchased by all customers?
-- Która pozycja w menu jest najczęściej kupowana i ile razy została kupiona przez klientów?

SELECT
    menu.product_name as product,
    COUNT(sales.product_id) as count_product
FROM menu
INNER JOIN sales
    ON menu.product_id = sales.product_id
GROUP BY product
ORDER BY count_product DESC
LIMIT 1;