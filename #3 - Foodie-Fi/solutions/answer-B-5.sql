-- How many customers have churned straight after their initial free trial - what percentage is this rounded to the nearest whole number?


WITH next_plan_cte AS (
  SELECT
    customer_id,
    plan_id,
    LEAD(plan_id) OVER (
      PARTITION BY customer_id
      ORDER BY plan_id
    ) as next_plan
  FROM subscriptions
)

SELECT
  COUNT(*) as churned_after_trial,
  ROUND(
    COUNT(*) * 100 / (SELECT COUNT(DISTINCT customer_id) FROM subscriptions), 0
  ) as percentage
FROM next_plan_cte
WHERE plan_id = 0 AND next_plan = 4;