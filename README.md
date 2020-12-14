#Docker buid
$ docker-compose build
# run PostgresDB
$ docker-compose up db
# activate interactive bash shell on the container
$ docker-compose run --rm app /bin/bash