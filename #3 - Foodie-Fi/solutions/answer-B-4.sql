-- What is the customer count and percentage of customers who have churned rounded to 1 decimal place?
-- Jaka jest liczba klientów i procent klientów, którzy zrezygnowali, zaokrąglona do jednego miejsca po przecinku?


SELECT
    COUNT(DISTINCT CASE WHEN plan_id = 4 THEN customer_id END) AS churned_customers,
    ROUND(
        COUNT(DISTINCT CASE WHEN plan_id = 4 THEN customer_id END) * 100.0 / COUNT(DISTINCT customer_id), 1
        ) AS churn_percentage
FROM subscriptions;