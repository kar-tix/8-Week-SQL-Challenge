-- What is the customer count and percentage breakdown of all 5 plan_name values at 2020-12-31?
-- Jaka była liczba klientów i procentowy podział na wszystkie 5 planów na dzień 31.12.2020 r.?

WITH latest_rank_cte AS(
SELECT
    customer_id,
    plan_id,
    start_date,
    RANK() OVER
    (PARTITION BY customer_id
    ORDER BY plan_id DESC) as latest_rank
FROM subscriptions
WHERE start_date <= '2020-12-31'
  )

SELECT
    plan_id,
    COUNT(customer_id) as number_of_customers,
    ROUND(
        COUNT(customer_id) * 100.0 / (SELECT COUNT(DISTINCT customer_id) FROM subscriptions), 1
        ) as percent
FROM latest_rank_cte
WHERE latest_rank = 1
GROUP BY plan_id
ORDER BY plan_id;