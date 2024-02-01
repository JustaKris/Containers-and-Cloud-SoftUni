echo off

::Pull images
docker pull postgres
docker pull redis

::Setup networks
docker network create frontend
docker network create backend

::Create volumes
docker volume create db
docker volume create vote
docker volume create result

::Run Dockerfiles (after creating them)
docker build -t result -f result/Dockerfile vote
docker build -t vote -f vote/Dockerfile result
docker build -t worker -f worker/Dockerfile worker

:: Run containers
docker run -d --name vote --network frontend -p 5000:80 -v vote:/app vote
docker run -d --name result --network frontend -p 5001:80 -v result:/app result
docker run -d --name worker --network backend worker
docker run -d --name redis --network backend redis
docker run -d --name db --network backend -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=postgres -v db:/var/lib/postgresql/data postgres

::Manage networks
docker network connect backend vote
docker network connect backend result

::Kill everything
docker stop vote result worker redis db
docker rm vote result worker redis db
docker network rm frontend backend
docker volume rm db vote result

::Docker compose commands
docker compose build
docker compose up -d
docker compose down --volumes