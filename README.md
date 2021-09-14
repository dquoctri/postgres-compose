# postgres-compose
PostgreSQL &amp; Pgadmin4 powered by docker-compose. This repository is a template of docker-compose for running the PostgresSQL database and Pgadmin database management system. The template is reusable for all applications that use the PostgreSQL database on docker-compose. There is an overview of the technologies used.

# [PostgreSQL](https://www.postgresql.org/)
> PostgreSQL is a powerful, open source object-relational database system that uses and extends the SQL language combined with many features that safely store and scale the most complicated data workloads.

# [pgAdmin](https://www.pgadmin.org/)
> pgAdmin is the most popular and feature rich Open Source administration and development platform for PostgreSQL, the most advanced Open Source database in the world.

# [Docker](https://docs.docker.com/get-started/overview)
> Docker is an open platform for developing, shipping, and running applications. Docker enables you to separate your applications from your infrastructure so you can deliver software quickly. With Docker, you can manage your infrastructure in the same ways you manage your applications. By taking advantage of Docker’s methodologies for shipping, testing, and deploying code quickly, you can significantly reduce the delay between writing code and running it in production.

# [Docker Compose](https://docs.docker.com/compose/)
> Compose is a tool for defining and running multi-container Docker applications. With Compose, you use a YAML file to configure your application’s services. Then, with a single command, you create and start all the services from your configuration.

# Prerequisities
Docker and docker-compose are required in order to run this app successfully
* docker >= 19.03.0+
* docker-compose

