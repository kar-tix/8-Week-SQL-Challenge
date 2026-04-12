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

<img src="img/diagram.png" alt="Diagram relacji" width="80%" height="80%">

## Rozwiązanie zapytań

**1. What is the total amount each customer spent at the restaurant?**
</br> _Jaka była całkowita kwota, jaką każdy klient wydał w restauracji?_

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

#### Rezultat:

| customer | total_amount |
| :------: | :----------: |
|    A     |      76      |
|    B     |      74      |
|    C     |      36      |
