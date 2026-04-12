-- What is the total items and amount spent for each member before they became a member?
-- Jaka jest łączna liczba zakupionych produktów oraz kwota wydana przez każdego członka przed dołączeniem do programu członkowskiego?


WITH before_members AS(
    SELECT
        sales.customer_id as customer,
        menu.price,
        sales.order_date,
        members.join_date
    FROM sales
    RIGHT JOIN members
        ON sales.customer_id = members.customer_id
    INNER JOIN menu
        ON sales.product_id = menu.product_id
    WHERE order_date < join_date
)

SELECT
    customer,
    COUNT(customer) as total_item,
    SUM(price) as total_price
FROM before_members
GROUP BY customer
ORDER BY customer;