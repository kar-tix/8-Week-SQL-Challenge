<div align="center">

# Case Study #2 - Pizza Runner </br>

<img src="img/logo_case.png" alt="Logo case study 2" width="500" height="500">
</div>

## 💡 Informacje

W folderze _solutions_ znajdują się pliki z rozwiązaniami w SQL.</br>
Do wykonania wykorzystany został SQL oraz PostgreSQL.</br>
Szczegółowe informacje dotyczące tego studium przypadku znajdują się [tutaj](https://8weeksqlchallenge.com/case-study-2/).

## 📋 Spis treści

- [Opis](#opis)
- [Diagram relacji](#diagram-relacji)
- [Czyszczenie danych](#️-czyszczenie-danych)
- [Rozwiązanie zapytań: A. Pizza Metrics](#rozwiązanie-a-pizza-metrics)
  - [1. How many pizzas were ordered?](#1-how-many-pizzas-were-ordered)
  - [2. How many unique customer orders were made?](#2-how-many-unique-customer-orders-were-made)
  - [3. How many successful orders were delivered by each runner?](#3-how-many-successful-orders-were-delivered-by-each-runner)
  - [4. How many of each type of pizza was delivered?](#4how-many-of-each-type-of-pizza-was-delivered)
  - [5. How many Vegetarian and Meatlovers were ordered by each customer?](#5-how-many-vegetarian-and-meatlovers-were-ordered-by-each-customer)
  - [6. What was the maximum number of pizzas delivered in a single order?](#6-what-was-the-maximum-number-of-pizzas-delivered-in-a-single-order)
  - [7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?](#7-for-each-customer-how-many-delivered-pizzas-had-at-least-1-change-and-how-many-had-no-changes)
  - [8. How many pizzas were delivered that had both exclusions and extras?](#8-how-many-pizzas-were-delivered-that-had-both-exclusions-and-extras)
  - [9. What was the total volume of pizzas ordered for each hour of the day?](#9-what-was-the-total-volume-of-pizzas-ordered-for-each-hour-of-the-day)
  - [10. What was the volume of orders for each day of the week?](#10-what-was-the-volume-of-orders-for-each-day-of-the-week)
- [Rozwiązanie zapytań: B. Runner and Customer Experience](#rozwiązanie-b-runner-and-customer-experience)
  - [1. How many runners signed up for each 1 week period?](#1-how-many-runners-signed-up-for-each-1-week-period-ie-week-starts-2021-01-01)
  - [2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?](#2-what-was-the-average-time-in-minutes-it-took-for-each-runner-to-arrive-at-the-pizza-runner-hq-to-pickup-the-order)
  - [3. Is there any relationship between the number of pizzas and how long the order takes to prepare?](#3-is-there-any-relationship-between-the-number-of-pizzas-and-how-long-the-order-takes-to-prepare)
  - [4. What was the average distance travelled for each customer?](#4-what-was-the-average-distance-travelled-for-each-customer)
  - [5. What was the difference between the longest and shortest delivery times for all orders?](#5-what-was-the-difference-between-the-longest-and-shortest-delivery-times-for-all-orders)
  - [6. What was the average speed for each runner for each delivery and do you notice any trend for these values?](#6-what-was-the-average-speed-for-each-runner-for-each-delivery-and-do-you-notice-any-trend-for-these-values)
  - [7. What is the successful delivery percentage for each runner?](#7-what-is-the-successful-delivery-percentage-for-each-runner)
- [Rozwiązanie zapytań: C. Ingredient Optimisation](#rozwiązanie-c-ingredient-optimisation)
  - [1. What are the standard ingredients for each pizza?](#1-what-are-the-standard-ingredients-for-each-pizza)
  - [2. What was the most commonly added extra?](#2-what-was-the-most-commonly-added-extra)
  - [3. What was the most common exclusion?](#3-what-was-the-most-common-exclusion)
- [Rozwiązanie zapytań: D. Pricing and Ratings](#rozwiązanie-d-pricing-and-ratings)
  - [1. If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes - how much money has Pizza Runner made so far if there are no delivery fees?](#1-if-a-meat-lovers-pizza-costs-12-and-vegetarian-costs-10-and-there-were-no-charges-for-changes---how-much-money-has-pizza-runner-made-so-far-if-there-are-no-delivery-fees)
  - [2. What if there was an additional $1 charge for any pizza extras?](#2-what-if-there-was-an-additional-1-charge-for-any-pizza-extras)

## 🔍 Opis

### Wprowadzenie

Danny otworzył nowy biznes - pizzerię, ale wiedział, że sama pizza nie wystarczy, aby utworzyć swoje własne imperium pizzy, dlatego wpadł na kolejny pomysł i postanowił ją "zuberyzować" - i tak powstała Pizza Runner.

Danny zatrudnił kurierów, którzy mieli dostarczać pizzę, a także programistów, którzy stworzyli aplikację mobilną do przyjmowania zamówień od klientów.

### Problem

Danny potrzebuje pomocy w czyszczeniu danych i zastosowaniu podstawowych obliczeń, aby móc lepiej kierować prać dostawców i zoptymalizować działalność Pizza Runner.

## 📈 Diagram relacji

<div align=center>
<img src="img/diagram.png" alt="Diagram relacji" width="65%" height="65%">
</div>

## ⚙️ Czyszczenie danych

### Tabela: customer_orders

- W kolumnie `exclusions` oraz `extras` znajdują się brakujące wartości i wartości null jako teksty.
  Problem ten można rozwiązać na dwa sposoby:</br>

1. Zastosowanie funkcji UPDATE

```sql
UPDATE customer_orders
SET
    exclusions =
        CASE
            WHEN exclusions = '' OR exclusions = 'null' THEN NULL
            ELSE exclusions
        END,
    extras =
        CASE
            WHEN extras = '' OR extras = 'null' THEN NULL
            ELSE extras
        END;
```

Problem z tym sposobem jest taki, że raz zmienionej tabeli nie da się cofnąć i jedyną opcją jest zrobienie kopii zapasowej, dlatego jest to bardzo ryzykowna i niebezpieczna opcja przy dużych zbiorach danych.

2. Stworzenie nowej tabeli (lub tymczasowej)

```sql
CREATE TABLE customer_orders_temp AS
SELECT
    order_id,
    customer_id,
    pizza_id,
    CASE
        WHEN exclusions = '' OR exclusions = 'null' THEN NULL
        ELSE exclusions
    END AS exclusions,
    CASE
        WHEN extras = '' OR extras = 'null' THEN NULL
        ELSE extras
    END as extras,
    order_time
FROM customer_orders;
```

To rozwiązanie jest o wiele bezpieczniejsze, nie powoduje modyfikacji w danych źródłowych.

### Tabela: runner_orders

- Konwersja typów danych z kolumn: `pickup_time`, `duration`, `distance`
- Usunięcie "km" z kolumny `distance`
- Usunięcie "minutes", "mins" itp. z kolumny `duration`
- Modyfikacja brakujących wartości i niepoprawnych danych

```sql
CREATE TABLE runner_orders_temp AS
SELECT
    order_id,
    runner_id,
    CASE
        WHEN pickup_time = 'null' THEN NULL
        ELSE pickup_time
    END::TIMESTAMP as pickup_time,
    CASE
        WHEN distance = 'null' THEN NULL
        WHEN distance LIKE '%km' THEN TRIM('km' FROM distance)
        ELSE distance
    END::FLOAT as distance,
    CASE
        WHEN duration = 'null' THEN NULL
        WHEN duration LIKE '%minutes' THEN TRIM('minutes' FROM duration)
        WHEN duration LIKE '%minute' THEN TRIM('minute' FROM duration)
        WHEN duration LIKE '%mins' THEN TRIM('mins' FROM duration)
        ELSE duration
    END::INT as duration,
    CASE
        WHEN cancellation IN('null', '') THEN NULL
        ELSE cancellation
    END as cancellation
FROM runner_orders;
```

## Rozwiązanie: A. Pizza Metrics

### 1. How many pizzas were ordered?

_Jak dużo pizz zostało zamówionych?_

```sql
SELECT
    COUNT(order_id) as total_pizza
FROM customer_orders_temp;
```

#### Wynik zapytania/Odpowiedź:

| total_pizza |
| :---------: |
|     14      |

---

### 2. How many unique customer orders were made?

_Ile zostało złożonych unikalnych zamówień?_

```sql
SELECT
    COUNT(DISTINCT order_id) as unique_orders
FROM customer_orders_temp;
```

#### Proces:

- w danych powtarzają się zamówienia, dlatego zastosowano DISTINCT, aby pobrać tylko unikalne numery zamówień

#### Wynik zapytania/Odpowiedź:

| unique_orders |
| :-----------: |
|      10       |

---

### 3. How many successful orders were delivered by each runner?

_Ile pomyślnie zrealizowanych zamówień dostarczył każdy kurier?_

```sql
SELECT
    runner_id,
    COUNT(order_id) as delivered_orders
FROM runner_orders_temp
WHERE cancellation IS NULL
GROUP BY runner_id;
```

#### Proces:

Do wyodrębnienia zamówień zrealizowanych od niezrealizowanych można było użyć wiele kolumn, ja jednak wykorzystałam kolumnę `cancellation`, ponieważ ona jasno mówi czy zamówienie zostało zrealizowane czy anulowane.

#### Wynik zapytania/Odpowiedź:

| runner_id | delivered_orders |
| :-------: | :--------------: |
|     1     |        4         |
|     2     |        3         |
|     3     |        1         |

---

### 4.How many of each type of pizza was delivered?

_Ile każdego rodzaju pizzy dostało dostarczonych?_

```sql
SELECT
    pizza_name,
    COUNT(customer_orders_temp.order_id) as total_delivered
FROM customer_orders_temp
INNER JOIN pizza_names
    ON pizza_names.pizza_id = customer_orders_temp.pizza_id
INNER JOIN runner_orders_temp
    ON customer_orders_temp.order_id = runner_orders_temp.order_id
WHERE cancellation IS NULL
GROUP BY pizza_name;
```

#### Proces:

Z tablicą `customer_orders_temp` połączono tablice `pizza_names` oraz `runner_orders_temp`, aby móc uzyskać nazwy poszczególnych pizz oraz dowiedzieć się czy nie zostały anulowane.

#### Wynik zapytania/Odpowiedź:

| pizza_name | total_delivered |
| :--------: | :-------------: |
| Vegetarian |        3        |
| Meatlovers |        9        |

---

### 5. How many Vegetarian and Meatlovers were ordered by each customer?

_Ile Vegetarian i Meatlovers zostało zamówionych przez każdego klienta?_

```sql
SELECT
    customer_id,
    pizza_name,
    COUNT(order_id) as total_ordered
FROM pizza_names
INNER JOIN customer_orders_temp
    ON pizza_names.pizza_id = customer_orders_temp.pizza_id
GROUP BY customer_id, pizza_name
ORDER BY customer_id, pizza_name;
```

#### Wynik zapytania/Odpowiedź:

| customer_id | pizza_name | total_ordered |
| :---------: | :--------: | :-----------: |
|     101     | Meatlovers |       2       |
|     101     | Vegetarian |       1       |
|     102     | Meatlovers |       2       |
|     102     | Vegetarian |       1       |
|     103     | Meatlovers |       3       |
|     103     | Vegetarian |       1       |
|     104     | Meatlovers |       3       |
|     105     | Vegetarian |       1       |

---

### 6. What was the maximum number of pizzas delivered in a single order?

_Jaka była największa liczba pizz dostarczonych w ramach jednego zamówienia?_

```sql
SELECT
    c.order_id,
    COUNT(pizza_id) as pizzas
FROM customer_orders_temp as c
INNER JOIN runner_orders_temp
    ON c.order_id = runner_orders_temp.order_id
WHERE cancellation IS NULL
GROUP BY c.order_id
ORDER BY pizzas DESC LIMIT 1;
```

#### Wynik zapytania/Odpowiedź:

| order_id | pizzas |
| :------: | :----: |
|    4     |   3    |

---

### 7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?

_Dla każdego klienta, ile dostarczonych pizz miało chociaż 1 zmianę i ile nie miało żadnych zmian?_

```sql
SELECT
    customer_id,
    SUM(
        CASE
            WHEN exclusions IS NOT NULL OR extras IS NOT NULL THEN 1
            ELSE 0
        END
    ) as min_1_changes,
    SUM(
        CASE
            WHEN exclusions IS NULL AND extras IS NULL THEN 1
            ELSE 0
        END
    ) as no_changes
FROM customer_orders_temp
INNER JOIN runner_orders_temp
    ON customer_orders_temp.order_id = runner_orders_temp.order_id
WHERE cancellation IS NULL
GROUP BY customer_id
ORDER BY customer_id;
```

#### Proces

Dzięki wcześniejszemu wyczyszczeniu danych zapytanie jest krótkie i przejrzyste: w funkcji agregującej SUM() zastosowano wyrażenie CASE, której warunki definiują czy w danym zamówieniu była zmiana czy też nie.

#### Wynik zapytania/Odpowiedź:

| customer_id | min_1_changes | no_changes |
| :---------: | :-----------: | :--------: |
|     101     |       0       |     2      |
|     102     |       0       |     3      |
|     103     |       3       |     0      |
|     104     |       2       |     1      |
|     105     |       1       |     0      |

---

### 8. How many pizzas were delivered that had both exclusions and extras?

_Ile pizz dostarczono, które zawierały zarówno składniki pominięte, jak i dodatkowe?_

```sql
SELECT
    COUNT(pizza_id) as pizzas_with_exclusions_and_extras
FROM customer_orders_temp
INNER JOIN runner_orders_temp
    ON customer_orders_temp.order_id = runner_orders_temp.order_id
WHERE cancellation IS NULL AND exclusions IS NOT NULL AND extras IS NOT NULL;
```

#### Wynik zapytania/Odpowiedź:

| pizzas_with_exclusions_and_extras |
| :-------------------------------: |
|                 1                 |

---

### 9. What was the total volume of pizzas ordered for each hour of the day?

_Jaka była łączna liczba zamówionych pizz w każdej godzinie dnia?_

```sql
SELECT
    DATE_PART('hour', order_time) as hours,
    COUNT(order_id) as pizzas
FROM customer_orders_temp
GROUP BY hours
ORDER BY hours;
```

#### Proces:

Do wyciągnięcia godziny z daty potrzebna była funkcja DATEPART(), w związku z tym, że pracuję na PostgreSQL miała ona formę DATE_PART().

#### Wynik zapytania/Odpowiedź:

| hours | pizzas |
| :---: | :----: |
|  11   |   1    |
|  13   |   3    |
|  18   |   3    |
|  19   |   1    |
|  21   |   3    |
|  23   |   3    |

---

### 10. What was the volume of orders for each day of the week?

_Jaka była liczba zamówień w poszczególne dni tygodnia?_

```sql
SELECT
    TO_CHAR(order_time, 'Day') as days,
    COUNT(order_id) as orders
FROM customer_orders_temp
GROUP BY days;
```

#### Proces:

Funkcja TO_CHAR() jest funkcją, którą PostreSQL wykorzystuje do konwertowania różnych typów danych. W tym przypadku została użyta do zmiany daty w dzień tygodnia.

#### Wynik zapytania/Odpowiedź:

|   days    | orders |
| :-------: | :----: |
| Saturday  |   5    |
| Thursday  |   3    |
|  Friday   |   1    |
| Wednesday |   5    |

---

## Rozwiązanie: B. Runner and Customer Experience

### 1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)

_Ilu biegaczy zapisało się w każdym tygodniu? (tj. tydzień rozpoczyna się 1 stycznia 2021 r.)_

```sql
SELECT
    DATE_PART('WEEK', registration_date + INTERVAL '3 days') as week,
    COUNT(runner_id) as runners
FROM runners
GROUP BY week
ORDER BY week;
```

#### Proces:

Użyta w pytaniu A-9 funkcja DATE_PART() pozwala na wyodrębnienie numeru tygodnia z daty, jednakże w związku z tym, że 1 stycznia 2021 wypada w czwartek, funkcja automatycznie liczy ten tydzień do starego roku jako 53 tydzień, dlatego aby liczyć 1 stycznia jako pierwszy tydzień trzeba było dodać interwał przesuwajacy o 3 dni.

#### Wynik zapytania/Odpowiedź:

| week | runners |
| :--: | :-----: |
|  1   |    2    |
|  2   |    1    |
|  3   |    1    |

---

### 2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?

_Ile minut średnio zajmowało każdemu kurierowi dotarcie do Pizza Runner w celu odebrania zamówienia?_

```sql
SELECT
    runner_id,
    DATE_PART('minute', AVG(pickup_time - order_time)) as avg_pickup_time
FROM runner_orders_temp
INNER JOIN customer_orders_temp
    ON runner_orders_temp.order_id = customer_orders_temp.order_id
WHERE pickup_time IS NOT NULL
GROUP BY runner_id
ORDER BY runner_id;
```

#### Wynik zapytania/Odpowiedź:

| runner_id | avg_pickup_time |
| :-------: | :-------------: |
|     1     |       15        |
|     2     |       23        |
|     3     |       10        |

---

### 3. Is there any relationship between the number of pizzas and how long the order takes to prepare?

_Czy istnieje jakiś związek między liczbą pizz a czasem potrzebnym na przygotowanie zamówienia?_

```sql
WITH prep_time_cte AS(
    SELECT
        customer_orders_temp.order_id,
        DATE_PART('minute', pickup_time - order_time) as prep_time,
        COUNT(pizza_id) as number_of_pizzas
    FROM customer_orders_temp
    INNER JOIN runner_orders_temp
        ON customer_orders_temp.order_id = runner_orders_temp.order_id
    WHERE pickup_time IS NOT NULL
    GROUP BY customer_orders_temp.order_id, prep_time
)

SELECT
    number_of_pizzas,
    AVG(prep_time) as avg_prep_time
FROM prep_time_cte
GROUP BY number_of_pizzas;
```

#### Wynik zapytania/Odpowiedź:

| number_of_pizzas | avg_prep_time |
| :--------------: | :-----------: |
|        3         |      29       |
|        2         |      18       |
|        1         |      12       |

---

### 4. What was the average distance travelled for each customer?

_Jaka była średnia odległość do pokonana dla każdego klienta?_

```sql
SELECT
    customer_id,
    AVG(distance) as avg_distance
FROM runner_orders_temp
INNER JOIN customer_orders_temp
    ON runner_orders_temp.order_id = customer_orders_temp.order_id
GROUP BY customer_id
ORDER BY customer_id;d
```

#### Wynik zapytania/Odpowiedź:

| customer_id |    avg_distance    |
| :---------: | :----------------: |
|     101     |         20         |
|     102     | 16.733333333333334 |
|     103     | 23.399999999999995 |
|     104     |         10         |
|     105     |         25         |

---

### 5. What was the difference between the longest and shortest delivery times for all orders?

_Jaka była różnica między najdłuższym a najkrótszym czasem realizacji wszystkich zamówień?_

```sql
SELECT
    MAX(duration) - MIN(duration) as diff_time
FROM runner_orders_temp;
```

#### Wynik zapytania/Odpowiedź:

| diff_time |
| :-------: |
|    30     |

---

### 6. What was the average speed for each runner for each delivery and do you notice any trend for these values?

_Jaka była średnia prędkość poszczególnych kurierów przy każdym zamówieniu i czy dostrzegasz jakąś tendencję w tych wartościach?_

```sql
SELECT
    runner_id,
    order_id,
    ROUND(AVG(distance::NUMERIC / NULLIF(duration::NUMERIC / 60, 0)), 2) as avg_speed
FROM runner_orders_temp
WHERE cancellation IS NULL
GROUP BY order_id, runner_id
ORDER BY runner_id;
```

#### Proces:

Obliczając średnią prędkość dane zostały rzutowane na typ NUMERIC a nie FLOAT, ponieważ w przypadku PostgreSQL funkcja ROUND nie wspiera typów FLOAT.

#### Wynik zapytania/Odpowiedź:

| runner_id | order_id | avg_speed |
| :-------: | :------: | :-------: |
|     1     |    1     |   37.50   |
|     1     |    2     |   44.44   |
|     1     |    3     |   40.20   |
|     1     |    10    |   60.00   |
|     2     |    4     |   35.10   |
|     2     |    7     |   60.00   |
|     2     |    8     |   93.60   |
|     3     |    5     |   40.00   |

#### Wytłumaczenie:

Obliczając średnią prędkość zastosowałam funkcję NULLIF(), która ma za zadanie sprawdzić, czy przypadkiem wartość nie będzie dzielona przez 0, co wywołałoby błąd. Wprawdzie pizzeria dostarcza pizzę przez swoich kurierów, jednakże warto przyjąć scenariusz, że ktoś zamówił z odbiorem własnym.

---

### 7. What is the successful delivery percentage for each runner?

_Jaki jest procent udanych dostaw dla każdego kuriera?_

```sql
SELECT
    runner_id,
    ((COUNT(order_id)::FLOAT - COUNT(cancellation)::FLOAT) / COUNT(order_id)::FLOAT) * 100 as delivered_percent
FROM runner_orders_temp
GROUP BY runner_id
ORDER BY runner_id;
```

#### Wynik zapytania/Odpowiedź:

| runner_id | delivered_percent |
| :-------: | :---------------: |
|     1     |        100        |
|     2     |        75         |
|     3     |        50         |

---

## Rozwiązanie: C. Ingredient Optimisation

### 1. What are the standard ingredients for each pizza?

_Jakie są standardowe składniki każdej pizzy?_

```sql
WITH toppings_cte as(
    SELECT
        pizza_id,
        STRING_TO_TABLE(toppings, ', ')::INTEGER as toppings_id
    FROM pizza_recipes
)

SELECT
    pizza_name,
    --toppings_id,
    STRING_AGG(topping_name, ', ') as ingredients_name
FROM toppings_cte
INNER JOIN pizza_names
    ON toppings_cte.pizza_id = pizza_names.pizza_id
INNER JOIN pizza_toppings
    ON toppings_cte.toppings_id = pizza_toppings.topping_id
GROUP BY pizza_name;
```

#### Proces:

Funkcja STRING_TO_TABLE() zamieniła łańcuch znaków zawarty w tabeli `pizza_recipes` w kolumnie `toppings` na nową tabelę, w której znajdowały się poszczególne id, które było można dopasować do tabeli `pizza_toppings` i wyciągnąć poszczególne składniki.</br>
Funkcja STRING_AGG() natomiast zamieniła wyciągnięte składniki i zamieniła je w łańcuch znaków, aby wynik był czytelny.

#### Wynik zapytania/Odpowiedź:

| pizza_name |                           ingredients_name                            |
| :--------: | :-------------------------------------------------------------------: |
| Meatlovers | Bacon, BBQ Sauce, Beef, Cheese, Chicken, Mushrooms, Pepperoni, Salami |
| Vegetarian |      Cheese, Mushrooms, Onions, Peppers, Tomatoes, Tomato Sauce       |

---

### 2. What was the most commonly added extra?

_Jaki był najczęściej wybierany dodatek?_

```sql
WITH toppings_cte as(
    SELECT
        order_id,
        STRING_TO_TABLE(extras, ', ')::INTEGER as toppings_id
    FROM customer_orders_temp
    WHERE extras IS NOT NULL
)

SELECT
    topping_name,
    COUNT(toppings_id) as how_many_added
FROM toppings_cte
INNER JOIN pizza_toppings
    ON toppings_cte.toppings_id = pizza_toppings.topping_id
GROUP BY topping_name
ORDER BY how_many_added DESC
-- LIMIT 1;
```

#### Wynik zapytania/Odpowiedź:

| topping_name | how_many_added |
| :----------: | :------------: |
|    Bacon     |       4        |
|   Chicken    |       1        |
|    Cheese    |       1        |

---

### 3. What was the most common exclusion?

_Co najczęściej było odrzucane?_

```sql
WITH toppings_cte as(
    SELECT
        order_id,
        STRING_TO_TABLE(exclusions, ', ')::INTEGER as toppings_id
    FROM customer_orders_temp
    WHERE exclusions IS NOT NULL
)

SELECT
    topping_name,
    COUNT(toppings_id) as how_many_removed
FROM toppings_cte
INNER JOIN pizza_toppings
    ON toppings_cte.toppings_id = pizza_toppings.topping_id
GROUP BY topping_name
ORDER BY how_many_removed DESC
-- LIMIT 1;
```

#### Wynik zapytania/Odpowiedź:

| topping_name | how_many_removed |
| :----------: | :--------------: |
|    Cheese    |        4         |
|  Mushrooms   |        1         |
|  BBQ Sauce   |        1         |

---

## Rozwiązanie: D. Pricing and Ratings

### 1. If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes - how much money has Pizza Runner made so far if there are no delivery fees?

_Jeśli pizza „Meat Lovers” kosztuje 12 dolarów, a wegetariańska 10 dolarów i nie pobiera się żadnych opłat za zmiany w zamówieniu – ile pieniędzy zarobiła dotychczas firma Pizza Runner, zakładając, że nie pobiera opłat za dostawę?_

```sql
SELECT
    SUM(
        CASE
            WHEN pizza_id = 1 THEN 12
            WHEN pizza_id = 2 THEN 10
            ELSE 0
        END
    ) as total_earnings
FROM customer_orders_temp
INNER JOIN runner_orders_temp
    ON customer_orders_temp.order_id = runner_orders_temp.order_id
WHERE cancellation IS NULL;
```

#### Wynik zapytania/Odpowiedź:

| total_earnings |
| :------------: |
|      138       |

---

### 2. What if there was an additional $1 charge for any pizza extras?

_A co, gdyby za każdy dodatkowy składnik do pizzy pobierano dodatkową opłatę w wysokości 1 dolara?_

```sql
WITH earnings_cte AS(
    SELECT
        SUM(
            CASE
                WHEN pizza_id = 1 THEN 12
                WHEN pizza_id = 2 THEN 10
                ELSE 0
            END
        ) as earnings_pizzas,
        SUM(
            CASE
                WHEN extras IS NULL THEN 0
                ELSE array_length(string_to_array(extras, ','), 1)
            END
        ) as earnings_extras
    FROM customer_orders_temp
    INNER JOIN runner_orders_temp
        ON customer_orders_temp.order_id = runner_orders_temp.order_id
    WHERE cancellation IS NULL
)

SELECT
    earnings_extras + earnings_pizzas as total_earnings
FROM earnings_cte;
```

#### Wynik zapytania/Odpowiedź:

| total_earnings |
| :------------: |
|      142       |

---
