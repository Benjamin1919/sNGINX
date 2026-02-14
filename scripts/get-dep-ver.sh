#!/usr/bin/env bash
set -euo pipefail

echo "Fetching latest versions of dependencies"

LIBXML2_VERSION=$(curl -s --connect-timeout 10 --retry 2 --retry-delay 5 "https://gitlab.gnome.org/api/v4/projects/GNOME%2Flibxml2/releases" | jq -r '.[0].tag_name | sub("^v"; "")')

LIBXSLT_VERSION=$(curl -s --connect-timeout 10 --retry 2 --retry-delay 5 "https://gitlab.gnome.org/api/v4/projects/GNOME%2Flibxslt/releases" | jq -r '.[0].tag_name | sub("^v"; "")')

LIBGD_VERSION=$(curl -s --connect-timeout 10 --retry 2 --retry-delay 5 "https://api.github.com/repos/libgd/libgd/releases/latest" | jq -r '.tag_name | sub("^gd-"; "")')

OPENSSL_VERSION=$(curl -s --connect-timeout 10 --retry 2 --retry-delay 5 "https://api.github.com/repos/openssl/openssl/releases/latest" | jq -r '.tag_name | sub("^openssl-"; "")')

ZLIB_VERSION=$(curl -s --connect-timeout 10 --retry 2 --retry-delay 5 "https://api.github.com/repos/madler/zlib/releases/latest" | jq -r '.tag_name | sub("^v"; "")')

PCRE2_VERSION=$(curl -s --connect-timeout 10 --retry 2 --retry-delay 5 "https://api.github.com/repos/PCRE2Project/pcre2/releases/latest" | jq -r '.tag_name | sub("^pcre2-"; "")')

if [ -z "$LIBXML2_VERSION" ]; then
  echo "❌ Failed to fetch libxml2 latest version, fallback to 2.15.1"
  LIBXML2_VERSION=2.15.1
else
  echo "✅ LIBXML2_VERSION=$LIBXML2_VERSION"
fi

if [ -z "$LIBXSLT_VERSION" ]; then
  echo "❌ Failed to fetch libxslt latest version, fallback to 1.1.45"
  LIBXSLT_VERSION=1.1.45
else
  echo "✅ LIBXSLT_VERSION=$LIBXSLT_VERSION"
fi

if [ -z "$LIBGD_VERSION" ]; then
  echo "❌ Failed to fetch libgd latest version, fallback to 2.3.3"
  LIBGD_VERSION=2.3.3
else
  echo "✅ LIBGD_VERSION=$LIBGD_VERSION"
fi

if [ -z "$OPENSSL_VERSION" ]; then
  echo "❌ Failed to fetch OpenSSL latest version, fallback to 3.6.1"
  OPENSSL_VERSION=3.6.1
else
  echo "✅ OPENSSL_VERSION=$OPENSSL_VERSION"
fi

if [ -z "$ZLIB_VERSION" ]; then
  echo "❌ Failed to fetch zlib latest version, fallback to 1.3.1"
  PCRE2_VERSION=1.3.1
else
  echo "✅ ZLIB_VERSION=$ZLIB_VERSION"
fi

if [ -z "$PCRE2_VERSION" ]; then
  echo "❌ Failed to fetch PCRE2 latest version, fallback to 10.47"
  PCRE2_VERSION=10.47
else
  echo "✅ PCRE2_VERSION=$PCRE2_VERSION"
fi

{
  echo "LIBXML2_VERSION=$LIBXML2_VERSION"
  echo "LIBXSLT_VERSION=$LIBXSLT_VERSION"
  echo "LIBGD_VERSION=$LIBGD_VERSION"
  echo "OPENSSL_VERSION=$OPENSSL_VERSION"
  echo "ZLIB_VERSION=$ZLIB_VERSION"
  echo "PCRE2_VERSION=$PCRE2_VERSION"
} >> "$GITHUB_ENV"
