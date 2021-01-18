
## Step 1: Docker build
$ docker-compose build
## Step 2: run PostgresDB
$ docker-compose up db
## Step 3: activate interactive bash shell on the container
$ docker-compose run --rm app /bin/bash
## Step 4: import data to sql
$ python main.py -p {csv path} -n {table name} -m {mode} -t {type of file} -c {special columns}

##### - type of file: csv or geojson
##### - special columns: columns have mixed types

###### Ex: python main.py -p /app/data/local_authority -n local_authority
###### Ex: python main.py -p /app/data/msoa_lsoa.csv -n msoa_lsoa
###### Ex: python main.py -p /app/data/lau2_pc_la.csv -n lau2_pc_la
###### Ex: python main.py -p /app/data/ONSPD_MAY_2020_UK.csv -n ONSPD_MAY_2020_UK -c ru11ind
###### Ex: python main.py -p /app/data/geo_level.geojson -n geo_level -t geojson
###### Ex: python main.py -p /app/data/pcd11_par11_wd11_lad11_ew_lu.csv -n pcd_wd -c par11nmw wd11nmw lad11nmw



### database info:         
        dbname = "database"
        host = "db"
        port = "5432"
        user = "username"
        pwd = "secret"
        
## Access database from local:
        dbname = "database"
        host = "local"
        port = "5433"
        user = "username"
        pwd = "secret"
        
#### sql scripts folder: /database/scripts
#### expanded table: pcd_wd: 
https://ons.maps.arcgis.com/sharing/rest/content/items/c4aeb11ff5b045018b7340e807d645cb/data


## SQL scripts
+ Add pcd colum to msoa_lsoa and pcd_wd table: pcd_wd_new.sql, msoa_lsoa_new.sql

+ create lookup table:
    - lookup_pcd.sql
    - lookup_pc.sql
    - lookup_lau1.sql
    - lookup_lau2.sql
    - lookup_nuts1.sql
    - lookup_nuts2.sql
    - lookup_nuts3.sql
 
+ create lookup_geo_levels table: lookup_geo_levels.sql

+ run all scripts: test.sql