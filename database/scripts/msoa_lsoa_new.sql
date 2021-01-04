select *, RTRIM(LEFT(msoa_lsoa.pcd7, 4), ' ') as pcd
from msoa_lsoa;