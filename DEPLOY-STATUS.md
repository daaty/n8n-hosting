# 🚀 N8N Custom Build - Deploy no Easypanel

## ✅ Últimas Atualizações

### Problemas Corrigidos:
- ✅ Configuração do PostgreSQL com pgvector
- ✅ Health checks otimizados
- ✅ Configurações de ambiente simplificadas
- ✅ Build personalizado com Playwright + Puppeteer

## 📋 Como Fazer Deploy

### 1. Configuração Docker Compose no Easypanel

**Repository:** `daaty/n8n-hosting`  
**Branch:** `easypanel-custom-n8n`  
**Build Method:** Docker Compose  
**Compose File:** `docker-compose/withPostgres/docker-compose.yml`

### 2. Variáveis de Ambiente Necessárias

```bash
# PostgreSQL
POSTGRES_PASSWORD=sua_senha_postgres_super_forte_123

# n8n Authentication  
N8N_AUTH_USER=admin
N8N_AUTH_PASSWORD=sua_senha_admin_super_forte_123

# n8n Security
N8N_ENCRYPTION_KEY=sua_chave_de_criptografia_super_secreta_123

# Webhook URL (ajustar para seu domínio)
WEBHOOK_URL=https://seu-app.easypanel.host
```

### 3. Arquivos de Configuração Disponíveis

- `docker-compose.yml` - **Configuração principal (RECOMENDADO)**
- `docker-compose.minimal.yml` - Versão simplificada para testes
- `docker-compose.easypanel-complete.yml` - Versão com todas as opções

### 4. Funcionalidades Incluídas

✅ **n8n v1.70.0** (última versão)  
✅ **PostgreSQL 16** com **pgvector extension**  
✅ **Playwright** para automação web  
✅ **Puppeteer** com Chromium  
✅ **Health checks** otimizados  
✅ **Configurações de segurança**  

## 🔧 Configuração Avançada

### Health Checks Melhorados:
- PostgreSQL: 15 tentativas, início após 120s
- n8n: 5 tentativas, início após 300s (5min) para aguardar inicialização completa

### Dependências do Browser:
- Chromium instalado via Alpine packages
- Playwright configurado para usar Chromium do sistema
- Puppeteer configurado para não baixar Chromium próprio

## 🚀 Status do Build

**Último commit:** `b2f1889` - Fix PostgreSQL health check  
**Status:** ✅ Pronto para deploy no Easypanel  
**Testado:** ✅ Build bem-sucedido  

## 📞 Próximos Passos

1. **Deploy no Easypanel** usando as configurações acima
2. **Configurar domínio** e certificado SSL
3. **Testar funcionalidades** Playwright/Puppeteer
4. **Verificar pgvector** funcionando no PostgreSQL
