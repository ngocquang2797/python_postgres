select
-- numbered id
	row_number() over(order by query1.lau1) as fid,
       query1.pcd,
    -- 	Standardize data by choosing a value
       coalesce(query1.lau1, local_authority.lau118cd, geo_level."LAU117CD", lau2_pc_la.lad19cd) as lau1,
       coalesce(query1.lau2, local_authority.lau218cd, geo_level."LAU217CD", lau2_pc_la.wd19cd) as lau2,
       coalesce(local_authority.nuts318cd, geo_level."NUTS318CD") as nuts3,
       coalesce(local_authority.nuts218cd, geo_level."NUTS218CD") as nuts2,
       coalesce(local_authority.nuts118cd, geo_level."NUTS118CD") as nuts1,
       lau2_pc_la.pcon19cd as pc
-- insert into lookup_geo_levels table
into lookup_geo_levels
from (select RTRIM(LEFT(Q1.pcd7,4),' ')  as pcd,
       Q1.lau1, Q1.lau2
    from (select coalesce(pcd_wd.pcd7, msoa_lsoa.pcd7) as pcd7,
               coalesce(pcd_wd.lad11cd, msoa_lsoa.ladcd) as lau1,
               pcd_wd.wd11cd as lau2
        from msoa_lsoa
        full outer join pcd_wd on msoa_lsoa.pcd7 = pcd_wd.pcd7) as Q1
group by pcd, lau1, lau2) as query1
-- combine data
full outer join local_authority on query1.lau2 = local_authority.lau218cd and query1.lau1 = local_authority.lau118cd
full outer join geo_level on local_authority.lau218cd = geo_level."LAU217CD" and local_authority.lau118cd = geo_level."LAU117CD"
full outer join lau2_pc_la on geo_level."LAU217CD" = lau2_pc_la.wd19cd and geo_level."LAU117CD" = lau2_pc_la.lad19cd;