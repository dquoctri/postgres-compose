#!/bin/bash

docker compose down;

docker volume rm -f postgres-compose_pgadmin postgres-compose_postgres;

docker compose build --no-cache;

read -n 1 -s -r -p "Press any key without 'power off' to continue!"
exit 0;
