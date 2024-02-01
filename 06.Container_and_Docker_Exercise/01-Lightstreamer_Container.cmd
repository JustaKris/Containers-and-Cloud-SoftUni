@echo off

docker run -d --rm --name ls-server -p 80:8080 lightstreamer

timeout /t 60

docker stop lightstreamer