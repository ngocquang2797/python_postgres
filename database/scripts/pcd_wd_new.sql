-- add pcd column to pcd_wd table
drop table if exists pcd_wd_new CASCADE ;
create table pcd_wd_new
as
(
    select *, RTRIM(LEFT(pcd_wd.pcd7, 4), ' ') as pcd
    from pcd_wd
);