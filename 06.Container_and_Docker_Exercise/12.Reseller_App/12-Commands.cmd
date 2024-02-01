echo off

mvn clean package -DskipTests

docker build -t resellerapp .

docker-compose build

docker-compose up -d

docker-compose down --volumes