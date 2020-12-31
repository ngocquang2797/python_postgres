select
-- numbered id
	row_number() over(order by pcdictrict.pcd) as fid,
	pcdictrict.pcd
-- insert into lookup_pcd table
into lookup_pcd
from
-- get postcode district from first 4 characters and remove space
	(select RTRIM(LEFT(pcd7,4),' ') as pcd
	from pcd_wd
	group by pcd
-- 	combine data from pcd_wd and msoa_lsoa tables.
	union
	select RTRIM(LEFT(pcd7,4),' ') as pcd
	from msoa_lsoa
	group by pcd) as pcdictrict;