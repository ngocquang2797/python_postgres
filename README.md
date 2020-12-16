#Docker buid
$ docker-compose build
# run PostgresDB
$ docker-compose up db
# activate interactive bash shell on the container
$ docker-compose run --rm app /bin/bash


### database info:         
        dbname = "database"
        host = "db"
        port = "5432"
        user = "username"
        pwd = "secret"
$ python main.py -p /app/data/lau2_pc_la.csv -t test