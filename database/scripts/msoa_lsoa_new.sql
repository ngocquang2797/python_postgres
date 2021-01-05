select *, RTRIM(LEFT(msoa_lsoa.pcd7, 4), ' ') as pcd
-- insert data to msoa_lsoa table
into msoa_lsoa_new
from msoa_lsoa;