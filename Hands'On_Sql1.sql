-- ====================================================================================
-- BASIC SELECT --

-- #H1 Select all data
SELECT *
FROM public.customer c ;

-- #H2 Select customer_id, first_name, last_name columns from tracks
SELECT customer_id, first_name, last_name, email 
FROM public.customer c ;

-- #H3 Select customer_id, first_name, last_name columns from tracks
SELECT customer_id, first_name, last_name, create_date 
FROM public.customer c ;

-- #H4 Find unique compose
SELECT DISTINCT first_name
FROM public.customer c;

-- EXERCISE ---
-- #INSTRUCTION
-- 1. Write a query to retrieve all columns from the `film` table.
--    Make sure to use the `SELECT *` syntax.
-- QUERY HERE!
SELECT * FROM public.film;

-- #INSTRUCTION
-- 2. Write a query to retrieve the film title, description, and release year for all films.
--    from the `customer` table.
-- QUERY HERE!
SELECT title, description, release_year
FROM public.film; 

-- #INSTRUCTION
-- 3. Write a query to retrieve distinct values of the `last_name` column from the `customer` table.
-- QUERY HERE!
SELECT DISTINCT last_name
FROM public.customer;

-- ====================================================================================
-- WHERE CLAUSE -- 

-- #H4 Find the customer_id and address_id columns for the customer whose email is 'susan.wilson@sakilacustomer.org' in the customer table.
SELECT *
FROM public.customer c
WHERE email = 'susan.wilson@sakilacustomer.org' ;

-- #H5 Retrieve the customer_id, first_name, last_name, and email columns from the customer table for customers 
-- whose customer_id is less than or equal to 5.
SELECT customer_id, first_name, last_name, active, email
FROM public.customer c
WHERE customer_id <= 5 ;

-- #H6 Retrieve the customer_id, first_name, last_name, active status, and email columns from the customer table 
-- for customers whose email addresses contain the word 'kelly'."
SELECT customer_id, first_name, last_name, active, email 
FROM public.customer c
WHERE email LIKE '%davis%' ;

-- #H7 Retrieve the customer_id, first_name, last_name, active status, and email columns from the customer table 
-- for customers whose customer_id is between 20 and 40 (inclusive)."
SELECT customer_id, first_name, last_name, active, email
FROM public.customer c
WHERE customer_id BETWEEN 20 AND 40;

-- #H8 Retrieve the customer_id, first_name, last_name, active status, and email columns from the customer table 
-- for customers who are associated with store 1.
SELECT customer_id, first_name, last_name, active, email
FROM public.customer c
WHERE store_id in (1) ;

-- #H9 Retrieve the customer_id, first_name, last_name, active status, and email columns from the customer table 
-- for customers who do not have an email address (i.e., where the email is NULL).
SELECT customer_id, first_name, last_name, active, email
FROM public.customer c
WHERE email IS NULL ;

-- #H9 Retrieve the customer_id, first_name, last_name, active status, and email columns from the customer table 
-- for customers whose email is not NULL and whose customer_id is between 10 and 30 (inclusive)
SELECT customer_id, first_name, last_name, active, email
FROM public.customer c
WHERE email IS NOT NULL 
AND customer_id BETWEEN 10 AND 30;

-- EXERCISE ---
-- #INSTRUCTION
-- 1. Write a query to retrieve the `customer_id` and `address_id` columns for the customer 
--    whose email is 'wesley.bull@sakilacustomer.org.
-- QUERY HERE!
SELECT customer_id, addres_id
FROM public.customer
WHERE email = 'wesley.bull@sakilacustomer.org';
--WHERE email LIKE 'wesley.bull@sakilacustomer.org'
--WHERE email IN ('wesley.bull@sakilacustomer.org');

-- #INSTRUCTION
-- 2. Write a query to find all films with a rental rate greater than 15.00.
-- QUERY HERE!
SELECT *
FROM public.film
WHERE rental_rate > 15.00;

-- #INSTRUCTION
-- 3. Write a query to retrieve the `customer_id`, `first_name`, `last_name`, `active`, and `email` columns 
--    for customers whose email addresses contain the word 'terry'.
-- QUERY HERE!
SELECT customer_id, first_name, last_name, active, email
FROM public.customer
WHERE email LIKE '%terry%';

-- #INSTRUCTION
-- 4. Write a query to retrieve the `customer_id`, `first_name`, `last_name`, `active`, and `email` columns 
--    for customers whose `customer_id` is between 100 and 200 (inclusive).
-- QUERY HERE!
SELECT customer_id, first_name, last_name, active, email
FROM public.customer 
WHERE customer_id BETWEEN 100 AND 200; --(INTEGER)
--WHERE customer_id BETWEEN '100 AND 200'; (STRING)

