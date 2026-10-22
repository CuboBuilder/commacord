#!/usr/bin/env bash
#
# Build the Equicord Firefox extension from source and copy it into
# extensions/equicord/ so that it can be bundled into Commacord.
#
# Requires Node.js >= 22 and pnpm (via corepack) plus network access.
#
# Usage: tools/build-equicord.sh [equicord-git-ref]
#
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
REF="${1:-main}"
WORKDIR="${EQUICORD_BUILD_DIR:-$(mktemp -d)}"

echo "==> Cloning Equicord ($REF) into $WORKDIR"
git clone --depth 1 --branch "$REF" https://github.com/equicord/equicord.git "$WORKDIR"

cd "$WORKDIR"
echo "==> Installing dependencies"
pnpm install --frozen-lockfile

echo "==> Building the browser extension"
pnpm buildWeb

echo "==> Copying the Firefox extension into the repo"
rm -rf "$ROOT/extensions/equicord"
cp -r dist/browser/firefox-unpacked "$ROOT/extensions/equicord"
cp dist/extension-firefox.zip "$ROOT/extensions/equicord-firefox.zip"

echo "==> Done. Now run scripts/integrate-equicord.sh and build."
