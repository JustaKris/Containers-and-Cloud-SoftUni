@echo off

::Build docker images
docker build -t justakris/shopping-list-frontend .
docker build -t justakris/shopping-list-backend .

::Pull Mongo image
docker pull mongo

::Create network
docker network create shopping-list

::Create volumes
docker volume create data
docker volume create logs
docker volume create node_modules

::Run docker containers (used to set up docker-compose.yml later using composerize)
docker run -d --name mongodb --network shopping-list -e MONGO_INITDB_ROOT_USERNAME=max -e MONGO_INITDB_ROOT_PASSWORD=secret -v data:/data/db mongo
docker run -d --name backend --network shopping-list -p 80:80 -v logs:/logs -v node_modules:/node_modules justakris/shopping-list-backend
docker run -d --name frontend --network shopping-list -p 3000:3000 -v .\frontend\src:/src justakris/shopping-list-frontend

::Login in and push container images to DockerHub
docker login
docker push justakris/shopping-list-backend
docker push justakris/shopping-list-frontend

::Run docker-compose file
docker-compose build
docker-compose up -d

::Destruction!!!!
docker-compose down --volumes