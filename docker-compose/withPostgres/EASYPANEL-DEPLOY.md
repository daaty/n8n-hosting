# Deploy n8n Custom no Easypanel

Guia passo a passo para fazer deploy do n8n customizado com Playwright, Puppeteer e pgvector no Easypanel.

## Pré-requisitos

1. Conta no Easypanel
2. Fork deste repositório no GitHub
3. VPS configurada com Easypanel

## Passo 1: Preparar o Repositório

1. Faça fork deste repositório para sua conta GitHub
2. Clone o fork localmente (opcional, para personalizar)

## Passo 2: Criar Serviço PostgreSQL

1. No Easypanel, clique em **"Create Service"**
2. Escolha **"App"** 
3. Configure:
   - **Name**: `n8n-postgres`
   - **Image**: `pgvector/pgvector:pg16`
   - **Port**: `5432`

4. **Environment Variables**:
   ```
   POSTGRES_USER=n8n_user
   POSTGRES_PASSWORD=sua_senha_forte_aqui
   POSTGRES_DB=n8n
   ```

5. **Storage** (recomendado):
   - Mount path: `/var/lib/postgresql/data`
   - Size: pelo menos 5GB

6. Clique em **"Deploy"**

## Passo 3: Criar Serviço n8n

1. No Easypanel, clique em **"Create Service"**
2. Escolha **"App"**
3. Configure:
   - **Name**: `n8n-custom`
   - **Source**: GitHub
   - **Repository**: seu fork do repositório
   - **Branch**: `main`

4. **Build Settings**:
   - **Build Type**: `Dockerfile`
   - **Dockerfile Path**: `Dockerfile`
   - **Build Context**: `docker-compose/withPostgres`

5. **Environment Variables**:
   ```
   DB_TYPE=postgresdb
   DB_POSTGRESDB_HOST=n8n-postgres
   DB_POSTGRESDB_PORT=5432
   DB_POSTGRESDB_DATABASE=n8n
   DB_POSTGRESDB_USER=n8n_user
   DB_POSTGRESDB_PASSWORD=sua_senha_forte_aqui
   N8N_BASIC_AUTH_ACTIVE=true
   N8N_BASIC_AUTH_USER=admin
   N8N_BASIC_AUTH_PASSWORD=sua_senha_admin
   WEBHOOK_URL=https://seu-dominio.com
   ```

6. **Port**: `5678`

7. **Domain** (opcional):
   - Configure seu domínio personalizado
   - Ou use o domínio fornecido pelo Easypanel

8. Clique em **"Deploy"**

## Passo 4: Verificar Deploy

1. Aguarde o build completar (pode levar alguns minutos)
2. Acesse a URL do seu n8n
3. Faça login com as credenciais configuradas
4. Teste se as funcionalidades estão funcionando:
   - Crie um workflow simples
   - Teste nodes do Playwright/Puppeteer se disponíveis

## Troubleshooting

### Build falha
- Verifique se o path do Dockerfile está correto
- Verifique se o build context aponta para a pasta correta

### n8n não conecta no PostgreSQL
- Verifique se os nomes dos serviços estão corretos
- Verifique se as credenciais estão iguais nos dois serviços
- Certifique-se que o PostgreSQL está rodando

### Erro de memória durante build
- No Easypanel, aumente os recursos do build temporariamente
- Ou use uma imagem pré-buildada no Docker Hub

## Funcionalidades Incluídas

Após o deploy bem-sucedido, seu n8n terá:

- ✅ **Playwright**: Para automação de browsers
- ✅ **Puppeteer**: Para web scraping
- ✅ **pgvector**: Para operações com vetores/IA
- ✅ **PostgreSQL**: Banco de dados robusto
- ✅ **Nodes customizados**: Support para nodes da comunidade

## Próximos Passos

1. Configure webhooks se necessário
2. Instale nodes adicionais via npm se precisar
3. Configure backups regulares do PostgreSQL
4. Configure SSL/HTTPS se usando domínio próprio

## Recursos Úteis

- [Documentação n8n](https://docs.n8n.io/)
- [Playwright Docs](https://playwright.dev/)
- [Puppeteer Docs](https://pptr.dev/)
- [pgvector Docs](https://github.com/pgvector/pgvector)
