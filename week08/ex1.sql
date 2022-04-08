explain analyze select * from customer where name= 'Joe Smith'

Seq Scan on customer  (cost=0.00..4284.07 rows=2 width=211) (actual time=9.395..21.263 rows=2 loops=1)
  Filter: (name = 'Joe Smith'::text)
  Rows Removed by Filter: 99998
Planning Time: 0.152 ms
Execution Time: 21.282 ms

explain analyze select * from customer where address LIKE '%TX%' -- find customers in Texas

Seq Scan on customer  (cost=0.00..4284.07 rows=10 width=211) (actual time=0.034..28.107 rows=1705 loops=1)
  Filter: (address ~~ '%TX%'::text)
  Rows Removed by Filter: 98295
Planning Time: 0.111 ms
Execution Time: 28.212 ms


explain analyze select * from customer where id = 80004

Index Scan using customer_pkey on customer  (cost=0.29..8.31 rows=1 width=211) (actual time=0.015..0.016 rows=1 loops=1)
  Index Cond: (id = 80004)
Planning Time: 0.056 ms
Execution Time: 0.029 ms

-- now add indices

create index idx_name on customer(name);
explain analyze select * from customer where name= 'Joe Smith'
Bitmap Heap Scan on customer  (cost=4.43..12.30 rows=2 width=211) (actual time=0.063..0.066 rows=2 loops=1)
  Recheck Cond: (name = 'Joe Smith'::text)
  Heap Blocks: exact=2
  ->  Bitmap Index Scan on idx_name  (cost=0.00..4.43 rows=2 width=0) (actual time=0.056..0.056 rows=2 loops=1)
        Index Cond: (name = 'Joe Smith'::text)
Planning Time: 0.316 ms
Execution Time: 0.088 ms

create index idx_addr on customer(address);
explain analyze select * from customer where address LIKE '%TX%'
Seq Scan on customer  (cost=0.00..4284.00 rows=10 width=211) (actual time=0.039..33.066 rows=1705 loops=1)
  Filter: (address ~~ '%TX%'::text)
  Rows Removed by Filter: 98295
Planning Time: 0.134 ms
Execution Time: 33.192 ms

-- we are looking for substring and in this case indexing won't help us - sorting is actually in no assistance here

create index idx_id on customer(id);
explain analyze select * from customer where id = 80004
Index Scan using idx_id on customer  (cost=0.29..8.31 rows=1 width=211) (actual time=0.027..0.028 rows=1 loops=1)
  Index Cond: (id = 80004)
Planning Time: 0.193 ms
Execution Time: 0.042 ms
