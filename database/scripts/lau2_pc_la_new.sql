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
-- insert data to lau2_pc_la_new table
into lau2_pc_la_new
from lau2_pc_la
left join Q3 on lau2_pc_la.wd19cd = Q3.lau2 and lau2_pc_la.lad19cd = Q3.lau1;
alter table lau2_pc_la_new add foreign key (wd19cd) references lookup_lau2(code),
    add foreign key (pcon19cd) references lookup_pc(code),
    add foreign key (lad19cd) references lookup_lau1(code)
