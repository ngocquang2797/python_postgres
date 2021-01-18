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