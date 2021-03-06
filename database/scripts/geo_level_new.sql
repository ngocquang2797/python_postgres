-- Extract pcd7, lau1, wipe2 data from msoa_lsoa, pcd_wd table
with Q3 as (select *
from (
         select RTRIM(LEFT(Q1.pcd, 4), ' ') as pcd,
                Q1.lau1,
                Q1.lau2
         from (
                  select coalesce(msoa_lsoa.pcd7, pcd_wd.pcd7)     as pcd,
                         coalesce(msoa_lsoa.ladcd, pcd_wd.lad11cd) as lau1,
                         pcd_wd.wd11cd                             as lau2
                  from msoa_lsoa
                           full outer join pcd_wd on msoa_lsoa.pcd7 = pcd_wd.pcd7
              ) as Q1
     ) as Q2
--      remove duplicate row
group by pcd, lau1, lau2)
select *
-- insert data to geo_level_new table
into geo_level_new
from geo_level
left join Q3 on geo_level."LAU217CD" = Q3.lau2 and geo_level."LAU117CD" = Q3.lau1;
alter table geo_level_new add foreign key ("LAU217CD") references lookup_lau2(code),
    add foreign key ("LAU117CD") references lookup_lau1(code),
    add foreign key ("NUTS118CD") references lookup_nuts1(code),
    add foreign key ("NUTS218CD") references lookup_nuts2(code),
    add foreign key ("NUTS318CD") references lookup_nuts3(code);