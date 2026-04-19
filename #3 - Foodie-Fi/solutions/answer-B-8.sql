-- How many customers have upgraded to an annual plan in 2020?
-- Ilu klientów przeszło na plan roczny w 2020 roku?

SELECT
    COUNT(DISTINCT customer_id) as annual_customer
FROM subscriptions
WHERE start_date <= '2020-12-31'
    AND start_date >= '2020-01-01'
    AND plan_id = 3;