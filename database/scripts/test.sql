-- add pcd column to msoa_lsoa table
drop table if exists msoa_lsoa_new CASCADE ;
create table msoa_lsoa_new
as
(
    select *, RTRIM(LEFT(msoa_lsoa.pcd7, 4), ' ') as pcd
    from msoa_lsoa
);

-- add pcd column to pcd_wd table
drop table if exists pcd_wd_new CASCADE ;
create table pcd_wd_new
as
(
    select *, RTRIM(LEFT(pcd_wd.pcd7, 4), ' ') as pcd
    from pcd_wd
);

-- lookup_lau1
drop table if exists lookup_lau1 CASCADE;
-- create table lookup_lau1
create table lookup_lau1
as
(
    with
    -- lau1 msoa_lsoa table
    q1 as
        (
            select ladcd as code, ladnm as name
            from msoa_lsoa
        -- 	remove duplicate row
            group by ladcd, ladnm
            having ladcd is not null
        ),
    -- pcd_wd table
    q2 as
        (
            select lad11cd as code, lad11nm as name
            from pcd_wd
        -- 	remove duplicate row
            group by lad11cd, lad11nm
            having lad11cd is not null
        ),
    -- local_authority table
    q3 as
        (
            select lau118cd as code, lau118nm as name
            from local_authority
        -- 	remove duplicate row
            group by lau118cd, lau118nm
            having lau118cd is not null
            ),
    -- lau2_pc_la table
    q4 as
        (
            select lad19cd as code, lad19nm as name
            from lau2_pc_la
        -- 	remove duplicate row
            group by lad19cd, lad19nm
            having lad19cd is not null
        ),
    -- geo_level table
    q5 as
        (
            select "LAU117CD" as code, "LAU117NM" as name
            from geo_level
        -- 	remove duplicate row
            group by "LAU117CD", "LAU117NM"
            having "LAU117CD" is not null
        ),
--          "ONSPD_MAY_2020_UK" table
    q6 as
        (
            select oslaua as code
            from "ONSPD_MAY_2020_UK"
            group by oslaua
        ),
    Q7 as
    (
        select
    -- 	Standardize data by choosing a value
        coalesce(q1.code, q2.code, q3.code, q4.code, q5.code, q6.code) as code,
        coalesce(q1.name, q2.name, q3.name, q4.name, q5.name) as name
    from
        q1
    -- 	merge q1, q2, q3, q4, q5
    full outer join q2 on q1.code = q2.code
    full outer join q3 on q2.code = q3.code
    full outer join q4 on q3.code = q4.code
    full outer join q5 on q4.code = q5.code
    full outer join q6 on q5.code = q6.code
    )
    select distinct on(code) *
    from Q7
    order by code, name desc
);
-- add primary key and id column
alter table lookup_lau1 add column id serial PRIMARY KEY;

-- lookup_lau2 table
drop table if exists lookup_lau2 CASCADE;
-- create table lookup_lau1
create table lookup_lau2
as
(
    with
    -- lau2_pc_la table
    q1 as
        (
            select wd19cd as code, wd19nm as name
            from lau2_pc_la
            -- 	remove duplicate row
            group by wd19cd, wd19nm
            having wd19cd is not null
        ),
    --     local_authority table
    q2 as
        (
            select lau218cd as code, lau218nm as name
            from local_authority
            -- 	remove duplicate row
            group by lau218cd, lau218nm
            having lau218cd is not null
        ),
    --     pcd_wd table
    q3 as
        (
            select wd11cd as code, wd11nm as name
            from pcd_wd
            -- 	remove duplicate row
            group by wd11cd, wd11nm
            having wd11cd is not  null
        ),
    --     geo_level table
    q4 as
        (
            select "LAU217CD" as code, "LAU217NM" as name
            from geo_level
            -- 	remove duplicate row
            group by "LAU217CD", "LAU217NM"
            having "LAU217CD" is not null
        ),
    q5 as
        (
        -- 	Standardize data by choosing a value
            select coalesce(q1.code,q2.code, q3.code, q4.code) as code,
                   coalesce(q1.name,q2.name, q3.name, q4.name) as name
    --                merge q1, q2, q3, q4
            from q1
                full outer join q2 on q1.code = q2.code
                full outer join q3 on q2.code = q3.code
                full outer join q4 on q3.code = q4.code
        )
    select distinct on(code) *
    from q5
    order by code, name desc
);
alter table lookup_lau2 add column id serial PRIMARY KEY;

