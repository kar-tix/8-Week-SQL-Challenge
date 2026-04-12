-- In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?
-- W pierwszym tygodniu po dołączeniu klienta do programu (wliczając dzień dołączenia) otrzymuje on 2x więcej punktów za wszystkie produkty, a nie tylko sushi – ile punktów mają klienci A i B na koniec stycznia?



SELECT
    sales.customer_id,
    SUM(
        CASE
            WHEN sales.order_date BETWEEN members.join_date AND (members.join_date + 6) then menu.price * 20 -- dodanie daty zadziała w PostgreSQL, ale na innych silnikach niekoniecznie
            -- alternatywnie: DATEADD(day, 6, members.join_date)
            WHEN menu.product_name = 'sushi' then menu.price * 20
            ELSE menu.price * 10
        END 
    )as points
FROM sales
INNER JOIN menu
    ON sales.product_id = menu.product_id
RIGHT JOIN members
    ON sales.customer_id = members.customer_id
WHERE sales.order_date <= '31.01.2021'
GROUP BY sales.customer_id
ORDER BY sales.customer_id;
