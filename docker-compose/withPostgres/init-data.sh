#!/bin/bash
set -e

echo "Setting up PostgreSQL database with pgvector extension..."

# Create the pgvector extension in the n8n database
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE EXTENSION IF NOT EXISTS vector;
    \dx
EOSQL

# Create additional user if specified
if [ -n "${POSTGRES_NON_ROOT_USER:-}" ] && [ -n "${POSTGRES_NON_ROOT_PASSWORD:-}" ]; then
    echo "Creating additional user: ${POSTGRES_NON_ROOT_USER}"
    psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
        CREATE USER IF NOT EXISTS ${POSTGRES_NON_ROOT_USER} WITH PASSWORD '${POSTGRES_NON_ROOT_PASSWORD}';
        GRANT ALL PRIVILEGES ON DATABASE ${POSTGRES_DB} TO ${POSTGRES_NON_ROOT_USER};
        GRANT CREATE ON SCHEMA public TO ${POSTGRES_NON_ROOT_USER};
        GRANT USAGE ON SCHEMA public TO ${POSTGRES_NON_ROOT_USER};
        GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO ${POSTGRES_NON_ROOT_USER};
        GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO ${POSTGRES_NON_ROOT_USER};
        ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO ${POSTGRES_NON_ROOT_USER};
        ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON SEQUENCES TO ${POSTGRES_NON_ROOT_USER};
EOSQL
else
    echo "No additional user specified. Using default POSTGRES_USER."
fi

echo "PostgreSQL setup completed successfully!"
