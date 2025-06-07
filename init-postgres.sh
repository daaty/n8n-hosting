#!/bin/bash
set -e

echo "Initializing PostgreSQL with pgvector extension..."

# Criar extensão pgvector
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE EXTENSION IF NOT EXISTS vector;
    SELECT extname, extversion FROM pg_extension WHERE extname = 'vector';
EOSQL

echo "PostgreSQL with pgvector initialized successfully!"
