select
	row_number() over(order by q1.code) as fid,
	coalesce(q1.code, q2.code) as code,
	coalesce(q1.name, q2.name) as name
from
	(select nuts118cd as code, nuts118nm as name
	from local_authority
	group by nuts118cd, nuts118nm) as q1
full outer join
	(select "NUTS118CD" as code, "NUTS118NM" as name
	from geo_level
	group by "NUTS118CD", "NUTS118NM") as q2
on q1.code = q2.code