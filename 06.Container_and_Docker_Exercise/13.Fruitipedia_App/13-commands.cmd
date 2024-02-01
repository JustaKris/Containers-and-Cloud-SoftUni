echo off

docker build -t simpleapp .

docker-compose build

docker-compose up -d

docker compose down --volumes