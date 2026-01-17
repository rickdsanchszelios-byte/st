FROM node:20-alpine

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install production dependencies
RUN npm ci --omit=dev --ignore-scripts

# Copy source code
COPY . .

# Copy our known working config
COPY config/config.yaml config.yaml

# Create data directory
RUN mkdir -p data && chmod 777 data

# Expose port
EXPOSE 8000

# Start directly with node, skipping any shell script wrapper logic
CMD ["node", "server.js", "--port", "8000", "--listen", "--disableCsrf", "--whitelistMode", "false"]
