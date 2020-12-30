select
-- numbered id
	row_number() over(order by query1.lau1) as fid,
       query1.pcd,
    -- 	Standardize data by choosing a value
       coalesce(query1.lau1, local_authority.lau118cd, geo_level."LAU117CD") as lau1,
       coalesce(query1.lau2, local_authority.lau218cd, geo_level."LAU217CD") as lau2,
       coalesce(local_authority.nuts318cd, geo_level."NUTS318CD") as nuts3,
       coalesce(local_authority.nuts218cd, geo_level."NUTS218CD") as nuts2,
       coalesce(local_authority.nuts118cd, geo_level."NUTS118CD") as nuts1,
       lau2_pc_la.pcon19cd as pc
from (select *
    from (SELECT coalesce(q1.pcd, q2.pcd) as pcd, q1.wd11cd as lau2, coalesce(q1.lau1, q2.lau1) as lau1
-- get postcode district from first 4 characters and remove space
        FROM (select RTRIM(LEFT(pcd7,4),' ')  as pcd,
            wd11cd, lad11cd as lau1, pcd7
            from pcd_wd) as q1
--             combine data from pcd_wd and msoa_lsoa tables
        full outer join
            (select RTRIM(LEFT(pcd7,4),' ')  as pcd,
                    ladcd as lau1, pcd7
                from msoa_lsoa) as q2
        on q1.pcd7 = q2.pcd7) as q
    group by pcd, lau2, lau1) as query1
-- combine data
full outer join local_authority on query1.lau2 = local_authority.lau218cd
full outer join geo_level on query1.lau2 = geo_level."LAU217CD"
full outer join lau2_pc_la on query1.lau2 = lau2_pc_la.wd19cd;