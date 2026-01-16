#!/usr/bin/env bash
# Description: Update Homebrew formula with new version and SHA256

set -eo pipefail

usage() {
  echo "Usage: $0 <version> <sha256> <formula-path>"
  echo ""
  echo "Example:"
  echo "  $0 0.1.1 abc123... ./Formula/rautils.rb"
  exit 1
}

if [ $# -ne 3 ]; then
  usage
fi

VERSION="$1"
SHA256="$2"
FORMULA_PATH="$3"

if [ ! -f "$FORMULA_PATH" ]; then
  echo "Error: Formula file not found: $FORMULA_PATH"
  exit 1
fi

echo "Updating Homebrew formula..."
echo "  Version: $VERSION"
echo "  SHA256: $SHA256"
echo "  Formula: $FORMULA_PATH"

# Update version
sed -i.bak "s/version \".*\"/version \"$VERSION\"/" "$FORMULA_PATH" || true

# Update URL
sed -i.bak "s|url \".*\"|url \"https://github.com/raulanatol/rautils/archive/refs/tags/v$VERSION.tar.gz\"|" "$FORMULA_PATH" || true

# Update SHA256
sed -i.bak "s/sha256 \".*\"/sha256 \"$SHA256\"/" "$FORMULA_PATH" || true

# Clean up backup
rm -f "$FORMULA_PATH.bak"

echo "✓ Formula updated successfully"
