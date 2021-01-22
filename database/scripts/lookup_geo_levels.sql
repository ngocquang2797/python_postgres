-- "ONSPD_MAY_2020_UK" get pcd, lau1, pc from "ONSPD_MAY_2020_UK"
drop table if exists onspd_uk CASCADE;
create table onspd_uk as
    (
        select pcd, oslaua, pcon
        from "ONSPD_MAY_2020_UK"
    );

drop table if exists pcd_msoa CASCADE;
create table pcd_msoa as
    (
        -- combine data from pcd_wd and msoa_lsoa to get pcd7, lau1, lau2
        select coalesce(pcd_wd.pcd7, msoa_lsoa.pcd7) as pcd7,
                   coalesce(pcd_wd.lad11cd, msoa_lsoa.ladcd) as lau1,
                   pcd_wd.wd11cd as lau2
            from msoa_lsoa
            full outer join pcd_wd on msoa_lsoa.pcd7 = pcd_wd.pcd7
    );

-- combine data from pcd_msoa and onspd_uk
drop table if exists pcd_merge CASCADE;
create table pcd_merge as
    (
        select coalesce(pcd_msoa.pcd7, onspd_uk.pcd) as pcd7,
               coalesce(pcd_msoa.lau1, onspd_uk.oslaua) as lau1,
               pcd_msoa.lau2 as lau2,
               onspd_uk.pcon as pc

        from pcd_msoa
        full outer join onspd_uk on pcd_msoa.pcd7 = onspd_uk.pcd
);

-- drop table
drop table onspd_uk;
drop table pcd_msoa;

-- create backup Q1
drop table if exists lookup_geo_levels_q1 CASCADE;
create table lookup_geo_levels_q1 as
    (
        -- combine data from pcd_wd ,"ONSPD_MAY_2020_UK" and msoa_lsoa to get pcd7, lau1, lau2
    -- get pcd from pcd7
            select RTRIM(LEFT(pcd_merge.pcd7,4),' ')  as pcd,
               pcd_merge.lau1, pcd_merge.lau2, pcd_merge.pc
            from pcd_merge
            group by pcd, lau1, lau2, pc
    );

drop table pcd_merge
--
-- create lookup_geo_levels_code_table
drop table if exists lookup_geo_levels_code CASCADE;
create table lookup_geo_levels_code
as
(
    with
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
            lookup_geo_levels_q1.pcd,
            lookup_geo_levels_q1.pc,
            -- 	Standardize data by choosing a value
            coalesce(Q3.lau1, lookup_geo_levels_q1.lau1) as lau1,
            coalesce(Q3.lau2, lookup_geo_levels_q1.lau2) as lau2,
            Q3.nuts3,
            Q3.nuts2,
            Q3.nuts1
                    from lookup_geo_levels_q1
            -- combine data
            full outer join Q3 on lookup_geo_levels_q1.lau2 = Q3.lau2 and lookup_geo_levels_q1.lau1 = Q3.lau1
        ),
    --      combine data from Q3 and Q4 to get pc column
    Q5 as
        (
                -- numbered id
            select Q4.pcd,
                   coalesce(Q4.lau1, lau2_pc_la.lad19cd) as lau1,
                   coalesce(Q4.lau2, lau2_pc_la.wd19cd) as lau2,
                   Q4.nuts1,
                   Q4.nuts2,
                   Q4.nuts3,
                   coalesce(Q4.pc,lau2_pc_la.pcon19cd) as pc
            from Q4
            full outer join lau2_pc_la on Q4.lau2 = lau2_pc_la.wd19cd and Q4.lau1 = lau2_pc_la.lad19cd and Q4.pc = lau2_pc_la.pcon19cd
        )


    select *
    from Q5
    group by pcd, lau1, lau2, nuts1, nuts2, nuts3, pc
);

drop table lookup_geo_levels_q1;

-- create lookup_geo_levels_id
drop table if exists lookup_geo_levels_id CASCADE;
create table lookup_geo_levels_id
as
(
    select lookup_lau1.id as lau1_id,
       lookup_lau2.id as lau2_id,
       lookup_pcd.id as pcd_id,
       lookup_nuts1.id as nuts1_id,
       lookup_nuts2.id as nuts2_id,
       lookup_nuts3.id as nuts3_id,
       lookup_pc.id as pc_id
    from lookup_geo_levels_code
    left join lookup_lau1 on lookup_geo_levels_code.lau1 = lookup_lau1.code
    left join lookup_lau2 on lookup_geo_levels_code.lau2 = lookup_lau2.code
    left join lookup_pcd on lookup_geo_levels_code.pcd = lookup_pcd.pcd
    left join lookup_nuts1 on lookup_geo_levels_code.nuts1 = lookup_nuts1.code
    left join lookup_nuts2 on lookup_geo_levels_code.nuts2 = lookup_nuts2.code
    left join lookup_nuts3 on lookup_geo_levels_code.nuts3 = lookup_nuts3.code
    left join lookup_pc on lookup_geo_levels_code.pc = lookup_pc.code
);

alter table lookup_geo_levels_id add foreign key (lau1_id) references lookup_lau1(id),
    add foreign key (lau2_id) references lookup_lau2(id),
    add foreign key (nuts1_id) references lookup_nuts1(id),
    add foreign key (nuts2_id) references lookup_nuts2(id),
    add foreign key (nuts3_id) references lookup_nuts3(id),
    add foreign key (pc_id) references lookup_pc(id),
    add foreign key (pcd_id) references lookup_pcd(id);