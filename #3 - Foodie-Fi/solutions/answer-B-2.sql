-- What is the monthly distribution of trial plan start_date values for our dataset?
-- Jaki jest miesięczny rozkład wartości start_date planu próbnego dla naszego zestawu danych?

SELECT
    
    COUNT(customer_id) as trial_subs
FROM subscriptions
WHERE plan_id = 0
GROUP BY DATE_TRUNC('month', start_date)
ORDER BY DATE_TRUNC('month', start_date)