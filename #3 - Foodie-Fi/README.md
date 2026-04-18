<div align="center">

# Case Study #3 - Foodie-Fi </br>

<img src="img/logo_case.png" alt="Logo case study 2" width="500" height="500">
</div>

## 💡 Informacje

W folderze _solutions_ znajdują się pliki z rozwiązaniami w SQL.</br>
Do wykonania wykorzystany został SQL oraz PostgreSQL.</br>
Szczegółowe informacje dotyczące tego studium przypadku znajdują się [tutaj](https://8weeksqlchallenge.com/case-study-3/).

## 📋 Spis treści

- [Opis](#opis)
- [Diagram relacji](#diagram-relacji)
- [Rozwiązanie: A. Customer Journey](#a-customer-journey)
- [Rozwiązanie: B. Data Analysis Questions](#b-data-analysis-questions)

## 🔍 Opis

### Wprowadzenie

Danny stworzył platformę streamingową Foodie-Fi, która oferuje programy związane tylko z jedzeniem - coś jak Netflix, ale tylko z programami o gotowaniu.</br>
Platforma powstała w 2020 roku i zaoferowała miesięczne i roczne subskrypcje, dając swoim klientom nieograniczony dostęp do ekskluzywnych treści.

### Problem

Danny chce wszystkie przyszłe decyzje oprzeć na danych. To studium przypadku koncentruje się na wykorzystaniu danych cyfrowych w stylu subskrypcji, aby odpowiedzieć na ważne pytania biznesowe.

## 📈 Diagram relacji

<div align=center>
<img src="img/diagram.png" alt="Diagram relacji" width="80%" height="80%">
</div>

Tabela 1: plans

| plan_id | plan_name | price |
| :---: | :---: | :---: |
| 0 | trial | 0.00 |
| 1 | basic monthly | 9.90 |
| 2 | pro monthly | 19.90 |
| 3 | pro annual | 199.00 |
| 4 | churn | NULL |


Tabela 2: subscriptions

| customer_id | plan_id | start_date |
| :---: | :---: | :---: |
| 1 | 0 | 2020-08-01 |
| 1 | 1 | 2020-08-08 |
| 2 | 0 | 2020-09-20 |
| 2 | 3 | 2020-09-27 |
| 3 | 0 | 2020-01-13 |

Powyżej przykładowe dane z tabeli `subscriptions`.
</br>

## A. Customer Journey

Based off the 8 sample customers provided in the sample from the subscriptions table, write a brief description about each customer’s onboarding journey.

_Na podstawie 8 przykładowych klientów z tabeli „subscriptions” napisz krótki opis ścieżki wdrożenia każdego z nich._

```sql
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
```

Powyższy kod jest uniwersalny i za każdym razem wygeneruje innych 8-u klientów.

#### Przykładowy wynik zapytania:
| customer | plan_name | start_date |
| :---: | :---: | :---: |
| 10 | trial | 2020-09-19 |
| 10 | pro monthly | 2020-09-26 |
| 20 | trial | 2020-04-08 |
| 20 | basic monthly | 2020-04-15 |
| 20 | pro annual | 2020-06-05 |
| 42 | trial | 2020-10-27 |
| 42 | basic monthly | 2020-11-03 |
| 42 | pro monthly | 2021-04-28 |
| 190 | trial | 2020-04-20 |
| 190 | basic monthly | 2020-04-27 |
| 190 | pro annual | 2020-09-04 |
| 547 | trial | 2020-03-05 |
| 547 | basic monthly | 2020-03-12 |
| 547 | pro annual | 2020-08-24 |
| 646 | trial | 2020-02-28 |
| 646 | basic monthly | 2020-03-06 |
| 717 | trial | 2020-01-08 |
| 717 | pro monthly | 2020-01-15 |
| 717 | pro annual | 2020-06-15 |
| 980 | trial | 2020-06-12 |
| 980 | pro monthly | 2020-06-19 |

#### Odpowiedź: 
- Wszyscy przykładowi klienci rozpoczęli od darmowej wersji próbnej, nie od razu przeszli na płatne plany.
- W większości przypadków po okresie próbnym użytkownicy przechodzili na plan podstawowy, dopiero w późniejszym czasie ewentualnie zakupili lepsze subskrypcje. Wyjątek stanowią użytkownicy o ID 10, 717 i 980, którzy po okresie próbnym od razu przeszli na plan PRO.
- Żaden z klientów nie zmniejszył planu lub zrezygnował z subskrypcji.

---
</br>

## B. Data Analysis Questions

### 1. How many customers has Foodie-Fi ever had?

_Ilu klientów miało kiedykolwiek Foodie-Fi?_

```sql
SELECT
    COUNT(DISTINCT customer_id) as unique_customers
FROM subscriptions;
```
=
#### Wynik zapytania/Odpowiedź:
| unique_customers |
| :---: |
| 1000 |

---

### 2. What is the monthly distribution of trial plan start_date values for our dataset - use the start of the month as the group by value

*Jaki jest miesięczny rozkład wartości start_date planu próbnego dla naszego zestawu danych - jako wartość grupowania należy użyć początku miesiąca*

```sql
SELECT
    DATE_TRUNC('month', start_date)::DATE as start_trial,
    COUNT(customer_id) as trial_subs
FROM subscriptions
WHERE plan_id = 0
GROUP BY DATE_TRUNC('month', start_date)
ORDER BY start_trial;
```


#### Wynik zapytania/Odpowiedź:
| start_trial | trial_subs |
| :---: | :---: |
| 2020-01-01 | 88 |
| 2020-02-01 | 68 |
| 2020-03-01 | 94 |
| 2020-04-01 | 81 |
| 2020-05-01 | 88 |
| 2020-06-01 | 79 |
| 2020-07-01 | 89 |
| 2020-08-01 | 88 |
| 2020-09-01 | 87 |
| 2020-10-01 | 79 |
| 2020-11-01 | 75 |
| 2020-12-01 | 84 |

---

### 3. What plan start_date values occur after the year 2020 for our dataset? Show the breakdown by count of events for each plan_name

*Jakie wartości start_date występują w naszym zbiorze danych po roku 2020? Pokaż podział według liczby zdarzeń dla każdej nazwy_planu*

```sql
SELECT
    plan_name,
    COUNT(customer_id) as events_num
FROM plans
INNER JOIN subscriptions
    ON plans.plan_id = subscriptions.plan_id
WHERE start_date >= '2021-01-01'
GROUP BY plan_name;
```

#### Proces:
| plan_name | events_num |
| :---: | :---: |
| pro annual | 63 |
| churn | 71 |
| pro monthly | 60 |
| basic monthly | 8 |

#### Wynik zapytania/Odpowiedź:


---









</br></br></br></br></br></br></br></br>

### 1. 

__

```sql

```

#### Proces:


#### Wynik zapytania/Odpowiedź:


---