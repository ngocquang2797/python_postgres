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
                coalesce(q1.name) as name
            from q2
            full outer join q1 on q2.code = q1.code
        )
        select distinct on(code) *
        from q3
        order by code, name desc
    );
alter table lookup_pc add column id serial PRIMARY KEY;