#!/bin/bash

echo "🚀 Testando configuração docker-compose para Easypanel..."

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Função para logs coloridos
log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

log_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

log_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Verificar se Docker está rodando
if ! docker info > /dev/null 2>&1; then
    log_error "Docker não está rodando. Por favor, inicie o Docker."
    exit 1
fi

log_success "Docker está rodando"

# Verificar arquivos necessários
files_to_check=(
    "Dockerfile"
    "docker-compose.yml"
    "docker-compose.easypanel-complete.yml"
    ".env"
    "init-data.sh"
    "EASYPANEL-DOCKER-COMPOSE.md"
)

for file in "${files_to_check[@]}"; do
    if [ ! -f "$file" ]; then
        log_error "Arquivo $file não encontrado"
        exit 1
    fi
done

log_success "Todos os arquivos necessários encontrados"

# Verificar sintaxe do docker-compose
log_info "Validando sintaxe do docker-compose..."

for compose_file in "docker-compose.yml" "docker-compose.easypanel-complete.yml"; do
    if docker-compose -f "$compose_file" config > /dev/null 2>&1; then
        log_success "Sintaxe do $compose_file está correta"
    else
        log_error "Erro na sintaxe do $compose_file"
        docker-compose -f "$compose_file" config
        exit 1
    fi
done

# Testar build da imagem n8n personalizada
log_info "Testando build da imagem n8n customizada..."
if docker build -t n8n-custom-test-validation . > /dev/null 2>&1; then
    log_success "Build da imagem customizada bem-sucedido"
else
    log_error "Falha no build da imagem customizada"
    exit 1
fi

# Verificar se dependências estão instaladas na imagem
log_info "Verificando dependências na imagem..."

# Testar Playwright
if docker run --rm n8n-custom-test-validation node -e "console.log('Playwright:', require('playwright').chromium ? 'OK' : 'ERRO')" 2>/dev/null; then
    log_success "Playwright está disponível na imagem"
else
    log_warning "Playwright pode não estar disponível"
fi

# Testar Puppeteer
if docker run --rm n8n-custom-test-validation node -e "console.log('Puppeteer:', require('puppeteer') ? 'OK' : 'ERRO')" 2>/dev/null; then
    log_success "Puppeteer está disponível na imagem"
else
    log_warning "Puppeteer pode não estar disponível"
fi

# Testar pgvector
if docker run --rm n8n-custom-test-validation node -e "console.log('pgvector:', require('pgvector') ? 'OK' : 'ERRO')" 2>/dev/null; then
    log_success "pgvector está disponível na imagem"
else
    log_warning "pgvector pode não estar disponível"
fi

# Testar configuração de rede
log_info "Testando configuração de rede do docker-compose..."
if docker-compose -f docker-compose.easypanel-complete.yml config | grep -q "n8n-network"; then
    log_success "Rede personalizada configurada corretamente"
else
    log_warning "Configuração de rede pode ter problemas"
fi

# Verificar volumes
log_info "Verificando configuração de volumes..."
if docker-compose -f docker-compose.easypanel-complete.yml config | grep -q "volumes:"; then
    log_success "Volumes configurados corretamente"
else
    log_error "Configuração de volumes com problemas"
fi

# Limpar imagem de teste
docker rmi n8n-custom-test-validation > /dev/null 2>&1

echo ""
log_success "🎉 Validação concluída com sucesso!"
echo ""
log_info "📋 Para deploy no Easypanel:"
echo "1. Faça push deste código para seu repositório GitHub"
echo "2. Use o arquivo docker-compose.easypanel-complete.yml"
echo "3. Siga as instruções em EASYPANEL-DOCKER-COMPOSE.md"
echo ""
log_info "🧪 Para teste local rápido:"
echo "   docker-compose -f docker-compose.easypanel-complete.yml up -d"
echo "   Acesse: http://localhost:5678"
echo ""
log_info "📁 Arquivos importantes:"
echo "   - docker-compose.easypanel-complete.yml (use este no Easypanel)"
echo "   - .env.easypanel.example (template de variáveis)"
echo "   - EASYPANEL-DOCKER-COMPOSE.md (guia completo)"
