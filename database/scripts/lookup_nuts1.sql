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