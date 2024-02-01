@echo off

docker compose build

docker compose up

docker compose down --rmi all --volumes