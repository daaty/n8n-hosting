# n8n Custom Docker Image with Playwright, Puppeteer, and pgvector support
FROM n8nio/n8n:latest

# Switch to root to install dependencies
USER root

# Update package list and install system dependencies in one layer
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
    postgresql-dev \
    git \
    && rm -rf /var/cache/apk/* \
    && rm -rf /tmp/*

# Set Puppeteer to skip downloading Chromium (we installed it via apk)
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser \
    PLAYWRIGHT_BROWSERS_PATH=/home/node/.cache/playwright

# Install Node.js dependencies in one layer
RUN npm install -g --no-audit --no-fund \
    puppeteer@latest \
    playwright@latest \
    @playwright/test@latest \
    pg@latest \
    pgvector@latest

# Install Playwright browsers (only Chromium to save space)
RUN npx playwright install chromium --with-deps

# Create directory for custom nodes and set permissions
RUN mkdir -p /home/node/.n8n/nodes \
    && mkdir -p /home/node/.cache/playwright \
    && chown -R node:node /home/node/.n8n \
    && chown -R node:node /home/node/.cache

# Install useful n8n community nodes (optional, comment out if not needed)
RUN npm install -g --no-audit --no-fund \
    n8n-nodes-playwright || echo "Playwright nodes not available" \
    && npm install -g --no-audit --no-fund \
    n8n-nodes-puppeteer || echo "Puppeteer nodes not available"

# Clean up npm cache
RUN npm cache clean --force

# Switch back to node user
USER node

# Expose n8n port
EXPOSE 5678

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost:5678/healthz || exit 1

# Start n8n
CMD ["n8n", "start"]