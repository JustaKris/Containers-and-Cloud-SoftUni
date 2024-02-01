@echo off

docker build -t taskboard_app -f TaskBoard.WebApp\Dockerfile .

docker image ls

docker push justakris/taskboard_app

docker stop taskboard_app & docker rm taskboard_app