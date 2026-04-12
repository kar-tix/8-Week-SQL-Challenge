<div align="center">

# Case Study #1 - Danny's Diner </br>

<img src="img/logo_case.png" alt="Logo case study 1" width="400" height="400">
</div>

## Spis treści

- [Opis](#opis)
- [Diagram relacji](#diagram-relacji)
- [Rozwiązanie zapytań](#rozwiązanie-zapytań)

## Opis

### Wprowadzenie

Danny w 2021 roku postanawia otworzyć japońską restaurację, która sprzedaje 3 potrawy: sushi, curry oraz ramen. Restauracja przechwyciła kilka podstawowych danych, ale nie wie, jak je wykorzystać.

### Problem

Danny chce wykorzystać dane, aby odpowiedzieć na kilka prostych pytań dotyczących swoich klientów, aby polepszyć stosunki ze stałymi klientami oraz zapewnić im lepsze doświadczenia z jedzeniem.

Informacje te chce wykorzystać, aby podjąć kilka decyzji biznesowych jak chociażby rozszerzenie programu lojalnościowego.

## Diagram relacji

Przez wzgląd na zachowanie poufności Danny dostarczył próbkę ogólnych danych o swoich klientach i zamówieniach.

Udostępnił 3 kluczowe zbiory danych: sales, menu oraz members.

<img src="img/diagram.png" alt="Diagram relacji" width="50%" height="50%">

## Rozwiązanie zapytań

### 1. What is the total amount each customer spent at the restaurant?

_Jaka była całkowita kwota, jaką każdy klient wydał w restauracji?_

```sql
SELECT
    sales.customer_id AS customer,
    SUM(menu.price) AS total_amount
FROM sales
INNER JOIN menu
    ON sales.product_id = menu.product_id
GROUP BY customer
ORDER BY customer;
```

#### Proces:

- połączone zostały tabele "sales" oraz "menu"
- za pomocą funkcji SUM() zsumowano koszt dla każdego klienta
- wynik został pogrupowany według ID klienta

#### Wynik zapytania/Odpowiedź:

| customer | total_amount |
| :------: | :----------: |
|    A     |      76      |
|    B     |      74      |
|    C     |      36      |

### 2. How many days has each customer visited the restaurant?

_Przez ile dni każdy klient odwiedzał restaurację?_

```sql
SELECT
    sales.customer_id as customer,
    COUNT(DISTINCT sales.order_date) as count_date
FROM sales
GROUP BY customer
ORDER BY customer;
```

#### Proces:

- za pomocą DISTINCT wybierane są tylko unikatowe daty zamówienia
- funkcja COUNT() oblicza ile razy wystąpiła data
- wyniki pogrupowane zostały według klientów

#### Wynik zapytania/Odpowiedź:

| customer | count_date |
| :------: | :--------: |
|    A     |     4      |
|    B     |     6      |
|    C     |     2      |

### 3. What was the first item from the menu purchased by each customer?

_Co było pierwszą pozycją z menu zakupioną przez każdego klienta?_

```sql
WITH rank_sales AS(
    SELECT
        sales.customer_id as customer,
        sales.order_date as order_date,
        menu.product_name as product,
        DENSE_RANK() OVER
            (PARTITION BY customer_id
            ORDER BY  order_date) as rank_item
    FROM sales
    INNER JOIN menu
        ON menu.product_id = sales.product_id
)

SELECT
    customer,
    product
FROM rank_sales
WHERE rank_item = 1
GROUP BY customer, product
ORDER BY customer;
```

#### Proces:

- stworzone zostało CTE (ang. Common Table Expression), w którym zastosowano funkcję DENSE_RANK(), która numeruje kolejne wiersze patrząc na datę zamówienia (powtarzajace się wartości moją ten sam numer), a dzięki PARTITION BY dane zostały dodatkowo pogrupowane według klientów
- w głównym zapytaniu ustawiono warunek rank_item, aby wyświetlić tylko pierwsze zamówienia

#### Wynik zapytania/Odpowiedź:

| customer | product |
| :------: | :-----: |
|    A     |  curry  |
|    A     |  sushi  |
|    B     |  curry  |
|    C     |  ramen  |

#### Wytłumaczenie:

Zastosowano funkcję DENSE_RANK() zamiast ROW_NUMBER, ponieważ istniała możliwość - i taka właśnie się pojawiła - że będą wartości posiadające tę samą datę. Niestety dokładny czas zamówienia nie jest podany, więc aby zapewnić wiarygodność danych dla klienta A zostały podane obie opcje, ponieważ nie wiadomo, co pierwsze zostało zamówione.
