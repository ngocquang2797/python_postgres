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
alter table lookup_pc add column id serial PRIMARY KEY;