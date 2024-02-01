@echo off

::Build frontend image
docker build -t frontend ./frontend

::Build backend image
docker build -t backend ./backend

::Create networks
docker network create react-express
docker network create express-mongo

::Run containers
docker run -d --network express-mongo --name mongo -v ./data:/data/db mongo:latest
docker run -d --network react-express --name frontend -p 3000:3000 frontend
docker run -d --network express-mongo --name backend backend

::Connect networks to backend separately
docker network connect react-express backend

::Cleanup
timeout /t 60
docker stop frontend backend mongo
docker rm frontend backend mongo
docker network rm react-express express-mongo
docker image rm frontend frontend_image backend