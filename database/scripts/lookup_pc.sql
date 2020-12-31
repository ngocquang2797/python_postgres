select
-- numbered id
    row_number() over(order by pcon19cd) as fid,
	pcon19cd as code,
    pcon19nm as name
-- insert into lookup_pc table
into lookup_pc
from lau2_pc_la
-- 	remove duplicate row
group by pcon19cd, pcon19nm;