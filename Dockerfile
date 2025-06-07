# N8N com Playwright e Puppeteer - Serviço Individual para Easypanel
FROM n8nio/n8n:latest

# Instalar dependências do sistema
USER root
RUN apk update && apk add --no-cache \
    chromium \
    nss \
    freetype \
    freetype-dev \
    harfbuzz \
    ca-certificates \
    ttf-freefont \
    python3 \
    py3-pip \
    build-base \
    git \
    && rm -rf /var/cache/apk/* \
    && rm -rf /tmp/*

# Instalar dependências Node.js
USER node
RUN npm install -g --no-audit --no-fund \
    puppeteer@latest \
    playwright@latest \
    @playwright/test@latest

# Instalar Playwright browsers
RUN npx playwright install chromium

# Criar diretórios necessários
RUN mkdir -p /home/node/.n8n/nodes \
    && mkdir -p /home/node/.cache/playwright \
    && chmod 700 /home/node/.n8n

# Instalar nodes extras (opcional, pode falhar)
RUN npm install -g --no-audit --no-fund \
    n8n-nodes-playwright || echo "Playwright nodes not available" \
    && npm install -g --no-audit --no-fund \
    n8n-nodes-puppeteer || echo "Puppeteer nodes not available"

# Limpar cache
RUN npm cache clean --force

# Variáveis de ambiente para browser automation
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser
ENV PLAYWRIGHT_BROWSERS_PATH=/home/node/.cache/playwright

# Expor porta
EXPOSE 5678

# Comando padrão
CMD ["n8n"]
