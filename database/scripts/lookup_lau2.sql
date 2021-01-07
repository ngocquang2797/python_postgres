with
 q1 as
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
q5 as
    (
        select coalesce(q1.code,q2.code) as code,
               coalesce(q1.name,q2.name) as name
        from q1 full outer join q2 on q1.code = q2.code
    ),
q6 as
    (
        select coalesce(q5.code,q3.code) as code,
               coalesce(q5.name,q3.name) as name
        from q5 full outer join q3 on q5.code = q3.code
    ),
q7 as
    (
        select coalesce(q6.code,q4.code) as code,
               coalesce(q6.name,q4.name) as name
        from q6 full outer join q4 on q6.code = q4.code
    )
select row_number() over(order by q7.code) as fid, *
into lookup_lau2
from q7;
alter table lookup_lau2 add primary key (code, fid)