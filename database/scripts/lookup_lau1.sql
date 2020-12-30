select
-- numbered id
	row_number() over(order by q1.code) as fid,
	coalesce(q1.code, q2.code, q3.code, q4.code, q5.code) as code,
	coalesce(q1.name, q2.name, q3.name, q4.name, q5.name) as name
from
	(select ladcd as code, ladnm as name
	from msoa_lsoa
	group by ladcd, ladnm) as q1
full outer join
	(select lad11cd as code, lad11nm as name
	from pcd_wd
	group by lad11cd, lad11nm) as q2
on q1.code = q2.code
full outer join
	(select lau118cd as code, lau118nm as name
	from local_authority
	group by lau118cd, lau118nm)as q3
on q2.code = q3.code
full outer join
	(select lad19cd as code, lad19nm as name
	from lau2_pc_la
	group by lad19cd, lad19nm)as q4
on q3.code = q4.code
full outer join
	(select "LAU117CD" as code, "LAU117NM" as name
	from geo_level
	group by "LAU117CD", "LAU117NM") as q5
on q4.code = q5.code
