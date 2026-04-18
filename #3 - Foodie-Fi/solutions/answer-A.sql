-- Write a brief description about each customer’s onboarding journey.

WITH random_id AS(
    SELECT 
        customer_id
    FROM subscriptions
    GROUP BY customer_id
    ORDER BY RANDOM()
    LIMIT 8
)

SELECT
    random_id.customer_id as customer,
    plan_name,
    start_date
FROM subscriptions
INNER JOIN plans
    ON subscriptions.plan_id = plans.plan_id
INNER JOIN random_id
    ON subscriptions.customer_id = random_id.customer_id
ORDER BY customer, start_date;