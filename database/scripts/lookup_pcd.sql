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
alter table lookup_pcd add column id serial PRIMARY KEY;