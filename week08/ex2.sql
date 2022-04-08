-- query 1

select f.film_id, f.title, c.name as genre, f.rating
    from film f inner join film_category fc 
                        on f.film_id = fc.film_id 
                inner join category c 
                        on (fc.category_id = c.category_id and c.name = 'Horror' or c.name = 'Sci-Fi')
    where 
        rating = 'R' or rating = 'PG-13' 
        and f.film_id not in (select f2.film_id 
                                from inventory i inner join film f2 
                                    on i.film_id = f2.film_id)


-- query 2
select t.city_id, t.store_id, max(t.total_amount)
    from 
        (select a.city_id as city_id, s.store_id as store_id, sum(p.amount) as total_amount
        from 
            store s inner join customer c 
                on s.store_id = c.store_id 
            inner join payment p 
                on p.customer_id = c.customer_id
            inner join address a 
                on s.address_id = a.address_id
        where 
            to_date('020107', 'MMDDYY') < p.payment_date and 
            p.payment_date < TO_DATE('030107', 'MMDDYY')
        group by s.store_id, a.city_id) as t
group by t.city_id, t.store_id 

-- the most expensive part is linear search while joining on id match;
-- we could improve it using indexes for foreign keys (store id in customer for example)
