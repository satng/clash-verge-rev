#!/bin/sh
# Local macOS packaging script (not part of CI).
# Produces a .app bundle and .dmg under target/<profile>/bundle/.
# Updater artifacts are disabled because signing requires
# TAURI_SIGNING_PRIVATE_KEY, which local builds do not have.
#
# Usage:
#   scripts/build-macos-local.sh           # full release build (slow, optimized)
#   scripts/build-macos-local.sh --fast    # fast-release profile (quick, unoptimized)
set -eu
cd "$(dirname "$0")/.."

CONFIG='{"bundle":{"createUpdaterArtifacts":false}}'

if [ "${1:-}" = "--fast" ]; then
  node_modules/.bin/tauri build --profile fast-release --config "$CONFIG"
else
  node_modules/.bin/tauri build --config "$CONFIG"
fi

echo
echo "=== Artifacts ==="
find target -maxdepth 6 -path '*/bundle/*' \( -name '*.app' -o -name '*.dmg' \) -exec ls -ldh {} \; 2>/dev/null || true
