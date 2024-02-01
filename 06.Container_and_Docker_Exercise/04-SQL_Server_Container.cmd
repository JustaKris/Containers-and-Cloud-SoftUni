@echo off

docker volume create sqldata

@REM docker volume ls

docker run -d ^
    -e ACCEPT_EULA=y ^
    -e MSSQL_SA_PASSWORD=password ^
    -p 1433:1433 ^
    -v sqldata:/var/opt/mssql ^
    --name mssql_server_container ^
    mcr.microsoft.com/mssql/server

timeout /t 60

docker rm mssql_server_container
docker volume rm sqldata