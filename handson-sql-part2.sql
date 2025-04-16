
-- ====================================================================================
-- 2 sql schema
-- ddl --
-- create table

CREATE TABLE IF NOT exists public.customer_tier (
    id SERIAL PRIMARY KEY, -- Use SERIAL for auto-incrementing ID
    tier_name VARCHAR(255) NOT NULL UNIQUE, -- Add a maximum length and ensure uniqueness
    create_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL, -- Default to current timestamp
    update_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL -- Default to current timestamp
);

-- Add/Drop Column
ALTER TABLE customer_tier ADD COLUMN description VARCHAR(255);
ALTER TABLE customer_tier DROP COLUMN update_timestamp;

-- Alter Data Type
ALTER TABLE customer_tier ALTER COLUMN id TYPE BIGINT;

-- Rename Column
ALTER TABLE customer_tier RENAME COLUMN tier_name TO tier_level;

-- Rename Table
ALTER TABLE customer_tier RENAME TO customer_tier_archive;
ALTER TABLE customer_tier_archive RENAME TO customer_tier;

-- Set/Drop NOT NULL
ALTER TABLE customer_tier ALTER COLUMN create_timestamp SET NOT NULL;
ALTER TABLE customer_tier ALTER COLUMN create_timestamp DROP NOT NULL;

-- Set Default
ALTER TABLE customer_tier ALTER COLUMN create_timestamp SET DEFAULT CURRENT_TIMESTAMP;

-- Add Constraint (Check)
ALTER TABLE customer_tier ADD CONSTRAINT tier_level_check CHECK (tier_level IN ('Bronze', 'Silver', 'Gold','Platinum'));

SELECT * FROM public.customer_tier;

-- Insert Data and Drop Constraint
INSERT INTO customer_tier (id,tier_level, create_timestamp, description) VALUES (3,'Bronze', CURRENT_TIMESTAMP, 'Testing');

ALTER TABLE customer_tier DROP CONSTRAINT tier_level_check;

INSERT INTO customer_tier (id, tier_level, create_timestamp) VALUES (4, 'Platinum', CURRENT_TIMESTAMP);

-- DML --
INSERT INTO customer_tier (id, tier_level, create_timestamp) VALUES (3, 'Silver', CURRENT_TIMESTAMP);

SELECT * FROM customer_tier;

UPDATE customer_tier SET tier_level = 'Bronze' WHERE id = 3;

DELETE FROM customer_tier WHERE tier_level = 'Diamond';

-- Add Unique Constraint
ALTER TABLE customer_tier ADD CONSTRAINT tier_level_unique UNIQUE (tier_level);

-- ====================================================================================
-- 3 function 
-- date()
-- i.e: date(timestamp_column)

SELECT DATE(rental_date) dates, * 
FROM public.rental

-- exract()
-- i.e: extract(date_part from date_column)

SELECT EXTRACT('minutes' FROM  rental_date) hours, * 
FROM public.rental

-- concat()
-- i.e: concat(first_column, second_column)

SELECT CONCAT(first_name, ' ', last_name), *
FROM public.customer;

-- string_agg()
-- i.e: concat(string_column, sep)

SELECT STRING_AGG(first_name, ',')
FROM public.customer
LIMIT 10

-- coalesce()
-- i.e: concat(string_column, sep)
SELECT rental_id, rental_date, customer_id, COALESCE(return_date, CURRENT_TIMESTAMP)
FROM public.rental
WHERE return_date IS NULL 

SELECT id, tier_level, COALESCE(description, tier_level)
FROM public.customer_tier
 
-- left()
-- i.e: left(string_column, num_character)

SELECT LEFT(tier_level, 1)
FROM public.customer_tier

-- right()
-- i.e: right(string_column, num_character)
SELECT RIGHT(tier_level, 1)
FROM public.customer_tier

-- length()
-- i.e: length(string_column)
SELECT length(tier_level)
FROM public.customer_tier

-- lower()
-- i.e: lower(string_column)
SELECT tier_level, INITCAP(tier_level)
FROM public.customer_tier

-- json_agg()
-- i.e: json_agg(string_column)
SELECT rating, JSON_AGG(title) AS list_film
FROM public.film
GROUP BY rating

-- i.e json_array_elements(json_columns)
SELECT json_array_elements(list_film) AS title
FROM (
  SELECT rating, JSON_AGG(title) AS list_film
  FROM public.film
  GROUP BY rating
) subquery
WHERE rating = 'PG-13';

WITH t_data AS (
SELECT *
FROM public.customer_tier
)

SELECT *
FROM t_data;

-- ====================================================================================
-- 4 store procedure
-- syntax SP
create [or replace] procedure procedure_name(parameter_list)
language plpgsql as $$
declare
-- variable declaration
begin
-- stored procedure body
end; $$;

