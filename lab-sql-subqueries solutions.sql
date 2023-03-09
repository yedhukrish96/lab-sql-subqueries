USE sakila;

#1- 
#How many copies of the film Hunchback Impossible exist in the inventory system?

SELECT * FROM inventory;
SELECT * FROM film;


SELECT COUNT(*) AS total_copies
FROM inventory
INNER JOIN film
ON inventory.film_id = film.film_id
WHERE film.title = 'Hunchback Impossible';


#2-
#List all films whose length is longer than the average of all the films.

SELECT * FROM film;

SELECT title,length
FROM film
WHERE length > (SELECT AVG(length)
                FROM film);
             
             
#3- 
#Use subqueries to display all actors who appear in the film Alone Trip.-
SELECT * FROM film;
SELECT * FROM actor;
SELECT * FROM film_actor;

SELECT first_name,last_name
FROM actor
WHERE actor.actor_id IN
     (SELECT film_actor.actor_id
      FROM film_actor
      JOIN film on film.film_id = film_actor.film_id
      WHERE film.title = 'Alone Trip');
      
#4- 
#Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized 
#as family films.

SELECT * FROM category;    -- '8' is the category for family films.
SELECT * FROM film_category;  -- Have to find the category id '8' and link with film_id.
SELECT * FROM film;       -- connect film_id to title and then you get the name of the films.



SELECT title
FROM film
WHERE film_id IN (SELECT film_id
                      FROM film_category
                      WHERE category_id = (SELECT category_id
                                           FROM category
                                           WHERE category.name = 'Family')
                      );
             







#5-
#Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join, you will have to 
#identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.

SELECT * FROM customer;
SELECT * FROM address;
SELECT * FROM city;
SELECT * FROM country;

-- Using Joins-
SELECT c.first_name,c.last_name,c.email
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN city ct on a.city_id = ct.city_id
JOIN country co on ct.country_id = co.country_id
WHERE co.country = 'Canada';


-- Using subqueries-
SELECT first_name,last_name,email 
FROM customer 
WHERE address_id IN (
  SELECT address_id
  FROM address 
  WHERE city_id IN (
    SELECT city_id 
    FROM city 
    WHERE country_id IN (
      SELECT country_id
      FROM country 
      WHERE country = 'Canada'
    )
  )
);


#6-
#Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. First you will have to find 
#the most prolific actor and then use that actor_id to find the different films that he/she starred.

SELECT * FROM film_actor;
SELECT * FROM film;

                              
                              
                              
SELECT title
FROM film
JOIN film_actor ON film.film_id = film_actor.film_id
JOIN (
    SELECT actor_id, COUNT(*) AS film_count
    FROM film_actor
    GROUP BY actor_id
    ORDER BY film_count DESC
    LIMIT 1
)AS actor_films ON film_actor.actor_id = actor_films.actor_id;


#7-
#Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer ie the
#customer that has made the largest sum of payments

SELECT * FROM customer;
SELECT * FROM payment;


SELECT DISTINCT film.title
FROM film
JOIN inventory ON film.film_id = inventory.film_id
JOIN rental ON inventory.inventory_id = rental.inventory_id
JOIN payment ON rental.rental_id = payment.rental_id
JOIN (
    SELECT customer_id, SUM(amount) AS total_payments
    FROM payment
    GROUP BY customer_id
    ORDER BY total_payments DESC
    LIMIT 1
) AS top_customer ON payment.customer_id = top_customer.customer_id
ORDER BY film.title ASC;


#8-
#Customers who spent more than the average payments.
SELECT customer.customer_id, customer.first_name, customer.last_name, SUM(payment.amount) AS total_payments
FROM customer
JOIN payment ON customer.customer_id = payment.customer_id
GROUP BY customer.customer_id
HAVING SUM(payment.amount) > (SELECT AVG(total_payments) FROM (SELECT SUM(amount) AS total_payments FROM payment GROUP BY customer_id) AS payments)
ORDER BY total_payments DESC;