-- #INSTRUCTION
-- 5. Write a query to retrieve the `customer_id`, `first_name`, `last_name`, `active`, and `email` columns 
--    for customers who are associated with store_id 2 .
-- QUERY HERE!
 SELECT customer_id, first_name, last_name, active, email
 FROM public.customer
 WHERE store_id = 2;

-- #INSTRUCTION
-- 6. Write a query to retrieve the `customer_id`, `first_name`, `last_name`, `active`, and `email` columns 
--    for customers who do not have an email address (i.e., where the store_id is NULL).
-- QUERY HERE!
SELECT customer_id, first_name, last_name, active, email
FROM public.customer
WHERE email IS NULL;

-- #INSTRUCTION
-- 7. Write a query to retrieve the `customer_id`, `first_name`, `last_name`, `active`, and `email` columns 
--    for customers whose stpre is not NULL and whose `customer_id` is between 50 and 70 (inclusive).
-- QUERY HERE!
SELECT customer_id, first_name, last_name, active, email
FROM public.customer
WHERE store_id IS NOT NULL AND customer_id BETWEEN 50 AND 70;

-- ====================================================================================
-- AGGREGATE FUNCTIONS -- 

-- #H10 Find the total number of customers (COUNT) in each store (store_id) from the customer table.
SELECT store_id, COUNT(customer_id) AS total_customers
FROM public.customer
GROUP BY store_id;

-- #H11 Find the average (AVG) number of customers per store (store_id) from the customer table, but only for stores that have more than 5 customers."
SELECT store_id, AVG(customer_id) AS avg_customers
FROM public.customer
GROUP BY store_id
HAVING COUNT(customer_id) > 300;

-- EXERCISE ---
--#INSTRUCTION
-- 1. Find the total number of films (COUNT) in the film table where the film was released on 2021.
--QUERY HERE!
SELECT COUNT(release_year)
FROM public.film
WHERE release_year = '2006'
GROUP BY release_year;
 
--#INSTRUCTION
-- 2. Find the daily average (AVG) amount of payment, but only for customers who has their account created after 1 Dec 2024.
--QUERY HERE!
--SELECT COUNT (return_data), COUNT(1), COUNT(*)
--FROM public.customer;

SELECT AVG(a.amount) average_payment
FROM public.payment a
JOIN public.customer b ON a.customer_id = b.customer_id
WHERE b.create_date > '2024-12-01'
GROUP BY a.customer_id

-- ====================================================================================
-- CONDITIONAL STATEMENT -- 

-- Categorize customers into 5 clusters based on their customer_id. The clusters should be defined as follows:
-- Cluster 1: customer_id between 1 and 100
-- Cluster 2: customer_id between 101 and 200
-- Cluster 3: customer_id between 201 and 300
-- Cluster 4: customer_id between 301 and 400
-- Cluster 5: customer_id greater than 500"
SELECT customer_id, first_name, last_name, active, email,
       CASE 
           WHEN customer_id BETWEEN 1 AND 100 THEN 'Cluster 1'
           WHEN customer_id BETWEEN 101 AND 200 THEN 'Cluster 2'
           WHEN customer_id BETWEEN 201 AND 300 THEN 'Cluster 3'
           WHEN customer_id BETWEEN 301 AND 400 THEN 'Cluster 4'
           WHEN customer_id > 500 THEN 'Cluster 5'
           ELSE 'Other' -- For customer_id <= 500 but not in the specified range
       END AS customer_cluster
FROM public.customer;

-- EXERCISE ---
--#INSTRUCTION

-- EXERCISE ---
--#INSTRUCTION
-- Categorize film ratings into 4 categories:
-- "Teenager" : films with ratings PG
-- "Young Adult" : films with ratings G
-- "Adult": films with ratings NC
-- "All Ages": film with rating PG
--QUERY HERE!

SELECT title,rating,
CASE
 WHEN rating LIKE 'PG%' THEN 'Teenager'
 WHEN rating LIKE 'G' THEN 'Young Adult'
 WHEN rating LIKE 'NC%' THEN 'Adult'
 WHEN rating LIKE 'G' THEN 'All Ages'
 ELSE 'Other'
END AS rating_category
FROM public.film;

--SELECT *
--FROM public.film f
--LEFT JOIN public.film_category fc ON f.film_id = fc.film_id
--LEFT JOIN public.category c ON fc.category_id = c.category_id;

-- ====================================================================================
-- SQL JOIN -- 

-- Retrieve all customers along with their associated address information. If a customer does not have an associated address, the address fields should be NULL
SELECT c.customer_id, c.first_name, c.last_name, a.address, a.district, a.city_id, a.postal_code
FROM public.customer c
LEFT JOIN public.address a ON c.address_id = a.address_id;

