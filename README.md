#Docker buid
$ docker-compose build
# run PostgresDB
$ docker-compose up db
# activate interactive bash shell on the container
$ docker-compose run --rm app /bin/bash
# import data to sql
$ python main.py -p {csv path} -t {table name} -m {mode} -c {special columns}

###### Ex: python main.py -p /app/data/lau2_pc_la.csv -t test
###### Ex: python main.py -p /app/data/ONSPD_MAY_2020_UK.csv -t test -c ru11ind

### database info:         
        dbname = "database"
        host = "db"
        port = "5432"
        user = "username"
        pwd = "secret"