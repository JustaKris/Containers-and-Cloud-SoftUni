@echo off

docker network create taskboard_network

docker run ^
    -e ACCEPT_EULA=y ^
    -e MSSQL_SA_PASSWORD=myStrongPassword12# ^
    -p 1433:1433 ^
    -v sqldata:/var/opt/mssql ^
    --network taskboard_network ^
    --name sqlserver ^
    -d mcr.microsoft.com/mssql/server

docker build -t justakris/taskboard_app -f TaskBoard.WebApp\Dockerfile .

docker run -d -p 5000:80 --name taskboard --network taskboard_network justakris/taskboard_app

docker network inspect taskboard_network

docker stop taskboard sqlserver ^
    & docker rm taskboard sqlserver ^
    & docker network rm taskboard_network

docker push justakris/taskboard_app