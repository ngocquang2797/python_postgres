with q1 as
        (
            select ladcd as code, ladnm as name
            from msoa_lsoa
        -- 	remove duplicate row
--             group by ladcd, ladnm
        ),
    q2 as
        (
            select lad11cd as code, lad11nm as name
            from pcd_wd
        -- 	remove duplicate row
--             group by lad11cd, lad11nm
        ),
    q3 as
        (
            select lau118cd as code, lau118nm as name
            from local_authority
        -- 	remove duplicate row
--             group by lau118cd, lau118nm
        ),
    q4 as
        (
            select lad19cd as code, lad19nm as name
            from lau2_pc_la
        -- 	remove duplicate row
--             group by lad19cd, lad19nm
        ),
    q5 as
        (
            select "LAU117CD" as code, "LAU117NM" as name
            from geo_level
        -- 	remove duplicate row
--             group by "LAU117CD", "LAU117NM"
        ),
Q6 as
(
    select
-- numbered id
	row_number() over(order by q1.code) as fid,
-- 	Standardize data by choosing a value
	coalesce(q1.code, q2.code, q3.code, q4.code, q5.code) as code,
	coalesce(q1.name, q2.name, q3.name, q4.name, q5.name) as name
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
-- 	merge table
full outer join q5
on q4.code = q5.code
)
select code, name, count(*)
from Q6
--      (
--      select code,name from Q6
--          group by code,name
--          ) as q
group by code, name
having count(*) > 1
-- alter table lookup_lau1 add primary key (code)