-- lookup_nuts1
drop table if exists lookup_nuts1 CASCADE;
-- create table lookup_lau1
create table lookup_nuts1
as
(
    select
    -- 	Standardize data by choosing a value
        coalesce(q1.code, q2.code) as code,
        coalesce(q1.name, q2.name) as name
    from
        (select nuts118cd as code, nuts118nm as name
        from local_authority
    -- 	remove duplicate row
        group by nuts118cd, nuts118nm) as q1
    -- 	merge table
    full outer join
        (select "NUTS118CD" as code, "NUTS118NM" as name
        from geo_level
    -- 	remove duplicate row
        group by "NUTS118CD", "NUTS118NM") as q2
    on q1.code = q2.code
);
alter table lookup_nuts1 add column id serial PRIMARY KEY;

-- lookup_nuts2
drop table if exists lookup_nuts2 CASCADE;
-- create table lookup_lau1
create table lookup_nuts2
as
(
    select
    -- 	Standardize data by choosing a value
        coalesce(q1.code, q2.code) as code,
        coalesce(q1.name, q2.name) as name
    from
        (select nuts218cd as code, nuts218nm as name
        from local_authority
    -- 	remove duplicate row
        group by nuts218cd, nuts218nm) as q1
    -- 	merge table
    full outer join
        (select "NUTS218CD" as code, "NUTS218NM" as name
        from geo_level
    -- 	remove duplicate row
        group by "NUTS218CD", "NUTS218NM") as q2
    on q1.code = q2.code
);
alter table lookup_nuts2 add column id serial PRIMARY KEY;

-- lookup_nuts3
drop table if exists lookup_nuts3 CASCADE;
-- create table lookup_lau1
create table lookup_nuts3
as
(
    select
    -- 	Standardize data by choosing a value
        coalesce(q1.code, q2.code) as code,
        coalesce(q1.name, q2.name) as name
    from
        (select nuts318cd as code, nuts318nm as name
        from local_authority
    -- 	remove duplicate row
        group by nuts318cd, nuts318nm) as q1
    -- 	merge table
    full outer join
        (select "NUTS318CD" as code, "NUTS318NM" as name
        from geo_level
    -- 	remove duplicate row
        group by "NUTS318CD", "NUTS318NM") as q2
    on q1.code = q2.code
);
alter table lookup_nuts3 add column id serial PRIMARY KEY;

-- lookup_pc
drop table if exists lookup_pc CASCADE;
create table lookup_pc
as
    (
        with q2 as(SELECT DISTINCT ON (pcon19cd)
               pcon19cd as code , pcon19nm as name
        FROM   lau2_pc_la
        ORDER  BY code, name DESC),
        q1 as
        (
            select pcon as code
            from "ONSPD_MAY_2020_UK"
            group by pcon
        ),
        q3 as
        (
            select
            -- 	Standardize data by choosing a value
                coalesce(q1.code, q2.code) as code,
                coalesce(q2.name) as name
            from q2
            full outer join q1 on q2.code = q1.code
        )
        select distinct on(code) *
        from q3
        order by code, name desc
    );
alter table lookup_pc add column id serial PRIMARY KEY;

-- lookup_pcd
drop table if exists lookup_pcd CASCADE;
create table lookup_pcd
as
    (
        select pcdictrict.pcd
        from
        -- get postcode district from first 4 characters and remove space
            (select RTRIM(LEFT(pcd7,4),' ') as pcd
            from pcd_wd
            group by pcd
        -- 	combine data from pcd_wd, msoa_lsoa and "ONSPD_MAY_2020_UK" tables.
            union
            select RTRIM(LEFT(pcd7,4),' ') as pcd
            from msoa_lsoa
            group by pcd
            union
            select RTRIM(LEFT(pcd,4),' ') as pcd
            from "ONSPD_MAY_2020_UK"
            group by pcd
            ) as pcdictrict

    );
alter table lookup_pcd add column id serial PRIMARY KEY;



-- create lookup_geo_levels_code_table
-- "ONSPD_MAY_2020_UK"
drop table if exists onspd_uk CASCADE;
create table onspd_uk as
    (
        select pcd, oslaua, pcon
        from "ONSPD_MAY_2020_UK"
    );

drop table if exists pcd_msoa CASCADE;
create table pcd_msoa as
    (
        -- combine data from pcd_wd ,"ONSPD_MAY_2020_UK" and msoa_lsoa to get pcd7, lau1, lau2
        select coalesce(pcd_wd.pcd7, msoa_lsoa.pcd7) as pcd7,
                   coalesce(pcd_wd.lad11cd, msoa_lsoa.ladcd) as lau1,
                   pcd_wd.wd11cd as lau2
            from msoa_lsoa
            full outer join pcd_wd on msoa_lsoa.pcd7 = pcd_wd.pcd7
    );

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