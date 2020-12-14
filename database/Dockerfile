FROM postgres:latest
ENV POSTGRES_PASSWORD=secret
ENV POSTGRES_USER=username
ENV POSTGRES_DB=database
# Host: db
# port: 5432
COPY create_fixtures.sql /docker-entrypoint-initdb.d/create_fixtures.sql