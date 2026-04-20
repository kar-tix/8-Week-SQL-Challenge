-- Can you further breakdown this average value into 30 day periods (i.e. 0-30 days, 31-60 days etc)
-- Czy możesz podzielić tę średnią wartość na okresy 30-dniowe (np. 0–30 dni, 31–60 dni itd.)?

WITH trial_date_cte as(
-- zwraca, kiedy rozpoczęła się data okresu próbnego
    SELECT
        customer_id,
        start_date as trial_date
    FROM subscriptions
    WHERE plan_id = 0
),
annual_date_cte as(
-- zwraca, kiedy rozpoczął się plan roczny
    SELECT
    customer_id,
    start_date as annual_date
FROM subscriptions
WHERE plan_id = 3
),
intervals as(
-- podział na miesięczne przedziały
    SELECT 
        annual_date - trial_date as diff,
        WIDTH_BUCKET(annual_date - trial_date, 0, 360, 12) as avg_days_in_periods
    FROM trial_date_cte
    INNER JOIN annual_date_cte
        ON trial_date_cte.customer_id = annual_date_cte.customer_id
)

SELECT 
    CONCAT((avg_days_in_periods - 1) * 30, ' - ', avg_days_in_periods * 30, ' days') as  period,
    COUNT(*) AS total_customers,
    ROUND(AVG(diff), 2) as avg_days_to_upgrade
FROM intervals
GROUP BY avg_days_in_periods
ORDER BY avg_days_in_periods;
