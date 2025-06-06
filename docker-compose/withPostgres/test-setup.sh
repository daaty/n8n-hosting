#!/bin/bash

echo "🚀 Testando configuração n8n customizada..."

# Verificar se Docker está rodando
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker não está rodando. Por favor, inicie o Docker."
    exit 1
fi

echo "✅ Docker está rodando"

# Verificar se arquivos necessários existem
if [ ! -f "Dockerfile" ]; then
    echo "❌ Dockerfile não encontrado"
    exit 1
fi

if [ ! -f "docker-compose.yml" ]; then
    echo "❌ docker-compose.yml não encontrado"
    exit 1
fi

if [ ! -f ".env" ]; then
    echo "❌ .env não encontrado"
    exit 1
fi

echo "✅ Todos os arquivos necessários encontrados"

# Testar build da imagem
echo "🔨 Fazendo build da imagem customizada..."
if docker build -t n8n-custom-test .; then
    echo "✅ Build da imagem bem-sucedido"
else
    echo "❌ Falha no build da imagem"
    exit 1
fi

# Verificar se imagem foi criada
if docker images | grep -q "n8n-custom-test"; then
    echo "✅ Imagem n8n-custom-test criada com sucesso"
else
    echo "❌ Imagem não foi criada"
    exit 1
fi

# Testar se Playwright está instalado
echo "🎭 Verificando instalação do Playwright..."
if docker run --rm n8n-custom-test npx playwright --version; then
    echo "✅ Playwright instalado corretamente"
else
    echo "⚠️  Playwright pode não estar instalado corretamente"
fi

# Testar se Puppeteer está instalado
echo "🎪 Verificando instalação do Puppeteer..."
if docker run --rm n8n-custom-test node -e "console.log(require('puppeteer').version || 'installed')"; then
    echo "✅ Puppeteer instalado corretamente"
else
    echo "⚠️  Puppeteer pode não estar instalado corretamente"
fi

# Limpar imagem de teste
docker rmi n8n-custom-test > /dev/null 2>&1

echo ""
echo "🎉 Testes concluídos!"
echo ""
echo "📋 Próximos passos para deploy no Easypanel:"
echo "1. Faça push deste código para seu repositório GitHub"
echo "2. Siga as instruções no arquivo EASYPANEL-DEPLOY.md"
echo "3. Configure as variáveis de ambiente usando .env.easypanel.example como referência"
echo ""
echo "ℹ️  Para testar localmente:"
echo "   docker-compose up -d"
echo "   Acesse: http://localhost:5678"
