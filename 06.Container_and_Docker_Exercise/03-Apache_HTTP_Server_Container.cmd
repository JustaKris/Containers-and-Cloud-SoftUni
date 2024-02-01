@echo off

docker run -d --rm ^
    --name my_apache_app ^
    -e NODE_ENV=development ^
    -p 8080:80 ^
    -v %cd%:/usr/local/apache2/htdocs/ ^
    httpd

timeout /t 60 /nobreak

docker stop my_apache_app