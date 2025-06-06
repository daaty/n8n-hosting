# Deploy n8n no Easypanel - Serviços Separados

Guia para criar serviços individuais no Easypanel para n8n customizado.

## 🎯 Abordagem: Serviços Separados

Ao invés de usar docker-compose, vamos criar **2 serviços separados**:
1. **PostgreSQL** (com pgvector)
2. **n8n** (customizado com Playwright/Puppeteer)

## 📦 Passo 1: Criar Serviço PostgreSQL

### Via Interface Easypanel:
1. **Create Service** → **Database** → **PostgreSQL**
2. **Configurações**:
   - **Project Name**: `n8n-custom`
   - **Service Name**: `postgres`
   - **PostgreSQL Version**: Use custom image: `pgvector/pgvector:pg16`
   - **Database**: `n8n`
   - **Username**: `n8n_user`
   - **Password**: `sua_senha_forte_123`

### Via Template JSON:
```json
{
  "type": "postgres",
  "data": {
    "projectName": "n8n-custom",
    "serviceName": "postgres",
    "image": "pgvector/pgvector:pg16",
    "password": "sua_senha_forte_123",
    "username": "n8n_user",
    "database": "n8n"
  }
}
```

## 🚀 Passo 2: Criar Serviço n8n

### Via Interface Easypanel:
1. **Create Service** → **App**
2. **Configurações**:
   - **Project Name**: `n8n-custom` (mesmo do PostgreSQL)
   - **Service Name**: `n8n`
   - **Source**: GitHub
   - **Repository**: `daaty/n8n-hosting`
   - **Branch**: `easypanel-custom-n8n`
   - **Build Type**: `Dockerfile`
   - **Dockerfile Path**: `docker-compose/withPostgres/Dockerfile`

3. **Environment Variables**:
```
DB_TYPE=postgresdb
DB_POSTGRESDB_HOST=n8n-custom_postgres
DB_POSTGRESDB_PORT=5432
DB_POSTGRESDB_DATABASE=n8n
DB_POSTGRESDB_USER=n8n_user
DB_POSTGRESDB_PASSWORD=sua_senha_forte_123
N8N_BASIC_AUTH_ACTIVE=true
N8N_BASIC_AUTH_USER=admin
N8N_BASIC_AUTH_PASSWORD=sua_senha_admin_123
WEBHOOK_URL=https://n8n.seudominio.com
GENERIC_TIMEZONE=America/Sao_Paulo
N8N_LOG_LEVEL=info
```

4. **Port**: `5678`

5. **Domain**: Configure seu domínio
   - **Host**: `n8n.seudominio.com`
   - **Port**: `5678`
   - **HTTPS**: ✅

6. **Storage** (Volume):
   - **Mount Path**: `/home/node/.n8n`
   - **Volume Name**: `n8n-data`

## 🔗 Comunicação entre Serviços

No Easypanel, serviços no mesmo projeto se comunicam via:
```
HOSTNAME: {project-name}_{service-name}
```

**Exemplo**:
- Project: `n8n-custom`
- PostgreSQL Service: `postgres`
- **Hostname interno**: `n8n-custom_postgres`

## 📋 Vantagens dos Serviços Separados

✅ **Escalabilidade**: Escale cada serviço independentemente  
✅ **Manutenção**: Atualize/reinicie serviços separadamente  
✅ **Monitoramento**: Métricas individuais por serviço  
✅ **Backup**: Backup do PostgreSQL independente  
✅ **Recursos**: Aloque CPU/RAM específicos para cada serviço  

## 🔧 Template Completo

Use o arquivo `easypanel-template.json` para importar ambos os serviços de uma vez:

1. Copie o conteúdo de `easypanel-template.json`
2. No Easypanel, vá em **Import/Export**
3. Cole o JSON e importe

## 🎯 Resultado Final

Você terá:
- **URL**: `https://n8n.seudominio.com`
- **Login**: admin / sua_senha_admin_123
- **Recursos**: Playwright + Puppeteer + pgvector
- **Banco**: PostgreSQL com extensão pgvector
- **Volumes**: Dados persistentes

## 🔍 Troubleshooting

### n8n não conecta no PostgreSQL
1. Verifique se ambos estão no mesmo **project**
2. Confirme o hostname: `{project-name}_{postgres-service-name}`
3. Verifique credenciais idênticas em ambos os serviços

### Build falha
1. Confirme branch: `easypanel-custom-n8n`
2. Confirme Dockerfile path: `docker-compose/withPostgres/Dockerfile`
3. Verifique se o repositório está acessível

Esta abordagem é muito mais robusta que docker-compose! 🚀
