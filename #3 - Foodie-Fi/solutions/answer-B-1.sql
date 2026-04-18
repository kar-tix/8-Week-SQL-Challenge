-- How many customers has Foodie-Fi ever had?
-- Ilu klientów miało kiedykolwiek Foodie-Fi?

SELECT
    COUNT(DISTINCT customer_id) as unique_customers
FROM subscriptions;