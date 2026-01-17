FROM node:lts-alpine3.22

# Arguments
ARG APP_HOME=/home/node/app

# Install system dependencies
RUN apk add --no-cache gcompat tini git git-lfs

# Create app directory
WORKDIR ${APP_HOME}

# Set NODE_ENV to production
ENV NODE_ENV=production

# Bundle app source
COPY . ./

RUN \
  echo "*** Install npm packages ***" && \
  npm ci --no-audit --no-fund --loglevel=error --no-progress --omit=dev && npm cache clean --force

# Create config and data directories with proper permissions
RUN \
  rm -f "config.yaml" || true && \
  mkdir -p "config" "data" && \
  chmod -R 777 "data" "config" /home/node

# Pre-compile public libraries
RUN \
  echo "*** Run Webpack ***" && \
  node "./docker/build-lib.js"

# Set the entrypoint script
RUN \
  echo "*** Cleanup ***" && \
  mv "./docker/docker-entrypoint.sh" "./" && \
  rm -rf "./docker" && \
  echo "*** Make docker-entrypoint.sh executable ***" && \
  chmod +x "./docker-entrypoint.sh" && \
  echo "*** Convert line endings to Unix format ***" && \
  dos2unix "./docker-entrypoint.sh"

# Fix extension repos permissions
RUN git config --global --add safe.directory "*"

# Ensure data directory exists and is writable
RUN mkdir -p /home/node/app/data && chmod 777 /home/node/app/data

EXPOSE 7860

# Ensure proper handling of kernel signals
ENTRYPOINT ["tini", "--", "./docker-entrypoint.sh"]
