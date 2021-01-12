select *, RTRIM(LEFT(msoa_lsoa.pcd7, 4), ' ') as pcd
-- insert data to msoa_lsoa table
into msoa_lsoa_new
from msoa_lsoa;
alter table msoa_lsoa_new add foreign key (ladcd) references lookup_lau1(code),
    add foreign key (pcd) references lookup_pcd(pcd);