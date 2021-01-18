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