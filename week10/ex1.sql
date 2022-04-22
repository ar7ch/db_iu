drop table accounts;
drop table ledger;
-- create schema
create table accounts(
                         account_id serial not null primary key,
                         name text,
                         credit decimal (10,3) check (credit >= 0),
                         currency varchar(20)
);

-- fill table with data
insert into accounts(name, credit, currency)
values('John Doe', 2000, 'RUB'), ('Mary Sue', 1000, 'RUB'), ('Adam Smith', 3500, 'RUB');

-- add bank info
alter table accounts
    add column bankname varchar(100);

update accounts
set bankname = 'sberbank'
where account_id = 1 or account_id = 3;

update accounts
set bankname = 'tinkoff'
where account_id = 2;
--

-- add fee collector
insert into accounts(name, credit, currency)
values('Fee Collector', 0, 'RUB');
select * from accounts order by account_id;

-- add ledger
create table ledger(
                       id serial primary key,
                       from_id int,
                       to_id int,
                       fee decimal(10,3),
                       amount decimal(10,3),
                       trans_datetime timestamp with time zone default current_timestamp
);

-- improved procedure
create or replace procedure send_money(from_id int, to_id int, amount decimal)
    language plpgsql
as $$
begin
    --
    update accounts
    set credit = credit - amount
    where account_id = from_id;
    --
    update accounts
    set credit = credit + amount
    where account_id = to_id;
    --
end;
$$;


--drop procedure send_money_with_fee(from_id int, to_id int, amount numeric);
create or replace procedure send_money_with_fee(from_id int, to_id int, amount decimal)
    language plpgsql
as $$
declare
    bank_from varchar(100);
    bank_to varchar(100);
    fee_rate decimal(10,3) = 0.3;
    fee decimal(10,3);
    fee_collector_id int = 4;
begin
    --
    select fa.bankname into bank_from from accounts fa where fa.account_id = from_id;
    select ta.bankname into bank_to from accounts ta where ta.account_id = to_id;
    --
    if bank_from = bank_to then
        fee = 0;
    else
        fee = fee_rate * amount;
        amount = amount - fee;
        call send_money(from_id, fee_collector_id, fee);
        --
    end if;
    --
    call send_money(from_id, to_id, amount);
    insert into ledger(from_id, to_id, fee, amount) values(from_id, to_id, fee, amount);
end;
$$;


-- run transactions
begin transaction isolation level serializable;
savepoint _init;
call send_money_with_fee(1, 3, 500);
savepoint after_T1;
call send_money_with_fee(2, 1, 700);
savepoint after_T2;
call send_money_with_fee(2, 3, 100);
savepoint after_T3;
select account_id, credit from accounts order by account_id;
commit;
select * from ledger;
