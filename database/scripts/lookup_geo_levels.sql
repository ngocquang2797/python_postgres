-- combine data from pcd_wd and msoa_lsoa to get pcd7, lau1, lau2
with Q1 as
    (
        select coalesce(pcd_wd.pcd7, msoa_lsoa.pcd7) as pcd7,
               coalesce(pcd_wd.lad11cd, msoa_lsoa.ladcd) as lau1,
               pcd_wd.wd11cd as lau2
        from msoa_lsoa
        full outer join pcd_wd on msoa_lsoa.pcd7 = pcd_wd.pcd7
    ),
-- get pcd from pcd7
Q2 as
    (
        select RTRIM(LEFT(Q1.pcd7,4),' ')  as pcd,
           Q1.lau1, Q1.lau2
        from Q1
        group by pcd, lau1, lau2
    ),
--      combine data from local_authority and geo_level to get lau1, lau2, nuts1, nuts2, nuts3
Q3 as
    (
        select
        coalesce(local_authority.lau118cd, geo_level."LAU117CD") as lau1,
        coalesce(local_authority.lau218cd, geo_level."LAU217CD") as lau2,
        coalesce(local_authority.nuts318cd, geo_level."NUTS318CD") as nuts3,
        coalesce(local_authority.nuts218cd, geo_level."NUTS218CD") as nuts2,
        coalesce(local_authority.nuts118cd, geo_level."NUTS118CD") as nuts1
        from local_authority
        full outer join geo_level on local_authority.lau218cd = geo_level."LAU217CD" and local_authority.lau118cd = geo_level."LAU117CD"

    ),
-- combine data from Q2, local_authority, geo_level table
Q4 as
    (
        select
        Q2.pcd,
        -- 	Standardize data by choosing a value
        coalesce(Q3.lau1, Q2.lau1) as lau1,
        coalesce(Q3.lau2, Q2.lau2) as lau2,
        Q3.nuts3,
        Q3.nuts2,
        Q3.nuts1
                from Q2
        -- combine data
        full outer join Q3 on Q2.lau2 = Q3.lau2 and Q2.lau1 = Q3.lau1
    ),
--      combine data from Q3 and Q4 to get pc column
Q5 as
    (
            -- numbered id
        select row_number() over(order by Q4.lau1) as fid,
               Q4.pcd,
               coalesce(Q4.lau1, lau2_pc_la.lad19cd) as lau1,
               coalesce(Q4.lau2, lau2_pc_la.wd19cd) as lau2,
               Q4.nuts1,
               Q4.nuts2,
               Q4.nuts3,
               lau2_pc_la.pcon19cd as pc
        from Q4
        full outer join lau2_pc_la on Q4.lau2 = lau2_pc_la.wd19cd and Q4.lau1 = lau2_pc_la.lad19cd
    )


select *
-- insert data to lookup_geo_levels table
into lookup_geo_levels
from Q5