-- How many customers downgraded from a pro monthly to a basic monthly plan in 2020?
-- Ilu klientów w 2020 roku przeszło z planu miesięcznego pro na plan miesięczny podstawowy?

-- INSERT INTO subscriptions(
--     "customer_id", "plan_id", "start_date"
-- )
-- VALUES
--     ('7', '1', '2020-11-01')

WITH next_plans_cte AS (
  SELECT
    customer_id,
    plan_id,
    LEAD(plan_id) OVER 
    (PARTITION BY customer_id
      ORDER BY start_date) as next_plan
  FROM subscriptions
  WHERE DATE_PART('year', start_date) = 2020
)

SELECT
    COUNT(*) as downgraded_customer
FROM next_plans_cte
WHERE plan_id = 2 AND next_plan = 1;

