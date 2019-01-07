-- 1a. Display the first and last names of actors from the table actor.alter

USE Sakila;

SELECT first_name, last_name FROM actor;

-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.

SELECT CONCAT(first_name, ' ', last_name) AS 'Actor Name' FROM actor;

-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?

SELECT actor_id, first_name, Last_name FROM actor
WHERE first_name = 'JOE';

-- 2b. Find all actors whose last name contain the letters GEN:

SELECT first_name, last_name, actor_id FROM actor
WHERE last_name LIKE '%GEN%';

-- 2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:

SELECT actor_id, first_name, last_name FROM actor
WHERE last_name LIKE '%LI%'
ORDER BY last_name, first_name;

-- 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:

SELECT country_id, country FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

-- 3a. You want to keep a description of each actor. You don't think you will be performing queries on a description,
-- so create a column in the table actor named description and use the data type BLOB (Make sure to research the type BLOB,
-- as the difference between it and VARCHAR are significant).

ALTER TABLE actor
ADD COLUMN description BLOB;

SELECT * from actor;

-- 3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the description column.

ALTER TABLE actor
DROP COLUMN description;

SELECT * from actor;

-- 4a. List the last names of actors, as well as how many actors have that last name.

SELECT last_name, COUNT(*) AS 'ln_count'
FROM actor
GROUP BY last_name
ORDER BY ln_count DESC;

-- 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors

SELECT last_name, COUNT(*) AS 'ln_count' FROM actor
GROUP BY last_name 
HAVING ln_count > 2
ORDER BY ln_count DESC;

-- 4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record.

UPDATE actor
SET first_name = 'HARPO'
WHERE first_name = 'GROUCHO' AND last_name = 'WILLIAMS';


SELECT first_name, last_name FROM actor
WHERE first_name = 'HARPO';

-- 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! In a single query,
-- if the first name of the actor is currently HARPO, change it to GROUCHO.

UPDATE actor
SET first_name = 'GROUCHO'
WHERE first_name = 'HARPO' AND last_name = 'WILLIAMS';

SELECT first_name, last_name FROM actor
WHERE first_name = 'GROUCHO';

-- 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?

DESCRIBE sakila.address;

-- 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:

SELECT s.first_name, s.last_name, a.address
FROM staff s LEFT JOIN address a ON s.address_id = a.address_id;

-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.

SELECT * FROM payment;

SELECT s.first_name, s.last_name, SUM(p.amount) AS 'total'
FROM staff s LEFT JOIN payment p ON s.staff_id = p.staff_id
GROUP BY first_name, last_name;

-- 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.

SELECT * FROM film;

SELECT f.title, COUNT(a.actor_id) AS 'total'
FROM film f LEFT JOIN film_actor a ON f.film_id = a.film_id
GROUP BY f.title;

-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?

SELECT f.title, COUNT(a.actor_id) AS 'total'
FROM film f LEFT JOIN film_actor a ON f.film_id = a.film_id
WHERE f.title = 'HUNCHBACK IMPOSSIBLE'
GROUP BY f.title;
-- ANSWER FOR 6d =  2

-- 6e. Using the tables payment and customer and the JOIN command, 
-- list the total paid by each customer. List the customers alphabetically by last name:

SELECT c.first_name, c.last_name, SUM(p.amount) AS 'total'
FROM customer c LEFT JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.first_name, c.last_name ORDER BY c.last_name;

-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence.
-- As an unintended consequence, films starting with the letters K and Q have also soared in popularity.
-- Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.

SELECT *  FROM film;

SELECT title FROM film
WHERE (title LIKE 'K%' OR title LIKE 'Q%') AND language_id = (SELECT language_id FROM language WHERE name = 'English');

-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.

SELECT first_name, last_name, actor_id
FROM actor WHERE actor_id IN (SELECT actor_id FROM film_actor wHERE film_id IN (SELECT film_id FROM film WHERE title = 'ALONE TRIP'));
                            
-- 7c. You want to run an email marketing campaign in Canada, for which you will need
-- the names and email addresses of all Canadian customers. Use joins to retrieve this information.

SELECT * FROM customer;
SELECT * FROM address;
SELECT * FROM city;
SELECT * FROM country;

SELECT first_name, last_name, email
FROM customer c JOIN address a ON (a.address_id = c.address_id)
JOIN city i ON (i.city_id = a.city_id)
JOIN country o ON (o.country_id = i.country_id)
WHERE country = 'Canada';

-- 7d. Sales have been lagging among young families,
-- and you wish to target all family movies for a promotion.
-- Identify all movies categorized as family films.

Select * FROM film_category;
SELECT * FROM category;

SELECT title FROM film f
JOIN film_category fc ON (fc.film_id = f.film_id)
JOIN category c ON (c.category_id = fc.category_id)
WHERE name = 'Family';

-- 7e. Display the most frequently rented movies in descending order.

SELECT * FROM film;
SELECT * FROM rental;
SELECT * FROM inventory;

SELECT title, COUNT(f.film_id) AS 'rented_frequency' FROM film f
JOIN inventory i ON (i.film_id = f.film_id)
JOIN rental r ON (r.inventory_id = i.inventory_id)
GROUP BY title ORDER BY rented_frequency DESC;

-- 7f. Write a query to display how much business, in dollars, each store brought in.

SELECT * FROM payment;
SELECT * FROM staff;

SELECT s.store_id, SUM(p.amount) AS 'revenue' FROM payment p
JOIN staff s ON (s.staff_id = p.staff_id)
GROUP BY store_id;

-- 7g. Write a query to display for each store its store ID, city, and country.

SELECT * FROM store;
SELECT * FROM address;
SELECT * FROM city;

SELECT store_id, city, country FROM store s
JOIN address a ON (a.address_id = s.address_id)
JOIN city c ON (c.city_id = a.city_id)
JOIN country o ON (o.country_id = c.country_id);

-- 7h. List the top five genres in gross revenue in descending order.
-- (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)

SELECT * FROM category;
SELECT * FROM film_category;
SELECT * FROM inventory;
SELECT * FROM payment;
SELECT * FROM rental;

SELECT c.name AS 'top_five', SUM(p.amount) AS 'revenue' FROM category c
JOIN film_category fc ON (fc.category_id = c.category_id)
JOIN inventory i ON (i.film_id = fc.film_id)
JOIN rental r ON (r.inventory_id = i.inventory_id)
JOIN payment p ON (p.rental_id = r.rental_id)
GROUP BY c.name ORDER BY revenue
LIMIT 5;

-- 8a. In your new role as an executive, you would like to have an easy way of
-- viewing the Top five genres by gross revenue. Use the solution from the problem
-- above to create a view. If you haven't solved 7h, you can substitute another query to create a view.

CREATE VIEW top_five AS
SELECT c.name AS 'top_five', SUM(p.amount) AS 'revenue' FROM category c
JOIN film_category fc ON (fc.category_id = c.category_id)
JOIN inventory i ON (i.film_id = fc.film_id)
JOIN rental r ON (r.inventory_id = i.inventory_id)
JOIN payment p ON (p.rental_id = r.rental_id)
GROUP BY c.name ORDER BY revenue
LIMIT 5;

-- 8b. How would you display the view that you created in 8a?

SELECT * FROM top_five;

-- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.

DROP VIEW top_five;

SELECT * FROM top_five;