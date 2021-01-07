with q1 as
        (
            select wd19cd as code, wd19nm as name
            from lau2_pc_la
        -- 	remove duplicate row
            group by wd19cd, wd19nm
        ),
    q2 as
        (
            select lau218cd as code, lau218nm as name
            from local_authority
        -- 	remove duplicate row
            group by lau218cd, lau218nm
        ),
    q3 as
        (
            select wd11cd as code, wd11nm as name
            from pcd_wd
        -- 	remove duplicate row
            group by wd11cd, wd11nm
        ),
    q4 as
        (
            select "LAU217CD" as code, "LAU217NM" as name
            from geo_level
        -- 	remove duplicate row
            group by "LAU217CD", "LAU217NM"
        ),
Q6 as
(
    select
-- numbered id
-- 	row_number() over(order by q1.code) as fid,
-- 	Standardize data by choosing a value
	coalesce(q1.code, q2.code, q3.code, q4.code) as code,
	coalesce(q1.name, q2.name, q3.name, q4.name) as name
-- insert into lookup_lau1 table
-- into lookup_lau1
from
	q1
-- 	merge table
full outer join q2
on q1.code = q2.code
-- 	merge table
full outer join q3
on q2.code = q3.code
-- 	merge table
full outer join q4
on q3.code = q4.code
),
     q7 as
(select
    row_number() over(order by code) as fid,
       code, name
-- into lookup_lau2
from Q6
group by code, name)
-- alter table lookup_lau2 add primary key(code)
select *
from q4
where code = 'E05010297'
-- group by code
-- having count(code) >1