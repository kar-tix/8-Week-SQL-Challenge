-- What is the number and percentage of customer plans after their initial free trial?
-- Jaka jest liczba i procent klientów korzystających z planów po początkowym bezpłatnym okresie próbnym?


WITH next_plans AS (
  SELECT
    customer_id,
    plan_id,
    LEAD(plan_id) OVER (
      PARTITION BY customer_id
      ORDER BY start_date
    ) AS next_plan
  FROM subscriptions
)

SELECT
    next_plan,
    COUNT(*) AS customer_count,
    ROUND(
        COUNT(*) * 100.0 / (SELECT COUNT(DISTINCT customer_id) FROM subscriptions), 1
        ) as percentage
FROM next_plans
WHERE plan_id = 0 AND next_plan IS NOT NULL
GROUP BY next_plan
ORDER BY next_plan;