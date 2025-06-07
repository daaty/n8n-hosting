# Deploy n8n via Docker Compose no Easypanel

Guia completo para fazer deploy do n8n customizado com PostgreSQL usando docker-compose no Easypanel.

## 🚀 Métodos de Deploy no Easypanel

O Easypanel suporta 3 abordagens principais:

### 1. 📋 Docker Compose (Recomendado)
✅ **Vantagens**: Simples, tudo em um arquivo, rede automática  
✅ **Ideal para**: Deploy completo com PostgreSQL e n8n juntos  

### 2. 🔧 Dockerfile Build  
✅ **Vantagens**: Controle total, imagem customizada  
✅ **Ideal para**: Apenas o n8n, PostgreSQL separado  

### 3. 🎯 Serviços Separados
✅ **Vantagens**: Escalabilidade, recursos independentes  
✅ **Ideal para**: Ambientes de produção complexos  

---

## 📦 Método 1: Docker Compose (MAIS FÁCIL)

### Passo 1: Preparar Repositório

1. **Fork** este repositório para sua conta GitHub
2. **Clone** localmente (opcional):
```bash
git clone https://github.com/SEU_USUARIO/n8n-hosting.git
cd n8n-hosting/docker-compose/withPostgres
```

### Passo 2: Configurar no Easypanel

1. **Create Service** → **App**
2. **Configurações básicas**:
   - **Project Name**: `n8n-stack`
   - **Service Name**: `n8n-app`
   - **Source**: GitHub
   - **Repository**: `SEU_USUARIO/n8n-hosting`
   - **Branch**: `main`

3. **Build Settings**:
   - **Build Type**: `Docker Compose`
   - **Docker Compose File**: `docker-compose/withPostgres/docker-compose.easypanel-complete.yml`
   - **Service Name**: `n8n` (nome do serviço dentro do compose)

4. **Environment Variables**:
```env
POSTGRES_PASSWORD=sua_senha_postgresql_forte
N8N_AUTH_USER=admin
N8N_AUTH_PASSWORD=sua_senha_admin_forte
WEBHOOK_URL=https://SEU_DOMINIO.easypanel.host
N8N_ENCRYPTION_KEY=uma-chave-secreta-de-32-caracteres
```

5. **Port**: `5678`

6. **Domain** (opcional):
   - **Host**: `n8n.seudominio.com`
   - **HTTPS**: ✅

### Passo 3: Deploy

1. Clique em **"Deploy"**
2. Aguarde o build (5-10 minutos)
3. Verifique os logs para confirmar que está funcionando
4. Acesse sua URL e faça login

---

## 🔧 Método 2: Dockerfile Build + PostgreSQL Separado

### Passo 1: Criar Serviço PostgreSQL

1. **Create Service** → **Database** → **PostgreSQL**
2. **Configurações**:
   - **Project Name**: `n8n-stack`
   - **Service Name**: `postgres`
   - **Database**: `n8n`
   - **Username**: `n8n_user`
   - **Password**: `sua_senha_forte`
   - **PostgreSQL Version**: Use custom image → `pgvector/pgvector:pg16`

### Passo 2: Criar Serviço n8n

1. **Create Service** → **App**
2. **Configurações**:
   - **Project Name**: `n8n-stack` (mesmo do PostgreSQL)
   - **Service Name**: `n8n`
   - **Source**: GitHub
   - **Repository**: `SEU_USUARIO/n8n-hosting`
   - **Branch**: `main`

3. **Build Settings**:
   - **Build Type**: `Dockerfile`
   - **Dockerfile Path**: `docker-compose/withPostgres/Dockerfile`
   - **Build Context**: `docker-compose/withPostgres`

4. **Environment Variables**:
```env
DB_TYPE=postgresdb
DB_POSTGRESDB_HOST=n8n-stack_postgres
DB_POSTGRESDB_PORT=5432
DB_POSTGRESDB_DATABASE=n8n
DB_POSTGRESDB_USER=n8n_user
DB_POSTGRESDB_PASSWORD=sua_senha_forte
N8N_BASIC_AUTH_ACTIVE=true
N8N_BASIC_AUTH_USER=admin
N8N_BASIC_AUTH_PASSWORD=sua_senha_admin
WEBHOOK_URL=https://SEU_DOMINIO.easypanel.host
GENERIC_TIMEZONE=America/Sao_Paulo
```

---

## 🎯 Método 3: Template JSON (Automático)

Use o template `easypanel-template.json` para criar ambos os serviços automaticamente:

1. No Easypanel, vá em **Settings** → **Import/Export**
2. Cole o conteúdo do arquivo `easypanel-template.json`
3. Ajuste as senhas e domínios
4. Clique em **Import**

---

## 🔍 Arquivos de Configuração

### Docker Compose Variants:

- `docker-compose.yml` - Padrão original
- `docker-compose.easypanel.yml` - Versão simplificada  
- `docker-compose.easypanel-complete.yml` - **Versão otimizada (USE ESTA)**
- `docker-compose.simple.yml` - Sem build customizado

### Environment Files:

- `.env` - Configuração local
- `.env.easypanel` - Configuração para Easypanel
- `.env.easypanel.example` - Template com todas as opções

---

## ⚡ Vantagens do Docker Compose no Easypanel

✅ **Rede automática**: Serviços se comunicam automaticamente  
✅ **Volumes persistentes**: Dados não são perdidos  
✅ **Health checks**: Restart automático se falhar  
✅ **Rollback**: Fácil voltar versão anterior  
✅ **Logs centralizados**: Todos os logs em um lugar  
✅ **Escalabilidade**: Pode escalar serviços independentemente  

---

## 🐛 Troubleshooting

### "Build failed"
- Verifique se o arquivo docker-compose está no caminho correto
- Confirme se todas as variáveis de ambiente estão definidas
- Verifique se o repositório GitHub é acessível

### "n8n não conecta no PostgreSQL"
- No compose: Use `postgres` como hostname
- Em serviços separados: Use `PROJETO_SERVICO` como hostname
- Verifique se as credenciais são idênticas

### "Erro de memória durante build"
- Use `docker-compose.simple.yml` que não faz build customizado
- Ou aumente os recursos do build temporariamente

### "Playwright/Puppeteer não funciona"
- Verifique se o build customizado foi usado
- Confirme se as variáveis PUPPETEER estão definidas
- Teste com um workflow simples primeiro

---

## 📊 Recursos Recomendados

Para **n8n com PostgreSQL**:
- **CPU**: 1-2 vCPUs
- **RAM**: 2-4 GB
- **Storage**: 10+ GB SSD

Para **PostgreSQL apenas**:
- **CPU**: 1 vCPU
- **RAM**: 1-2 GB  
- **Storage**: 5+ GB SSD

---

## 🎉 Resultado Final

Após deploy bem-sucedido:

- **URL**: `https://SEU_DOMINIO.easypanel.host`
- **Login**: admin / sua_senha_admin
- **Recursos**: Playwright + Puppeteer + pgvector
- **Banco**: PostgreSQL com extensão pgvector
- **Backup**: Configure backup automático no Easypanel

**🔥 Sua instância n8n customizada está pronta para uso!** 🚀
