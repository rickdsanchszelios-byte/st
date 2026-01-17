#!/bin/sh

# Create data directory if it doesn't exist
mkdir -p /home/node/app/data
chmod 777 /home/node/app/data

if [ ! -e "config/config.yaml" ]; then
    echo "Resource not found, copying from defaults: config.yaml"
    cp -r "default/config.yaml" "config/config.yaml"
fi

# Link config.yaml to root
ln -sf "./config/config.yaml" "./config.yaml" 2>/dev/null || true

# Execute postinstall to auto-populate config.yaml with missing values
npm run postinstall

# Start the server
exec node server.js --listen "$@"
