select lau2, lau1, pcd, count(*)
from
(
    select *
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
    group by pcd, lau1, lau2
) as Q3
group by lau2, lau1, pcd
having count(*)>1