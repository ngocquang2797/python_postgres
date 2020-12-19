
## Step 1: Docker build
$ docker-compose build
## Step 2: run PostgresDB
$ docker-compose up db
## Step 3: activate interactive bash shell on the container
$ docker-compose run --rm app /bin/bash
## Step 4: import data to sql
$ python main.py -p {csv path} -t {table name} -m {mode} -c {special columns}


###### Ex:root@:/app/app# python main.py -p /app/data/lau2_pc_la.csv -t test
###### Ex:root@:/app/app# python main.py -p /app/data/ONSPD_MAY_2020_UK.csv -t test -c ru11ind
###### Ex:root@:/app/app# python main.py -p /app/data/geo_level.geojson -n test7 -t geojson


### database info:         
        dbname = "database"
        host = "db"
        port = "5432"
        user = "username"
        pwd = "secret"