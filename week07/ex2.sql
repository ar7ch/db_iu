
-- ex2, normalized to 3NF

drop table if exists publisher, book, school, course, loan, teacher, room;

-- schema

CREATE TABLE publisher (
    publisherId serial,
    primary key (publisherId),
    publisherName varchar(255) NOT NULL
);

CREATE table book (
    bookId serial not null,
    primary key(bookId),
    bookName varchar(255) not null,
    publisherId int not null,
    FOREIGN KEY (publisherId) references publisher(publisherId)
);

CREATE TABLE school (
    schoolId serial not null primary key,
    schoolName varchar(255) not null
);

CREATE TABLE room (
    roomId serial NOT NULL PRIMARY KEY,
    roomName varchar(255) NOT NULL
);

CREATE TABLE teacher (
    teacherId serial NOT NULL PRIMARY KEY,
    firstName varchar(255) NOT NULL,
    lastName varchar(255) NOT NULL,
    schoolId int NOT NULL REFERENCES school(schoolId),
    roomId int NOT NULL REFERENCES room(roomId),
    grade int NOT NULL
);

CREATE TABLE course (
    courseId serial NOT NULL PRIMARY KEY,
    courseName varchar(255) NOT NULL
);

CREATE TABLE loan (
    loanId serial NOT NULL PRIMARY KEY,
    teacherId integer NOT NULL REFERENCES teacher(teacherId),
    courseId integer NOT NULL REFERENCES course(courseId),
    bookId integer NOT NULL REFERENCES book(bookId),
    loanDate date NOT NULL
);

-- table data
INSERT INTO publisher (publisherName)
VALUES ('BOA Editions'),
    ('Taylor & Francis Publishing'),
    ('Prentice Hall'),
    ('McGraw Hill');

INSERT INTO book (bookName, publisherId)
VALUES ('Learning and teaching in early childhood', 1),
    ('Preschool, N56', 2),
    ('Early Childhood Education N9', 3),
    ('Know how to educate: guide for Parents', 4);

INSERT INTO school (schoolName)
VALUES ('Horizon Education Institute'),
    ('Bright Institution');

INSERT INTO room (roomName)
VALUES ('1.A01'),
    ('1.B01'),
    ('2.B01');

INSERT INTO teacher (firstName, lastName, schoolId, roomId, grade)
VALUES ('Chad', 'Russell', 1, 1, 1),
    ('E.F.', 'Codd', 1, 2, 1),
    ('Jones', 'Smith', 1, 1, 2),
    ('Adam', 'Baker', 2, 3, 1);

INSERT INTO course (courseName)
VALUES ('Logical thinking'),
    ('Wrtting'),
    ('Numerical Thinking'),
    ('Spatial, Temporal and Causal Thinking'),
    ('English');

INSERT INTO loan (teacherId, courseId, bookId, loanDate)
VALUES (1, 1, 1, '09/09/2010'),
    (1, 2, 2, '05/05/2010'),
    (1, 3, 1, '05/05/2010'),
    (2, 4, 3, '06/05/2010'),
    (2, 3, 1, '06/05/2010'),
    (3, 2, 1, '09/09/2010'),
    (3, 5, 4, '05/05/2010'),
    (4, 1, 4, '05/05/2010'),
    (4, 3, 1, '05/05/2010');


-- 1) Obtain for each of the schools, the number of books that have been loaned to each publishers.
select schoolName as school,
    publisherName as publisher,
    count(*)
from loan
    natural join teacher
    natural join school
    natural join book
    natural join publisher
group by schoolName, publisherName
order by schoolName;

-- 2) For each school, find the book that has been on loan the longest and the teacher in charge of it.

drop table if exists longestLoans;

select loandate, teacherid, bookid into temporary table longestLoans 
from loan
group by loandate, teacherid, bookid
having loandate = min(loandate);


select min(loandate), schoolName, bookName, (firstName || ' ' || lastName) as teacher_name
from longestLoans natural join teacher natural join book natural join school
group by schoolname, teacher_name, bookName
order by schoolname ;
