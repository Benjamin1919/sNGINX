#!/usr/bin/env bash
set -euo pipefail

echo "Fetching latest version of Nginx"

DOWNLOAD_PAGE=$(curl -s --connect-timeout 10 --retry 2 --retry-delay 5 "https://nginx.org/en/download.html")
NGINX_VERSION=$(echo "$DOWNLOAD_PAGE" | grep -A 5 "Mainline version" | grep -oP 'nginx-\K[0-9]+\.[0-9]+\.[0-9]+' | head -n 1)

if [ -z "$NGINX_VERSION" ]; then
  echo "❌ Failed to fetch Nginx latest version, fallback to 1.29.8"
  NGINX_VERSION=1.29.8
else
  echo "✅ NGINX_VERSION=$NGINX_VERSION"
fi

echo "NGINX_VERSION=$NGINX_VERSION" >> "$GITHUB_ENV"
