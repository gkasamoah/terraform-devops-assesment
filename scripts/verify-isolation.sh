#!/usr/bin/env bash
set -euo pipefail

ENV="${1:-staging}"
EDGE_CONTAINER="${ENV}-nginx"
API_CONTAINER="${ENV}-api"
DB_CONTAINER="${ENV}-postgres"

if ! docker ps --format '{{.Names}}' | grep -qx "$EDGE_CONTAINER"; then
  echo "Edge container $EDGE_CONTAINER is not running." >&2
  exit 1
fi

if ! docker ps --format '{{.Names}}' | grep -qx "$API_CONTAINER"; then
  echo "API container $API_CONTAINER is not running." >&2
  exit 1
fi

if ! docker ps --format '{{.Names}}' | grep -qx "$DB_CONTAINER"; then
  echo "DB container $DB_CONTAINER is not running." >&2
  exit 1
fi

printf '\n[1/2] Probe database from compute tier (API container)\n'
if docker exec "$API_CONTAINER" sh -lc 'nc -zvw 2 postgres 5432'; then
  echo "PASS: compute tier can reach PostgreSQL"
else
  echo "FAIL: compute tier cannot reach PostgreSQL" >&2
  exit 1
fi

printf '\n[2/2] Probe database from edge tier (NGINX container)\n'
if docker exec "$EDGE_CONTAINER" sh -lc 'nc -zvw 2 postgres 5432'; then
  echo "FAIL: edge tier unexpectedly reached PostgreSQL" >&2
  exit 1
else
  echo "PASS: edge tier cannot reach PostgreSQL"
fi
