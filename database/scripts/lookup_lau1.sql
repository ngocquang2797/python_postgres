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
alter table lookup_lau1 add column id serial PRIMARY KEY;