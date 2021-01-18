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
    Q6 as
    (
        select
    -- 	Standardize data by choosing a value
        coalesce(q1.code, q2.code, q3.code, q4.code, q5.code) as code,
        coalesce(q1.name, q2.name, q3.name, q4.name, q5.name) as name
    from
        q1
    -- 	merge q1, q2, q3, q4, q5
    full outer join q2 on q1.code = q2.code
    full outer join q3 on q2.code = q3.code
    full outer join q4 on q3.code = q4.code
    full outer join q5 on q4.code = q5.code
    )
    select distinct on(code) *
    from Q6
    order by code, name desc
);
-- add primary key and id column
alter table lookup_lau1 add primary key (code),
    add column id serial;

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
alter table lookup_lau2 add primary key (code),
    add column id serial;

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
alter table lookup_nuts1 add primary key (code),
    add column id serial;

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
alter table lookup_nuts2 add primary key (code),
    add column id serial;

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
alter table lookup_nuts3 add primary key (code),
    add column id serial;

-- lookup_pc
drop table if exists lookup_pc CASCADE;
create table lookup_pc
as
    (
        with q2 as(SELECT DISTINCT ON (pcon19cd)
               pcon19cd as code , pcon19nm as name
        FROM   lau2_pc_la
        ORDER  BY code, name DESC)
        select *
        from q2
    );
alter table lookup_pc add primary key (code),
    add column id serial;

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
        -- 	combine data from pcd_wd and msoa_lsoa tables.
            union
            select RTRIM(LEFT(pcd7,4),' ') as pcd
            from msoa_lsoa
            group by pcd) as pcdictrict
    );
alter table lookup_pcd add primary key (pcd),
    add column id serial;

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
    add foreign key (lad19cd) references lookup_lau1(code);
--
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
-- insert data to local_authority_new table
into local_authority_new
from local_authority
left join Q3 on local_authority.lau218cd = Q3.lau2 and local_authority.lau118cd = Q3.lau1;
alter table local_authority_new add foreign key (lau218cd) references lookup_lau2(code),
    add foreign key (lau118cd) references lookup_lau1(code),
    add foreign key (nuts118cd) references lookup_nuts1(code),
    add foreign key (nuts218cd) references lookup_nuts2(code),
    add foreign key (nuts318cd) references lookup_nuts3(code);
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
-- pcd_wd_new table add foreign key
select *, RTRIM(LEFT(pcd_wd.pcd7, 4), ' ') as pcd
-- insert data to pcd_wd_new table
into pcd_wd_new
from pcd_wd;
alter table pcd_wd_new add foreign key (wd11cd) references lookup_lau2(code),
    add foreign key (lad11cd) references lookup_lau1(code),
    add foreign key (pcd) references lookup_pcd(pcd);
-- msoa_lsoa_new table add foreign key
select *, RTRIM(LEFT(msoa_lsoa.pcd7, 4), ' ') as pcd
-- insert data to msoa_lsoa table
into msoa_lsoa_new
from msoa_lsoa;
alter table msoa_lsoa_new add foreign key (ladcd) references lookup_lau1(code),
    add foreign key (pcd) references lookup_pcd(pcd);
--
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
        coalesce(local_authority_new.lau118cd, geo_level_new."LAU117CD") as lau1,
        coalesce(local_authority_new.lau218cd, geo_level_new."LAU217CD") as lau2,
        coalesce(local_authority_new.nuts318cd, geo_level_new."NUTS318CD") as nuts3,
        coalesce(local_authority_new.nuts218cd, geo_level_new."NUTS218CD") as nuts2,
        coalesce(local_authority_new.nuts118cd, geo_level_new."NUTS118CD") as nuts1
        from local_authority_new
        full outer join geo_level_new on local_authority_new.lau218cd = geo_level_new."LAU217CD" and local_authority_new.lau118cd = geo_level_new."LAU117CD"

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
               coalesce(Q4.lau1, lau2_pc_la_new.lad19cd) as lau1,
               coalesce(Q4.lau2, lau2_pc_la_new.wd19cd) as lau2,
               Q4.nuts1,
               Q4.nuts2,
               Q4.nuts3,
               lau2_pc_la_new.pcon19cd as pc
        from Q4
        full outer join lau2_pc_la_new on Q4.lau2 = lau2_pc_la_new.wd19cd and Q4.lau1 = lau2_pc_la_new.lad19cd
    )


select *
-- insert data to lookup_geo_levels table
into lookup_geo_levels
from Q5;
alter table lookup_geo_levels add foreign key (lau1) references lookup_lau1(code),
    add foreign key (lau2) references lookup_lau2(code),
    add foreign key (nuts1) references lookup_nuts1(code),
    add foreign key (nuts2) references lookup_nuts2(code),
    add foreign key (nuts3) references lookup_nuts3(code),
    add foreign key (pc) references lookup_pc(code),
    add foreign key (pcd) references lookup_pcd(pcd);



-- 1. import -> done.
--
-- 1.1-> writing script delete all table without tables imported from 1
-- delete table if exists geo_levels;
-- delete table if exists lookup_lau1;
-- delete table if exists lookup_lau1.....;
-- 2. insert pcd for each table if need.
-- create table look_pcd(
-- id int not null,
-- id int not null,
-- );
--
-- delete if exist conta..... ;
-- create contrait;
--
-- insert into look_up_pcd (code, name)
-- select code, name from...
--
-- 2. create table: look_up_*