-- EXAMPLE PROCEDURE
CREATE OR REPLACE PROCEDURE update_rental_rate(
    p_film_id INT, 
    p_new_rental_rate DECIMAL
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Update rental_rate and last_update for the given film_id
    UPDATE film
    SET rental_rate = p_new_rental_rate, 
        last_update = current_timestamp
    WHERE film_id = p_film_id;
    
    -- Optionally, you can raise a notice to confirm the update
    RAISE NOTICE 'Updated film_id % with new rental rate: %', p_film_id, p_new_rental_rate;
END;
$$;

-- USAGE PROCEDURE
CALL update_rental_rate(1, 3.99);

SELECT *
FROM public.film
WHERE film_id = 1

-- EXAMPLE FUNCTION
CREATE OR REPLACE FUNCTION convert_usd_to_idr(
    num1 DECIMAL
)
RETURNS DECIMAL AS $$
DECLARE
    kurs DECIMAL := 16.710;  -- Declare the kurs variable and initialize it
BEGIN
    RETURN num1 * kurs;  -- Multiply num1 by kurs and return the result
END;
$$ LANGUAGE plpgsql;

-- USAGE FUNCTION
SELECT title, rental_rate, convert_usd_to_idr(rental_rate) AS idr_rate
FROM public.film

-- Procedure CALL
-- for i in range(10):
-- SLJALKJSLAJL
--

-- ====================================================================================
-- 5 query optimization
-- revamp query --
-- never select data without where
select * from film; 
select * from film where release_year=2006 and language_id=1 and film_id > 500;

-- never select long range of data
select * from public.film where film_id between 1 and 2000000;
select * from public.film where film_id between 10 and 20;

-- never use select *
select * from film where release_year=2006 and language_id=1 and film_id > 500;
select film_id, title, description, release_year, rental_rate from film where release_year=2006 and language_id=1 and film_id > 500;

-- never use too many IN values
select * from public.film where film_id in (901, 902, 903, 904, 905, 906, 907, 908, 909, 910, 911, 912, 913, 914, 915, 3245,345,345,2,5,6,6,7,432,12,354);
select * from public.film where film_id in (901, 902, 903, 904);

-- never do processing data in the where filter
explain analyze select * from public.film where film_id + 3 < 2;
explain analyze select * from public.film where film_id < 2;
select * from public.film where film_id < 2000 - 3;

-- Execution Time: 0.035
-- Execution Time: 0.446 ms

-- index --
-- explain analyze
explain select COUNT(1) from public.film where release_year = 2001;
explain analyze select COUNT(1) from public.film where release_year = 2001;
explain analyze select * from public.film where mov_year = 2001;

-- testing index
explain analyze select * from public.rental where customer_id = 500;
create index rental_customer_id_idx on public.rental (customer_id);

explain analyze select * from public.rental where customer_id = 500;

-- testing partition --
-- Identify the partition column period
SELECT MIN(DATE(rental_date)), MAX(DATE(rental_date))
FROM public.rental;

-- Create Table (Partition)
CREATE TABLE public.rental_partitioned (
    rental_id INT,
    rental_date TIMESTAMP,
    inventory_id INT,
    customer_id INT,
    return_date TIMESTAMP,
    staff_id INT,
    last_update TIMESTAMP
) PARTITION BY RANGE (rental_date);

-- Create Partitions
CREATE TABLE public.rental_2005 PARTITION OF public.rental_partitioned
    FOR VALUES FROM ('2005-01-01') TO ('2006-01-01');
CREATE TABLE public.rental_2006 PARTITION OF public.rental_partitioned
    FOR VALUES FROM ('2006-01-01') TO ('2007-01-01');

-- Insert Values
INSERT INTO public.rental_partitioned (rental_id, rental_date, inventory_id, customer_id, return_date, staff_id, last_update)
SELECT rental_id, rental_date, inventory_id, customer_id, return_date, staff_id, last_update
FROM public.rental;

-- Check Data
select * from public.rental_partitioned where DATE(rental_date) = '2005-08-01';

-- Before Partition
explain analyze select * from public.rental where rental_date= '2005-09-01';
-- After Partition
explain analyze select * from public.rental_partitioned where rental_date = '2005-09-01';

SELECT *
FROM public.rental_partitioned

-- Manage partition
DROP TABLE public.rental_2005;  -- Drop the partition for 2005

explain analyze SELECT * FROM public.rental WHERE rental_id = 1000
-- ====================================================================================
-- 6 window function

-- In order to evaluate the performance and identify key customers for each staff member in our company, 
-- we need to find out which customers are contributing the most revenue in terms of total payments. 
-- This is important for business analysis to determine the most valuable clients for each staff member 
-- and possibly reward or engage them differentl

-- rank ()
WITH t_amount AS (
SELECT customer_id, staff_id, SUM(amount) total_amount
FROM payment
GROUP BY 1,2
)

SELECT * FROM (
SELECT *, RANK() OVER(PARTITION BY staff_id ORDER BY total_amount DESC) rk 
FROM t_amount)
WHERE rk < 10


-- row_number()
WITH t_amount AS (
SELECT customer_id, staff_id, SUM(amount) total_amount
FROM payment
GROUP BY 1,2
)

SELECT *, ROW_NUMBER() OVER( ORDER BY total_amount DESC)
FROM t_amount