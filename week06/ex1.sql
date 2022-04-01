-- schema


CREATE TABLE parts (
    pid int4 NOT NULL,
    pname varchar(255) NOT NULL,
    color varchar(255) NOT NULL,
    PRIMARY KEY (pid)
);

CREATE TABLE suppliers (
    sid int4 NOT NULL,
    sname varchar(255) NOT NULL,
    address varchar(255) NOT NULL,
    PRIMARY KEY (sid)
);

CREATE TABLE catalog (
    sid int4 NOT NULL,
    pid int4 NOT NULL,
    cost numeric(10, 5) NOT NULL,
    FOREIGN KEY (pid) REFERENCES parts(pid)
);

INSERT INTO suppliers (sid,sname,address) VALUES
     (1,'Yosemite Sham','Devil''s canyon, AZ'),
     (2,'Wiley E. Coyote','RR Asylum, NV'),
     (3,'Elmer Fudd','Carrot Patch, MN');

INSERT INTO parts (pid,pname,color) VALUES
     (1,'Red1','Red'),
     (2,'Red2','Red'),
     (3,'Green1','Green'),
     (4,'Blue1','Blue'),
     (5,'Red3','Red');
     
INSERT INTO catalog (sid,pid,cost) VALUES
     (1,1,10.00000),
     (1,2,20.00000),
     (1,3,30.00000),
     (1,4,40.00000),
     (1,5,50.00000),
     (2,1,9.00000),
     (2,3,34.00000),
     (2,5,48.00000);     
     
--- 1. Find the names of suppliers who supply some red part
select distinct(sname)
from catalog c, parts p, suppliers s
where c.pid = p.pid and s.sid = c.sid and p.color = 'Red';

--- 2. Find the sids of suppliers who supply some red or green part.
select distinct(sid)
from catalog c inner join parts p on c.pid = p.pid
where p.color = 'Red'
intersect 
select distinct(sid)
from catalog c inner join parts p on c.pid = p.pid
where p.color = 'Green';

--- 3. Find the sids of suppliers who supply some red part or at 221 Packer Street
select distinct(s.sid)
from catalog c, parts p, suppliers s
where c.sid = s.sid and c.pid = p.pid and p.color = 'Red' or s.address = '221 Packer Street' order by s.sid;

--- 4. Find the sids of suppliers who supply every (red or green) part
select distinct(sid) 
from catalog natural join parts
group by sid 
having count(sid) >= ( select count(*) 
                      from parts p 
                      where p.color = 'Red' or p.color = 'Green'
                    ); 
                
--- 5. Find the sids of suppliers who supply every red part or supply every green part.
select distinct(sid) 
from catalog natural join (select * from parts where color='Red') as red_parts
group by sid 
having count(sid) >= ( select count(*) 
                      from parts p 
                      where p.color = 'Red'
                    )
union
select distinct(sid) 
from catalog natural join (select * from parts where color='Green') as green_parts
group by sid 
having count(sid) >= ( select count(*) 
                      from parts p 
                      where p.color = 'Green'
                    );
                
--- 6. Find pairs of sids such that the supplier with the first sid charges more 
--- for some part than the supplier with the second sid                
select distinct(s1.sid, s2.sid)
from catalog s1 inner join catalog s2 on s1.pid = s2.pid
where s1.cost > s2.cost;

--- 7. Find the pids of parts supplied by at least two different suppliers.
select distinct(c1.pid)
from catalog c1 inner join catalog c2 on c1.pid = c2.pid and c1.sid != c2.sid;

--- 8. Find the average cost of the red parts and green parts for each of the suppliers
select c.sid, p.color, avg(cost) as avg
from catalog c inner join parts p on c.pid = p.pid
where p.color in ('Red', 'Green')
group by c.sid, p.color

--- 9. Find the sids of suppliers whose most expensive part costs $50 or more
select sid
from catalog as c1
group by sid
having max(c1.cost) >= 50
