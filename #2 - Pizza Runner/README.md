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
  - [1. How many pizzas were ordered?](#)
- [Rozwiązanie zapytań: B. Runner and Customer Experience](#rozwiązanie-zapytań)
- [Rozwiązanie zapytań: C. Ingredient Optimisation](#rozwiązanie-zapytań)
- [Rozwiązanie zapytań: D. Pricing and Ratings](#rozwiązanie-zapytań)
- [Pytania bonusowe](#pytania-dodatkowe)

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

</br></br></br></br></br></br></br></br></br></br></br></br>

### 1.

\_ \_

```sql

```

#### Proces:

#### Wynik zapytania/Odpowiedź:

#### Wytłumaczenie:

---
