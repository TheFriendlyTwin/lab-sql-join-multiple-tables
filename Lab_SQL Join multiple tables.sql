/* Lab | SQL Joins on multiple tables*/

/* Instructions
In this lab, you will be using the Sakila database of movie rentals.*/

-- 1. Write a query to display for each store its store ID, city, and country.
create temporary table if not exists sakila.store_details
select s.store_id, ci.city, co.country
from sakila.store s
join sakila.address a
on s.address_id = a.address_id
join sakila.city ci
on a.city_id = ci.city_id
join sakila.country co
on ci.country_id = co.country_id;

select * from sakila.store_details;

-- 2. Write a query to display how much business, in dollars, each store brought in.
/*
select s.store_id, sum(p.amount)
from sakila.store s
join sakila.staff st
on s.store_id = st.store_id
join sakila.payment p
on st.staff_id = p.staff_id
group by s.store_id;

select s.store_id, sum(p.amount)
from sakila.store s
join sakila.customer c
on s.store_id = c.store_id
join sakila.payment p
on c.customer_id = p.customer_id
group by s.store_id;
*/

create temporary table if not exists sakila.store_profit
select s.store_id, concat(sum(p.amount), '$') as 'profit'
from sakila.store s
join sakila.inventory i
on s.store_id = i.store_id
join sakila.rental r
on i.inventory_id = r.inventory_id
join sakila.payment p
on r.rental_id = p.rental_id
group by s.store_id;

select * from sakila.store_profit;

-- 3. What is the average running time of films by category?
create temporary table if not exists sakila.category_length_avg
select cat.name, avg(f.length) as 'average_running_time'
from sakila.category cat
join sakila.film_category f_cat
on cat.category_id = f_cat.category_id
join sakila.film f
on f_cat.film_id = f.film_id
group by cat.name
order by cat.name;

select * from sakila.category_length_avg;

-- 4. Which film categories are longest?
select max(average_running_time) from sakila.category_length_avg;

select name, average_running_time from sakila.category_length_avg
order by average_running_time desc;

-- 5. Display the most frequently rented movies in descending order.
select f.film_id, f.title, sum(r.rental_id) 'number_of_rentals'
from sakila.film f
join sakila.inventory i
on f.film_id = i.film_id
join sakila.rental r
on i.inventory_id = r.inventory_id
group by f.film_id, f.title
order by sum(r.rental_id) desc;

-- 6. List the top five genres in gross revenue in descending order.
select cat.name, sum(r.rental_id) 'gross_revenue'
from sakila.category cat
join sakila.film_category f_cat
on cat.category_id = f_cat.category_id
join sakila.film f
on f_cat.film_id = f.film_id
join sakila.inventory i
on f.film_id = i.film_id
join sakila.rental r
on i.inventory_id = r.inventory_id
group by cat.name
order by sum(r.rental_id) desc
limit 5;

-- 7. Is "Academy Dinosaur" available for rent from Store 1?
select s.store_id, f.film_id, f.title
from sakila.store s
join sakila.inventory i
on s.store_id = i.store_id
join sakila.film f
on i.film_id = f.film_id
where s.store_id = 1;
-- Yes, "Academy Dinosaur" is available for rent in Store 1.
