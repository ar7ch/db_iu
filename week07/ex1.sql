drop table if exists orders, items, cities, customers, total_orders;
-- for ex1, atomic valued columns property already holds
-- relations below are in 3NF

--schema

create table items (
    itemId INT,
    itemName varchar(255) not null,
    primary key(itemId)
);

create table cities (
    cityId INT,
    primary key(cityId),
    cityName varchar(255)
);

create table customers (
    customerId INT,
    primary key(customerId),
    customerName varchar(255) not null,
    cityId INT not null,
    foreign key(cityId) references cities(cityId)
);
    
insert into cities(cityId, cityName) 
values (1, 'Prague'), (2, 'Madrid'), (3, 'Moscow');

insert into customers(customerId, customerName, cityId)
values (101, 'Martin', 1), (107, 'Herman', 2), (110, 'Pedro', 3);

insert into items(itemId, itemName)
values (3786, 'Net'), (4011, 'Racket'), (9132, 'Pack-3'), (5794, 'Pack-6'), (3141, 'Cover');

create table orders  ( 
    orderId INT not NULL,
    orderDate DATE not null,
    customerId INT not null,
    itemId INT not null,
    primary key (orderId, customerId, itemId),    
    quant INT not null,
    price DECIMAL(10,5) not null
);

-- fill data

insert into orders(orderId, orderDate, customerId, itemId, quant, price)
values(2301, TO_DATE('23/02/2011', 'DD/MM/YYYY'), 101,  3786, 3, 35.00),
(2301, TO_DATE('23/02/2011', 'DD/MM/YYYY'), 101,  4011, 6, 65.00),
(2301, TO_DATE('23/02/2011', 'DD/MM/YYYY'), 101,  9132, 8, 4.75),
(2302, TO_DATE('25/02/2011', 'DD/MM/YYYY'), 107,  5794, 4, 5.00),
(2303, TO_DATE('27/02/2011', 'DD/MM/YYYY'), 110,  4011, 2, 65.00),
(2303, TO_DATE('27/02/2011', 'DD/MM/YYYY'), 110,  3141, 2, 10.00);

-- 1. Calculate the total number of items per order and the total amount to pay for the order.
select customerId, orderId, sum(quant) as total_quant, sum(price) as total_price into temporary table total_orders
from orders
group by customerId, orderId
order by customerId, orderId;

-- 2. Obtain the customer whose purchase in terms of money has been greater than the others
select total_price, customerId, customerName, cityName from total_orders natural join customers natural join cities 
where total_price = (  
        select max(total_price)
        from total_orders
        );
