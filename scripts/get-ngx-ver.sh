#!/usr/bin/env bash
set -euo pipefail

echo "Fetching latest version of Nginx"

NGINX_VERSION=$(curl -s --connect-timeout 10 --retry 2 --retry-delay 5 "https://api.github.com/repos/nginx/nginx/releases/latest" | jq -r '.tag_name | sub("^release-"; "")')

if [ -z "$NGINX_VERSION" ]; then
  echo "❌ Failed to fetch Nginx latest version, fallback to 1.29.2"
  NGINX_VERSION=1.29.3
else
  echo "✅ NGINX_VERSION=$NGINX_VERSION"
fi

echo "NGINX_VERSION=$NGINX_VERSION" >> "$GITHUB_ENV"