You can download and install Docker on multiple platforms. Refer to the [following section](https://docs.docker.com/get-docker/) and choose the best installation path for you.

Check the version of docker to make sure docker is installed

```
docker --version
```
> Docker version 20.10.7, build f0df350

# Quick Start

Clone this repository first:

```
git clone https://github.com/dquoctri/postgres-compose.git
cd postgres-compose
```
The following commands need to be run docker compose:

```
docker compose --env-file ./demo.env up -d
```

# Details
## Code structure

Here’s a documentation project structure

![image](https://user-images.githubusercontent.com/87698179/133060876-5d9e7652-2932-4360-b02a-d32bdbacf3c6.png)


## docker-compose.yml

```
version: '3.9'

services:
  postgres_db:
    container_name: postgres_container
    image: "postgres:${POSTGRES_VERSION:-latest}"
    environment:
      TZ: Etc/UTC
      POSTGRES_INITDB_ARGS: '--locale=en_US.UTF-8 --encoding=UTF8 --auth-host=scram-sha-256 --auth-local=scram-sha-256'
      POSTGRES_HOST_AUTH_METHOD: scram-sha-256
      POSTGRES_DB: ${POSTGRES_DB:-postgres}
      POSTGRES_USER: ${POSTGRES_USER:-postgres}
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD:-postgres}
      POSTGRES_APP_SCHEMA: ${POSTGRES_APP_SCHEMA:-demo_sche}
      POSTGRES_APP_USER: ${POSTGRES_APP_USER:-demo}
      POSTGRES_APP_PASSWORD: ${POSTGRES_APP_PASSWORD:-demo}
      POSTGRES_APP_CONNECTION_LIMIT: ${POSTGRES_APP_CONNECTION_LIMIT:--1}
      PGDATA: '/var/lib/postgresql/data/pgdata'
    volumes:
      - postgres:/var/lib/postgresql/data
      - ${POSTGRES_CONFIG_DIR:-./.config/postgres}/pg_hba.conf:/etc/postgresql/pg_hba.conf
      - ${POSTGRES_CONFIG_DIR:-./.config/postgres}/postgresql.conf:/etc/postgresql/postgresql.conf
      - ${POSTGRES_CONFIG_DIR:-./.config/postgres}/sql/:/docker-entrypoint-initdb.d/
    command: '-c config_file="/etc/postgresql/postgresql.conf"'
    ports:
      - "${POSTGRES_PORT:-5432}:5432"
    networks:
      - env_net
    restart: always
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U ${POSTGRES_USER:-postgres} -h localhost"]
      interval: 30s
      timeout: 5s
      retries: 3

  pgadmin:
    container_name: pgadmin_container
    image: "dpage/pgadmin4:${PGADMIN_VERSION:-latest}"
    environment:
      PGADMIN_DEFAULT_EMAIL: ${PGADMIN_DEFAULT_EMAIL:-pgadmin4@pgadmin.org}
      PGADMIN_DEFAULT_PASSWORD: ${PGADMIN_DEFAULT_PASSWORD:-SuperSecret}
      PGADMIN_CONFIG_SERVER_MODE: "False"
      PGADMIN_CONFIG_MASTER_PASSWORD_REQUIRED: "False"
    volumes:
      - pgadmin:/var/lib/pgadmin
      - ${PGADMIN_CONFIG_DIR:-./.config/pgadmin4}/servers.json:/pgadmin4/servers.json
    ports:
      - "${PGADMIN_PORT:-5050}:80"
    networks:
      - env_net
    restart: unless-stopped

networks:
  env_net:
    external: true

volumes:
  postgres:
  pgadmin:
```

## Note
> Both **$VARIABLE** and **${VARIABLE}** syntax are supported. Additionally when using the 2.1 file format, it is possible to provide inline default values using typical shell syntax:
> 
> - **${VARIABLE:-default}** evaluates to `default` if `VARIABLE` is unset or empty in the environment.
> - **${VARIABLE-default}** evaluates to `default` only if `VARIABLE` is unset in the environment.
> 
> Similarly, the following syntax allows you to specify mandatory variables:
> 
> - **${VARIABLE:?err}** exits with an error message containing `err` if `VARIABLE` is unset or empty in the environment.
> - **${VARIABLE?err}** exits with an error message containing `err` if `VARIABLE` is unset in the environment.
> 
> Other extended shell-style features, such as **${VARIABLE/foo/bar}**, are not supported.
> 
> You can use a `$$` (double-dollar sign) when your configuration needs a literal dollar sign. This also prevents Compose from interpolating a value, so a `$$` allows you to refer > to environment variables that you don’t want processed by Compose.


## Environments

Set environment variables used by the system in ./*.env file (Copy the sample in demo.env file, example: dev.env, prod.env and .env by default) with specific version of [PostgesSQL](https://hub.docker.com/_/postgres) and [PgAdmin](https://www.pgadmin.org/docs/pgadmin4/latest/container_deployment.html) images. 

```
# Environment variables 
# Postgres version base on postgres Official Image (https://hub.docker.com/_/postgres)
POSTGRES_CONFIG_DIR='./demo.config/postgres'
POSTGRES_VERSION=13
POSTGRES_DB=postgres
POSTGRES_USER=postgres
POSTGRES_PASSWORD=postgres
POSTGRES_PORT=15432

# Account be used to make connection in application
POSTGRES_APP_SCHEMA=app_sche
POSTGRES_APP_USER=app
POSTGRES_APP_PASSWORD=app
POSTGRES_APP_CONNECTION_LIMIT=4

# refer to the dpage/pgadmin4 docker image (https://hub.docker.com/r/dpage/pgadmin4)
PGADMIN_CONFIG_DIR='./demo.config/pgadmin4'
PGADMIN_VERSION=5.7
PGADMIN_DEFAULT_EMAIL=pgadmin4@pgadmin.org
PGADMIN_DEFAULT_PASSWORD=pgadmin4
PGADMIN_PORT=5050
```

Create a expected config for the environment follow by demo config structure and update 2 environment variables below: 
```
POSTGRES_CONFIG_DIR='<postgres_config_dir>' (./dev.config/postgres, ./prod.config/postgres and ./.config/postgres by default)
...
PGADMIN_CONFIG_DIR='./pgadmin_config_dir' (./dev.config/pgadmin4, ./prod.config/pgadmin4 and ./.config/pgadmin4 by default)
...
```

by defualt `./.config/postgres`

## Add init SQL scripts in PostgresSQL
All the scripts will be executed when creating Postgres volume by alphabetical order so we should create files with prefix.

![image](https://user-images.githubusercontent.com/87698179/133064087-7e03a824-855a-4c61-8021-2054a68019cd.png)

```
  volumes:
      - postgres:/var/lib/postgresql/data
      - ${POSTGRES_CONFIG_DIR:-./.config/postgres}/pg_hba.conf:/etc/postgresql/pg_hba.conf
      - ${POSTGRES_CONFIG_DIR:-./.config/postgres}/postgresql.conf:/etc/postgresql/postgresql.conf
      - ${POSTGRES_CONFIG_DIR:-./.config/postgres}/sql/:/docker-entrypoint-initdb.d/
  command: '-c config_file="/etc/postgresql/postgresql.conf"'
```

> If you would like to do additional initialization in an image derived from this one, add one or more `*.sql`, `*.sql.gz`, or `*.sh` scripts under /docker-entrypoint-initdb.d (creating the directory if necessary). After the entrypoint calls initdb to create the default postgres user and database, it will run any `*.sql` files, run any executable *.sh scripts, and source any non-executable `*.sh` scripts found in that directory to do further initialization before starting the service.

> *Warning*: scripts in /docker-entrypoint-initdb.d are only run if you start the container with a data directory that is empty; any pre-existing database will be left untouched on container startup. One common problem is that if one of your /docker-entrypoint-initdb.d scripts fails (which will cause the entrypoint script to exit) and your orchestrator restarts the container with the already initialized data directory, it will not continue on with your scripts.

> For example, to add an additional user and database, add the following to /docker-entrypoint-initdb.d/init-user-db.sh:

```
#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE USER docker;
    CREATE DATABASE docker;
    GRANT ALL PRIVILEGES ON DATABASE docker TO docker;
EOSQL
```

## Add default Server in PgAdmin:

```
volumes:
   - ./.config/pgadmin4/servers.json:/pgadmin4/servers.json
```

File `./.config/pgadmin4/servers.json`

```
{
  "Servers": {
    "1": {
      "Name": "Default Server",
      "Group": "Servers",
      "Host": "postgres_db",
      "Port": 5432,
      "MaintenanceDB": "postgres",
      "Username": "postgres",
      "SSLMode": "prefer",
      "SSLCert": "<STORAGE_DIR>/.postgresql/postgresql.crt",
      "SSLKey": "<STORAGE_DIR>/.postgresql/postgresql.key",
      "SSLCompression": 0,
      "Timeout": 10,
      "UseSSHTunnel": 0,
      "TunnelPort": "22",
      "TunnelAuthentication": 0
    },
    "2": {
      "Name": "Application Server",
      "Group": "Servers",
      "Host": "postgres_db",
      "Port": 5432,
      "MaintenanceDB": "postgres",
      "Username": "app", 
      "SSLMode": "prefer",
      "SSLCert": "<STORAGE_DIR>/.postgresql/postgresql.crt",
      "SSLKey": "<STORAGE_DIR>/.postgresql/postgresql.key",
      "SSLCompression": 0,
      "Timeout": 10,
      "UseSSHTunnel": 0,
      "TunnelPort": "22",
      "TunnelAuthentication": 0
    }
  }
}
```
Update servers.json to manage database easier by default connection.
Update `Servers.2.Username` field to make it similer with the `POSTGRES_APP_USER` variable.

![image](https://user-images.githubusercontent.com/87698179/133065688-69f3a6c0-9337-490b-a1ac-0805ac9b1cd6.png)


# Manage database
## Access to PgAdmin: 
* **URL:** [http://localhost:PGADMIN_PORT](http://localhost:5050), by default: `5050`
* **Username:** as PGADMIN_DEFAULT_EMAIL, by default `pgadmin4@pgadmin.org`
* **Password:** as PGADMIN_DEFAULT_PASSWORD, by default `SuperSecret`

## open or add new Server in PgAdmin:
* **Host name/address** `postgres`
* **Port** `5432`
* **Username** as `POSTGRES_USER`, by default: `postgres`
* **Password** as `POSTGRES_PASSWORD`, by default: `password`

## create a connection in DBeaver:
* **Host name/address** `postgres`
* **Port** as `POSTGRES_PORT`, by default: `15432`
* **Username** as `POSTGRES_USER`, by default: `postgres`
* **Password** as `POSTGRES_PASSWORD`, by default: `password`

