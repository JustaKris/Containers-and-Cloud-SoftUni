echo off

docker login azure

docker context create aci nginxacicontext

docker context ls

docker context use nginxacicontext

docker context ls

docker run -d -p 80:80 nginxdemos/hello

docker ps