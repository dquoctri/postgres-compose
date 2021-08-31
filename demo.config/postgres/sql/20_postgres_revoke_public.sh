#!/bin/bash
set -e

# --Public schema is not allows in applications
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    REVOKE CONNECT ON DATABASE postgres FROM PUBLIC;
    REVOKE CONNECT ON DATABASE $POSTGRES_DB FROM PUBLIC;
    REVOKE ALL ON SCHEMA public FROM PUBLIC;
EOSQL