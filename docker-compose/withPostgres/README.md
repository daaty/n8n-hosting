# n8n Custom with PostgreSQL + pgvector, Playwright & Puppeteer

Starts n8n with PostgreSQL as database including pgvector extension, Playwright, and Puppeteer pre-installed.

## Features

- **n8n**: Latest version with custom build
- **PostgreSQL**: With pgvector extension for vector operations
- **Playwright**: Pre-installed for browser automation
- **Puppeteer**: Pre-installed for web scraping
- **Custom nodes**: Support for playwright and puppeteer community nodes

## Easypanel Deployment

### 1. Fork this repository to your GitHub account

### 2. In Easypanel:

1. Create a new service
2. Choose "Build" → "Dockerfile"
3. Connect your forked GitHub repository
4. Set the build context to this folder (`docker-compose/withPostgres`)
5. Leave Dockerfile path as `Dockerfile`

### 3. Environment Variables

Configure these environment variables in Easypanel:

```env
POSTGRES_USER=your_db_user
POSTGRES_PASSWORD=your_strong_password
POSTGRES_DB=n8n
POSTGRES_NON_ROOT_USER=your_db_user
POSTGRES_NON_ROOT_PASSWORD=your_strong_password
DB_TYPE=postgresdb
DB_POSTGRESDB_HOST=postgres
DB_POSTGRESDB_PORT=5432
DB_POSTGRESDB_DATABASE=n8n
DB_POSTGRESDB_USER=your_db_user
DB_POSTGRESDB_PASSWORD=your_strong_password
```

### 4. PostgreSQL Service

Create a separate PostgreSQL service in Easypanel:

- Use image: `pgvector/pgvector:pg16`
- Set the same database credentials

## Local Development

**IMPORTANT:** Change the default users and passwords in the [`.env`](.env) file!

```bash
docker-compose up -d
```

To stop:

```bash
docker-compose stop
```

## Available Tools

After deployment, your n8n instance will have:

- Full Playwright browser automation capabilities
- Puppeteer for web scraping
- PostgreSQL with pgvector for AI/vector operations
- All standard n8n functionality

## Configuration

Database configuration can be changed in the [`.env`](.env) file.
