#!/bin/sh

# Create data directory if it doesn't exist
mkdir -p /home/node/app/data
chmod 777 /home/node/app/data

# Use our custom config directly - don't copy from defaults
if [ ! -e "config/config.yaml" ]; then
    echo "Creating config from scratch"
    mkdir -p config
fi

# Link config.yaml to root
ln -sf "./config/config.yaml" "./config.yaml" 2>/dev/null || true

# Execute postinstall to auto-populate config.yaml with missing values
npm run postinstall

# Start the server on port 8000 explicitly
exec node server.js --port 8000 --listen "$@"
