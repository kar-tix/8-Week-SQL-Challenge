-- How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
-- Ilu biegaczy zapisało się w każdym tygodniu? (tj. tydzień rozpoczyna się 1 stycznia 2021 r.)

SELECT
    DATE_PART('WEEK', registration_date + INTERVAL '3 days') as week,
    COUNT(runner_id) as runners
FROM runners
GROUP BY week
ORDER BY week;