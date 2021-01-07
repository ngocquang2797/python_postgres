with q1 as
   (select
-- numbered id
    row_number() over(order by pcon19cd) as fid,
	pcon19cd as code,
    pcon19nm as name
-- insert into lookup_pc table
-- into lookup_pc
from lau2_pc_la
-- 	remove duplicate row
group by pcon19cd, pcon19nm),
q2 as(SELECT DISTINCT ON (code)
       code, name
FROM   q1
ORDER  BY code, name DESC)
select row_number() over(order by q2.code) as fid, *
into lookup_pc
from q2;
alter table lookup_pc add primary key (code)
