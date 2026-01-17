#!/bin/sh

# Create data directory if it doesn't exist
mkdir -p /home/node/app/data
chmod 777 /home/node/app/data

# Copy our custom config to root (this is what SillyTavern reads)
cp -f ./config/config.yaml ./config.yaml 2>/dev/null || true

# Start the server on port 8000 with listen flag
exec node server.js --port 8000 --listen "$@"
