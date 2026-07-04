#!/bin/bash
set -euo pipefail

CONFIG_FILE="/app/config.sh"

if [ ! -f "$CONFIG_FILE" ]; then
  echo "ERROR: config file not found: $CONFIG_FILE" >&2
  exit 1
fi

# shellcheck source=/app/config.sh
source "$CONFIG_FILE"

if [ -z "${NGROK_TOKEN:-}" ]; then
  echo "ERROR: NGROK_TOKEN is not set in $CONFIG_FILE" >&2
  exit 1
fi

echo "Starting SSH service..."
if ! service ssh start; then
  echo "ERROR: failed to start SSH service" >&2
  exit 1
fi

echo "Starting nginx service..."
if ! service nginx start; then
  echo "ERROR: failed to start nginx service" >&2
  exit 1
fi

echo "Setting ngrok token..."
if ! ngrok authtoken "$NGROK_TOKEN"; then
  echo "ERROR: failed to set ngrok auth token" >&2
  exit 1
fi

echo "Starting ngrok service..."
ngrok tcp 22 --log=stdout > ngrok.log
