#!/usr/bin/env bash
# Description: Bump semantic version in VERSION file

set -eo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
VERSION_FILE="$PROJECT_ROOT/VERSION"

usage() {
  echo "Usage: $0 <patch|minor|major>"
  exit 1
}

# Validate arguments
if [ $# -ne 1 ]; then
  usage
fi

BUMP_TYPE="$1"

if [[ ! "$BUMP_TYPE" =~ ^(patch|minor|major)$ ]]; then
  echo "Error: Invalid bump type. Must be patch, minor, or major."
  usage
fi

# Read current version
if [ ! -f "$VERSION_FILE" ]; then
  echo "Error: VERSION file not found at $VERSION_FILE"
  exit 1
fi

CURRENT_VERSION=$(cat "$VERSION_FILE" | tr -d '[:space:]')

# Validate version format (semantic versioning)
if ! [[ "$CURRENT_VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "Error: Invalid version format in VERSION file: $CURRENT_VERSION"
  echo "Expected format: MAJOR.MINOR.PATCH (e.g., 0.1.0)"
  exit 1
fi

# Parse version components
IFS='.' read -r MAJOR MINOR PATCH <<< "$CURRENT_VERSION"

# Bump version based on type
case "$BUMP_TYPE" in
  major)
    MAJOR=$((MAJOR + 1))
    MINOR=0
    PATCH=0
    ;;
  minor)
    MINOR=$((MINOR + 1))
    PATCH=0
    ;;
  patch)
    PATCH=$((PATCH + 1))
    ;;
esac

NEW_VERSION="$MAJOR.$MINOR.$PATCH"

echo "Current version: $CURRENT_VERSION"
echo "New version: $NEW_VERSION"

# Write new version to VERSION file
echo "$NEW_VERSION" > "$VERSION_FILE"

# Output new version for use in other scripts
echo "$NEW_VERSION"
