@echo off

::Install packages locally for both frontend and backend
npm install

::Run dockerfiles
docker build -t goals-frontend .
docker build -t goals-backend .

::Pull Mongo image
docker pull mongo

::Create network
docker network create goals

::Create volumes
docker volume create data
docker volume create logs
docker volume create node_modules

::Run docker containers (used to set up docker-compose.yml later using composerize)
docker run -d --name mongodb --network goals -e MONGO_INITDB_ROOT_USERNAME=max -e MONGO_INITDB_ROOT_PASSWORD=secret -v data:/data/db mongo
docker run -d --name backend --network goals -p 80:80 -v logs:/logs -v node_modules:/node_modules goals-backend
docker run -d --name frontend --network goals -p 3000:3000 -v .\frontend\src:/src goals-frontend

::Login in order to be able to push container images to DockerHub
docker login

::Rename images to prep them for being pushed to DockerHub
docker tag goals-backend justakris/goals-backend
docker tag goals-frontend justakris/goals-frontend

::Push new images
docker push justakris/goals-backend
docker push justakris/goals-frontend

::Run docker compose file
docker-compose build
docker-compose up -d

::Destruction!!!!
docker-compose down --volumes