select
	row_number() over(order by pcdictrict.pcd) as fid,
	pcdictrict.pcd
from
	(select RTRIM(LEFT(pcd7,4),' ') as pcd
	from pcd_wd
	group by pcd
	union
	select RTRIM(LEFT(pcd7,4),' ') as pcd
	from msoa_lsoa
	group by pcd) as pcdictrict;