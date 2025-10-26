#!/bin/bash
# switch.sh – toggle Blue/Green active pool

set -e

ENV_FILE=".env"

# Read current ACTIVE_POOL
ACTIVE_POOL=$(grep "^ACTIVE_POOL" "$ENV_FILE" | cut -d '=' -f2)

if [ "$ACTIVE_POOL" = "blue" ]; then
  NEW_POOL="green"
else
  NEW_POOL="blue"
fi

echo "🔄 Switching from $ACTIVE_POOL to $NEW_POOL..."

# Replace ACTIVE_POOL in .env
sed -i "s/^ACTIVE_POOL=.*/ACTIVE_POOL=$NEW_POOL/" "$ENV_FILE"

# Recreate NGINX container to apply the change
docker compose up -d nginx

echo "✅ Switched successfully! Active pool is now: $NEW_POOL"

curl -s http://localhost:8080/version
echo
