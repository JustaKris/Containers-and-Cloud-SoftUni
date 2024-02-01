@echo off

docker run -d --rm ^
    --name ghost-container ^
    -e NODE_ENV=development ^
    -p 3001:2368 ^
    ghost

timeout /t 60

docker stop ghost-container