# Deploy n8n no Easypanel - Serviços Separados

Este guia mostra como instalar n8n com todas as dependências usando serviços separados no Easypanel.

## Ordem de Instalação

### 1. PostgreSQL com pgvector

**Passo 1: Criar Serviço PostgreSQL**
- No Easypanel, criar novo serviço
- Escolher "Build from Source"
- Repository: `https://github.com/daaty/n8n-hosting`
- Branch: `easypanel-custom-n8n`
- Build Context: `/`
- Dockerfile: `Dockerfile.postgres`

**Variáveis de Ambiente:**
```
POSTGRES_DB=n8n
POSTGRES_USER=n8n_user
POSTGRES_PASSWORD=SUA_SENHA_POSTGRES_FORTE
```

**Configurações:**
- Porta: 5432
- Volume: `/var/lib/postgresql/data`
- Nome do serviço: `n8n-postgres`

---

### 2. Redis (Opcional - para Queue/Workers)

**Passo 1: Criar Serviço Redis**
- No Easypanel, criar novo serviço
- Escolher "Build from Source"
- Repository: `https://github.com/daaty/n8n-hosting`
- Branch: `easypanel-custom-n8n`
- Build Context: `/`
- Dockerfile: `Dockerfile.redis`

**Configurações:**
- Porta: 6379
- Volume: `/data`
- Nome do serviço: `n8n-redis`

---

### 3. N8N com Playwright/Puppeteer

**Passo 1: Criar Serviço N8N**
- No Easypanel, criar novo serviço
- Escolher "Build from Source"
- Repository: `https://github.com/daaty/n8n-hosting`
- Branch: `easypanel-custom-n8n`
- Build Context: `/`
- Dockerfile: `Dockerfile`

**Variáveis de Ambiente:**
```
# Database
DB_TYPE=postgresdb
DB_POSTGRESDB_HOST=n8n-postgres
DB_POSTGRESDB_PORT=5432
DB_POSTGRESDB_DATABASE=n8n
DB_POSTGRESDB_USER=n8n_user
DB_POSTGRESDB_PASSWORD=SUA_SENHA_POSTGRES_FORTE

# Authentication
N8N_BASIC_AUTH_ACTIVE=true
N8N_BASIC_AUTH_USER=admin
N8N_BASIC_AUTH_PASSWORD=SUA_SENHA_ADMIN_FORTE

# General
WEBHOOK_URL=https://seu-dominio.easypanel.host
GENERIC_TIMEZONE=America/Sao_Paulo
N8N_LOG_LEVEL=info

# Security
N8N_SECURE_COOKIE=false
N8N_ENCRYPTION_KEY=SUA_CHAVE_CRIPTOGRAFIA

# Browser Automation
PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser
PLAYWRIGHT_BROWSERS_PATH=/home/node/.cache/playwright

# Optional: Redis (se criou o serviço Redis)
# QUEUE_BULL_REDIS_HOST=n8n-redis
# QUEUE_BULL_REDIS_PORT=6379
# EXECUTIONS_MODE=queue
```

**Configurações:**
- Porta: 5678
- Volume: `/home/node/.n8n`
- Nome do serviço: `n8n-app`

---

## Vantagens desta Abordagem

1. **Isolamento**: Cada serviço pode ser atualizado independentemente
2. **Escalabilidade**: Pode escalar cada serviço conforme necessário
3. **Debugging**: Mais fácil identificar problemas específicos
4. **Flexibilidade**: Pode usar PostgreSQL/Redis externos se preferir
5. **Manutenção**: Upgrades mais controlados

## Ordem de Inicialização

1. Primeiro: PostgreSQL
2. Segundo: Redis (se usando)
3. Terceiro: N8N

## Testes após Deploy

1. **PostgreSQL**: Verificar se pgvector está instalado
2. **N8N**: Acessar interface web
3. **Playwright/Puppeteer**: Criar workflow de teste com automação web

## Resolução de Problemas

- **N8N não conecta no PostgreSQL**: Verificar se os nomes dos serviços estão corretos
- **Playwright/Puppeteer não funciona**: Verificar logs do container n8n
- **Performance ruim**: Considerar aumentar recursos dos containers
