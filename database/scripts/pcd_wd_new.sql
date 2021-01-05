select *, RTRIM(LEFT(pcd_wd.pcd7, 4), ' ') as pcd
-- insert data to pcd_wd_new table
into pcd_wd_new
from pcd_wd;