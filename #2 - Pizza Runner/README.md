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

2. Stworzenie tabeli tymczasowej

```sql
CREATE TEMP TABLE customer_orders_temp AS
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
CREATE TEMP TABLE runner_orders_temp AS
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

```

#### Proces:

#### Wynik zapytania/Odpowiedź:

#### Wytłumaczenie:

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
