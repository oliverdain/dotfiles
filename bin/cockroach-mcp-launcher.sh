#!/usr/bin/env bash

# We maintain files like `~/.companion/creds/dc-prod-sql-read.yaml` with connection credentials to our databases. This
# script parses those and then runs the https://github.com/amineelkouhen/mcp-cockroachdb?tab=readme-ov-file#query-engine
# MCP server connected to the database.

set -euo pipefail


CONFIG_FILE="${1:-config.yaml}"

if [[ ! -f "$CONFIG_FILE" ]]; then
  echo "Usage: $0 <config.yaml>" >&2
  exit 1
fi

connect_string=$(grep '^connect_string:' "$CONFIG_FILE" | sed 's/^connect_string:[[:space:]]*//')
password=$(grep '^password:' "$CONFIG_FILE" | sed 's/^password:[[:space:]]*//')

# Build a full URL with password and sslrootcert embedded
full_url="$(python3 -c "
from urllib.parse import urlparse, urlencode, parse_qs, urlunparse, quote
import sys
u = urlparse('$connect_string')
qs = parse_qs(u.query)
netloc = '%s:%s@%s:%s' % (u.username, quote('$password', safe=''), u.hostname, u.port or 26257)
base = urlunparse((u.scheme, netloc, u.path, '', urlencode({k: v[0] for k, v in qs.items()}), ''))
print(base + '&sslrootcert=${HOME}/.postgresql/root.crt')
")"

# Explicitly set cert/key to empty so the server doesn't try to open a file named "None"
export CRDB_SSL_CERTFILE=""
export CRDB_SSL_KEYFILE=""

uvx --from git+https://github.com/amineelkouhen/mcp-cockroachdb.git@0.1.0 cockroachdb-mcp-server --url "$full_url"
