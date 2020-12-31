select
-- numbered id
	row_number() over(order by q1.code) as fid,
-- 	Standardize data by choosing a value
	coalesce(q1.code, q2.code, q3.code, q4.code) as code,
	coalesce(q1.name, q2.name, q3.name, q4.name) as name
-- insert into lookup_lau2 table
into lookup_lau2
from
	(select wd19cd as code, wd19nm as name
	from lau2_pc_la
-- 	remove duplicate row
	group by wd19cd, wd19nm) as q1
-- 	merge table
full outer join
	(select lau218cd as code, lau218nm as name
	from local_authority
-- 	remove duplicate row
	group by lau218cd, lau218nm) as q2
on q1.code = q2.code
-- 	merge table
full outer join
	(select wd11cd as code, wd11nm as name
	from pcd_wd
-- 	remove duplicate row
	group by wd11cd, wd11nm)as q3
on q2.code = q3.code
-- 	merge table
full outer join
	(select "LAU217CD" as code, "LAU217NM" as name
	from geo_level
-- 	remove duplicate row
	group by "LAU217CD", "LAU217NM") as q4
on q3.code = q4.code
