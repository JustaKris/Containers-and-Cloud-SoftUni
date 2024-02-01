@REM @echo off

docker network create mariadb_network

docker run -d ^
    --network mariadb_network ^
    --name mariadb ^
    --env MARIADB_USER=example-user ^
    --env MARIADB_PASSWORD=my_cool_secret ^
    --env MARIADB_ROOT_PASSWORD=my-secret-pw ^
    mariadb

docker run -it ^
    --network mariadb_network ^
    --name mariadb_client ^
    mariadb ^
    mariadb -hmariadb -uexample-user -pmy_cool_secret

@REM SELECT VERSION();

docker network inspect mariadb_network

docker stop mariadb_client mariadb ^
    && docker rm mariadb_client mariadb ^
    && docker network rm mariadb_network