#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    -- DROP ROLE app_user;
    CREATE ROLE app_user WITH INHERIT LOGIN PASSWORD 'app_user' CONNECTION LIMIT 4;

    -- DROP SCHEMA app_schema CASCADE;
    -- CREATE SCHEMA IF NOT EXISTS app_schema AUTHORIZATION app_user;
    CREATE SCHEMA IF NOT EXISTS app_schema;

    -- GRANT
    GRANT CONNECT ON DATABASE $POSTGRES_DB TO app_user;
    GRANT USAGE, CREATE ON SCHEMA app_schema TO app_user;
EOSQL