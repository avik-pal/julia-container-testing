#!/usr/bin/env bash
set -e

# 0) Check Docker daemon
if ! docker info > /dev/null 2>&1; then
  echo "ERROR: Docker daemon is not running."
  echo "Please start Docker Desktop (or your Docker daemon) and try again."
  exit 1
fi

# 1) Log in to GitHub Container Registry
echo "$GHCR_PAT" \
  | docker login ghcr.io -u tyler-korenyi-both --password-stdin

# 2) Build & push image (amd64)
docker buildx build \
  --platform linux/amd64 \
  -f Dockerfile \
  -t ghcr.io/tyler-korenyi-both/lux-app:amd64 \
  --push \
  .

echo "✅ build & push complete: ghcr.io/tyler-korenyi-both/lux-app:amd64"
