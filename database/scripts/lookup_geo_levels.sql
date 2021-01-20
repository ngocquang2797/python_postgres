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

alter table lookup_geo_levels_id add column id serial,
    add foreign key (lau1_id) references lookup_lau1(id),
    add foreign key (lau2_id) references lookup_lau2(id),
    add foreign key (nuts1_id) references lookup_nuts1(id),
    add foreign key (nuts2_id) references lookup_nuts2(id),
    add foreign key (nuts3_id) references lookup_nuts3(id),
    add foreign key (pc_id) references lookup_pc(id),
    add foreign key (pcd_id) references lookup_pcd(id);