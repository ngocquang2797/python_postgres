
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

###### Ex: python main.py -p /app/data/lau2_pc_la.csv -n test
###### Ex: python main.py -p /app/data/ONSPD_MAY_2020_UK.csv -n test -c ru11ind
###### Ex: python main.py -p /app/data/geo_level.geojson -n test7 -t geojson
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