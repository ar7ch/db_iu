create or replace function public.fetch_customers(start_customer_id integer, end_customer_id integer)
    returns table ( customer_id int,
                    first_name varchar,
                    second_name varchar,
                    address_id smallint)
    language plpgsql as 
    $f$
    begin
        if (start_customer_id not between 0 and 600) or (end_customer_id not between 0 and 600)  then
            raise 'arguments must be between 0 and 600';
        end if;
        return query 
            select c.customer_id, c.first_name, c.last_name, c.address_id
            from customer c
            where c.customer_id between start_customer_id and end_customer_id
            order by c.address_id;
    end
    $f$;
