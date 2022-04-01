-- schema

create table Author(
    author_id INTEGER PRIMARY KEY, 
    first_name VARCHAR(255), 
    last_name VARCHAR(255)
);

create table Book(
    book_id INTEGER PRIMARY KEY, 
    book_title VARCHAR(255), 
    month VARCHAR(255), 
    year INTEGER, 
    editor INTEGER,
    foreign key(editor) REFERENCES Author(author_id)
);

insert into author(author_id, first_name, last_name)
values (1, 'John', 'McCarthy'),
(2, 'Dennis', 'Ritchie'),
(3, 'Ken', 'Thompson'),
(4, 'Claude', 'Shannon'),
(5, 'Alan', 'Turing'),
(6, 'Alonzo', 'Church'),
(7, 'Perry', 'White'),
(8, 'Moshe', 'Vardi'),
(9, 'Roy', 'Batty');



insert into book(book_id, book_title, month, year, editor)
values (1, 'CACM', 'April', 1960, 8),
(2, 'CACM', 'July', 1974, 8),
(3, 'BTS', 'July', 1948, 2),
(4, 'MLS', 'November', 1936, 7),
(5, 'Mind', 'October', 1950, NULL),
(6, 'AMS', 'Month', 1941, NULL),
(7, 'AAAI', 'July', 2012, 9),
(8, 'NIPS', 'July', 2012, 9);

-- implement the following RA in SQL queries:

-- 1. get authors that are also editors of some book and these books
select *
from Author inner join Book on author_id = editor;


-- 2. get names of people who are authors are not also editors
-- (also there is a typo in a relation algebra expression, fixed it in query below)
select first_name, last_name
from 
    (select author_id from Author as tmp1 except select editor 
                       from Book) as tmp2 natural join Author;
                       
-- 3. get ids of authors that are not editors
select author_id from Author
except
select editor from Book