-- Retrieve the details of customers along with the store they are associated with. Only include customers who are linked to store_id = 1.
SELECT c.customer_id, c.first_name, c.last_name, s.store_id, s.manager_staff_id, s.address_id
FROM public.customer c
INNER JOIN public.store s ON c.store_id = s.store_id AND s.store_id = 1;

-- Create a Cartesian product of all customers and all stores. This will show all possible combinations of customers and stores
SELECT c.customer_id, c.first_name, s.store_id, s.manager_staff_id, s.address_id
FROM public.customer c
CROSS JOIN public.store s;

-- EXERCISE ---
--#INSTRUCTION
--1. Write a query to join the film and film_category tables to show the category name for each film.
--QUERY HERE!
SELECT *
FROM public.film f
LEFT JOIN public.film_category fc ON f.film_id = fc.film_id
LEFT JOIN public.category c ON fc.category_id = c.category_id

--#INSTRUCTION
--2.Join the rental, inventory, and film tables to show the film title, rental duration, and customer name for each rental.
--QUERY HERE!
SELECT f.title, r.rental_date - r.rental_date, c.first_name, c.last_name
FROM public.rental r
LEFT JOIN public.iventory i ON r.inventory_id = i.inventory_id
LEFT JOIN public.film ON i.film_id = f.film_id
LEFT JOIN public.customer c ON r.customer_id = c.customer_id
WHERE 1=1
AND return_date IS NOT NULL;

--#INSTRUCTION
--3.Join the film, film_actor, and actor tables to show the film title and all actors who have appeared in that film.
--QUERY HERE!
SELECT f.title, a.first_name || ' ' ||a.last_name AS actor_name
FROM public.film f
LEFT JOIN public.film_actor fa ON fa.film_id = f.film_id
LEFT JOIN public.actor a ON fa.actor_id = a.actor_id
ORDERY BY 1;

-- ====================================================================================
-- UNION STATEMENT -- 

-- Retrieve a list of first_name from the customer table and a list of first_name from the actor table. Combine both lists into a single result set."
SELECT first_name || ' ' || last_name AS name, 'customer' AS type
FROM public.customer
UNION
SELECT first_name || ' ' || last_name AS name, 'actor' AS type 
FROM public.actor;

---- EXERCISE ---
--#INSTRUCTION
-- Combine data from the customer, staff, and actor tables into a single result set.
--QUERY HERE!
SELECT 
    customer_id AS id,
    first_name,
    last_name
FROM 
    customer

UNION

SELECT 
    staff_id AS id,
    first_name,
    last_name
FROM 
    staff

UNION

SELECT 
    actor_id AS id,
    first_name,
    last_name
FROM 
    actor;

-- ====================================================================================
-- SUBQUERY  -- 

-- Combine data from the customer and actor tables into a single result set. For each record, create a new column is_customer 
-- that indicates whether the record belongs to a customer (1) or not (0). Additionally, merge the first_name and last_name columns into a single name column 
-- and assign a type label ('customer' or 'actor') based on the source table.

SELECT *, CASE WHEN type ='customer' THEN 1 ELSE 0 END AS is_customer
FROM (
    SELECT customer_id AS id, first_name || ' ' || last_name AS name, 'customer' AS type
    FROM public.customer
    UNION
    SELECT actor_id AS id, first_name || ' ' || last_name AS name, 'actor' AS type 
    FROM public.actor
) x ;

-- EXERCISE ---
--#INSTRUCTION
-- Combine data from the customer, staff, and actor tables into a single result set. For each record, create a new column is_customer 
-- that indicates whether the record belongs to a actor (1) or not (0). Additionally, merge the first_name and last_name columns into a single name column 
-- and assign a type label ('customer', 'actor', or 'staff) based on the source table.
--QUERY HERE!
SELECT *
FROM (
    SELECT 
        customer_id AS id,
        CONCAT(first_name, ' ', last_name) AS name,
        0 AS is_customer,
        'customer' AS type
    FROM customer

    UNION ALL

    SELECT 
        staff_id AS id,
        CONCAT(first_name, ' ', last_name) AS name,
        0 AS is_customer,
        'staff' AS type
    FROM staff

    UNION ALL

    SELECT 
        actor_id AS id,
        CONCAT(first_name, ' ', last_name) AS name,
        1 AS is_customer,
        'actor' AS type
    FROM actor
) AS combined_data;



-- ====================================================================================
-- OTHER QUERY  -- 

SELECT *, CASE WHEN type ='customer' THEN 1 ELSE 0 END AS is_customer
FROM (
    SELECT customer_id AS id, first_name || ' ' || last_name AS name, 'customer' AS type
    FROM public.customer
    UNION
    SELECT actor_id AS id, first_name || ' ' || last_name AS name, 'actor' AS type 
    FROM public.actor
) x 
ORDER BY id ASC, name ASC
LIMIT 10
;
