#!/bin/bash
# rollback.sh – revert to previous stable pool

set -e

ENV_FILE=".env"

ACTIVE_POOL=$(grep "^ACTIVE_POOL" "$ENV_FILE" | cut -d '=' -f2)

if [ "$ACTIVE_POOL" = "blue" ]; then
  ROLLBACK_POOL="green"
else
  ROLLBACK_POOL="blue"
fi

echo "⚠️ Rolling back to $ROLLBACK_POOL..."

sed -i "s/^ACTIVE_POOL=.*/ACTIVE_POOL=$ROLLBACK_POOL/" "$ENV_FILE"

docker compose up -d nginx

echo "✅ Rollback complete! Active pool is now: $ROLLBACK_POOL"
curl -s http://localhost:8080/version
echo
