#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    -- DROP ROLE $POSTGRES_APP_USER;
    CREATE ROLE $POSTGRES_APP_USER WITH INHERIT LOGIN PASSWORD '$POSTGRES_APP_PASSWORD' CONNECTION LIMIT $POSTGRES_APP_CONNECTION_LIMIT;

    -- DROP SCHEMA $POSTGRES_APP_SCHEMA CASCADE;
    -- CREATE SCHEMA IF NOT EXISTS $POSTGRES_APP_SCHEMA AUTHORIZATION $POSTGRES_APP_USER;
    CREATE SCHEMA IF NOT EXISTS $POSTGRES_APP_SCHEMA;

    -- GRANT
    GRANT CONNECT ON DATABASE $POSTGRES_DB TO $POSTGRES_APP_USER;
    GRANT USAGE, CREATE ON SCHEMA $POSTGRES_APP_SCHEMA TO $POSTGRES_APP_USER;
EOSQL