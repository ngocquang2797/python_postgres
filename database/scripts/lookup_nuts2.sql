select
-- numbered id
	row_number() over(order by q1.code) as fid,
-- 	Standardize data by choosing a value
	coalesce(q1.code, q2.code) as code,
	coalesce(q1.name, q2.name) as name
-- insert into lookup_nuts2 table
into lookup_nuts2
from
	(select nuts218cd as code, nuts218nm as name
	from local_authority
-- 	remove duplicate row
	group by nuts218cd, nuts218nm) as q1
-- 	merge table
full outer join
	(select "NUTS218CD" as code, "NUTS218NM" as name
	from geo_level
-- 	remove duplicate row
	group by "NUTS218CD", "NUTS218NM") as q2
on q1.code = q2.code;
alter table lookup_nuts2 add primary key (code, fid)