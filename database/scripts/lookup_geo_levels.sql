-- create lookup_geo_levels_code_table
drop table if exists lookup_geo_levels_code CASCADE;
create table lookup_geo_levels_code
as
(
    -- combine data from pcd_wd and msoa_lsoa to get pcd7, lau1, lau2
    with Q1 as
        (
            select coalesce(pcd_wd_new.pcd7, msoa_lsoa_new.pcd7) as pcd7,
                   coalesce(pcd_wd_new.lad11cd, msoa_lsoa_new.ladcd) as lau1,
                   pcd_wd_new.wd11cd as lau2
            from msoa_lsoa_new
            full outer join pcd_wd_new on msoa_lsoa_new.pcd7 = pcd_wd_new.pcd7
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
            select Q4.pcd,
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
    from Q5
    group by pcd, lau1, lau2, nuts1, nuts2, nuts3, pc
);
alter table lookup_geo_levels_code add column id serial,
    add foreign key (lau1) references lookup_lau1(code),
    add foreign key (lau2) references lookup_lau2(code),
    add foreign key (nuts1) references lookup_nuts1(code),
    add foreign key (nuts2) references lookup_nuts2(code),
    add foreign key (nuts3) references lookup_nuts3(code),
    add foreign key (pc) references lookup_pc(code),
    add foreign key (pcd) references lookup_pcd(pcd);

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
    from lookup_geo_levels
    left join lookup_lau1 on lookup_geo_levels.lau1 = lookup_lau1.code
    left join lookup_lau2 on lookup_geo_levels.lau2 = lookup_lau2.code
    left join lookup_pcd on lookup_geo_levels.pcd = lookup_pcd.pcd
    left join lookup_nuts1 on lookup_geo_levels.nuts1 = lookup_nuts1.code
    left join lookup_nuts2 on lookup_geo_levels.nuts2 = lookup_nuts2.code
    left join lookup_nuts3 on lookup_geo_levels.nuts3 = lookup_nuts3.code
    left join lookup_pc on lookup_geo_levels.pc = lookup_pc.code
);