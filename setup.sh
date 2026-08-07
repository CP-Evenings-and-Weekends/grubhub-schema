#!/bin/bash
# Build the image and start a Postgres container, then drop into psql.
# Edit init.sql with your CREATE DATABASE / CREATE TABLE / INSERT statements
# first, then re-run this script.
--------------------------------------------

docker build -t grubhub_db .
docker run --name yummy_food -e POSTGRES_PASSWORD=password -e POSTGRES_DB=grubhub -p 5432:5432 -d grubhub_db
docker ps -a

docker start yummy_food
docker exec -it yummy_food bash
psql -U postgres -d grubhub

forward slash q to exit #
type exit to exit the root


stop and remove container then remove image
docker rm -f runner
docker rmi grubhub_db

docker volume ls
docker volume rm (volume name)
