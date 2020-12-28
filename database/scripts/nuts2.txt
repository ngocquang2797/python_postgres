select
	row_number() over(order by q1.code) as fid,
	coalesce(q1.code, q2.code) as code,
	coalesce(q1.name, q2.name) as name
from
	(select nuts218cd as code, nuts218nm as name
	from local_authority
	group by nuts218cd, nuts218nm) as q1
full outer join
	(select "NUTS218CD" as code, "NUTS218NM" as name
	from geo_level
	group by "NUTS218CD", "NUTS218NM") as q2
on q1.code = q2.code