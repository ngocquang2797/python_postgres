select
-- numbered id
    row_number() over(order by pcon19cd) as fid,
	pcon19cd as code,
    pcon19nm as name
from lau2_pc_la
group by pcon19cd, pcon19nm;