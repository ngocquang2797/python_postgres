with q2 as(SELECT DISTINCT ON (pcon19cd)
       pcon19cd as code , pcon19nm as name
FROM   lau2_pc_la
ORDER  BY code, name DESC)
select row_number() over(order by q2.code) as fid, *
-- insert into lookup_pc table
into lookup_pc
from q2
;
alter table lookup_pc add primary key (code,fid)
