-- What plan start_date values occur after the year 2020 for our dataset? Show the breakdown by count of events for each plan_name
-- Jakie wartości start_date występują w naszym zbiorze danych po roku 2020? Pokaż podział według liczby zdarzeń dla każdej nazwy_planu

SELECT
    plan_name,
    COUNT(customer_id) as events_num
FROM plans
INNER JOIN subscriptions
    ON plans.plan_id = subscriptions.plan_id
WHERE start_date >= '2021-01-01'
GROUP BY plan_name;
