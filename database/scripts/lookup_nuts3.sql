select
-- numbered id
	row_number() over(order by q1.code) as fid,
	coalesce(q1.code, q2.code) as code,
	coalesce(q1.name, q2.name) as name
from
	(select nuts318cd as code, nuts318nm as name
	from local_authority
	group by nuts318cd, nuts318nm) as q1
full outer join
	(select "NUTS318CD" as code, "NUTS318NM" as name
	from geo_level
	group by "NUTS318CD", "NUTS318NM") as q2
on q1.code = q2.code
