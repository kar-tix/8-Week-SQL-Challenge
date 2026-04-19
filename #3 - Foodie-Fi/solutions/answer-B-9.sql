-- How many days on average does it take for a customer to an annual plan from the day they join Foodie-Fi?
-- Ile dni średnio zajmuje klientowi przejście na plan roczny od dnia dołączenia do Foodie-Fi?

WITH trial_date_cte as(
    SELECT
        customer_id,
        start_date as trial_date
    FROM subscriptions
    WHERE plan_id = 0
),
annual_date_cte as(
    SELECT
    customer_id,
    start_date as annual_date
FROM subscriptions
WHERE plan_id = 3
)

SELECT
    --annual_date_cte.customer_id,
    ROUND(AVG(annual_date - trial_date), 0) as avg_annual_time
FROM trial_date_cte
INNER JOIN annual_date_cte
    ON annual_date_cte.customer_id = trial_date_cte.customer_id;