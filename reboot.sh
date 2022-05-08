#!/bin/bash

docker compose down;

docker volume rm -f postgres-compose_pgdata postgres-compose_pgadmin;

docker compose build --no-cache;

# docker compose --env-file ./demo.env up -d;
docker compose up -d;

read -n 1 -s -r -p "Press any key without 'power off' to continue!"
exit 0;
