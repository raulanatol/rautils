#!/usr/bin/env bash
# Description: Orchestrate the complete release process

set -eo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

usage() {
  echo "Usage: $0 <patch|minor|major>"
  exit 1
}

log_info() {
  echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
  echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
  echo -e "${RED}[ERROR]${NC} $1"
}

# Validate arguments
if [ $# -ne 1 ]; then
  usage
fi

BUMP_TYPE="$1"

if [[ ! "$BUMP_TYPE" =~ ^(patch|minor|major)$ ]]; then
  log_error "Invalid bump type. Must be patch, minor, or major."
  usage
fi

cd "$PROJECT_ROOT"

# Step 1: Validate project
log_info "Step 1: Running validation checks..."
if ! bash "$SCRIPT_DIR/validate.sh"; then
  log_error "Validation failed. Please fix errors before releasing."
  exit 1
fi

# Step 2: Check git status
log_info "Step 2: Checking git status..."

# Check if we're on main branch
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
if [ "$CURRENT_BRANCH" != "main" ]; then
  log_warn "You are on branch '$CURRENT_BRANCH', not 'main'"
  read -p "Continue anyway? (y/N) " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    log_info "Release cancelled"
    exit 0
  fi
fi

# Check for uncommitted changes
if [ -n "$(git status --porcelain)" ]; then
  log_error "Working directory has uncommitted changes. Please commit or stash them first."
  git status --short
  exit 1
fi

# Check if we can push (remote configured)
if ! git remote get-url origin > /dev/null 2>&1; then
  log_error "No git remote 'origin' configured"
  exit 1
fi

# Step 3: Bump version
log_info "Step 3: Bumping version ($BUMP_TYPE)..."
NEW_VERSION=$(bash "$SCRIPT_DIR/bump-version.sh" "$BUMP_TYPE" | tail -1)

if [ -z "$NEW_VERSION" ]; then
  log_error "Failed to bump version"
  exit 1
fi

log_info "New version: $NEW_VERSION"

# Step 4: Update homebrew formula
log_info "Step 4: Updating homebrew formula template..."
FORMULA_FILE="$PROJECT_ROOT/homebrew/rautils.rb"

if [ -f "$FORMULA_FILE" ]; then
  # Update version in formula (keep PLACEHOLDER for sha256)
  sed -i.bak "s/version \".*\"/version \"$NEW_VERSION\"/" "$FORMULA_FILE" || true
  sed -i.bak "s|url \".*\"|url \"https://github.com/raulanatol/rautils/archive/refs/tags/v$NEW_VERSION.tar.gz\"|" "$FORMULA_FILE" || true
  rm -f "$FORMULA_FILE.bak"
  log_info "Formula template updated"
else
  log_warn "Formula file not found at $FORMULA_FILE"
fi

# Step 5: Commit changes
log_info "Step 5: Committing version bump..."
git add VERSION homebrew/rautils.rb 2>/dev/null || git add VERSION
git commit -m "Bump version to $NEW_VERSION"

# Step 6: Create git tag
log_info "Step 6: Creating git tag v$NEW_VERSION..."
if git tag -l | grep -q "^v$NEW_VERSION$"; then
  log_error "Tag v$NEW_VERSION already exists"
  log_error "Rolling back commit..."
  git reset --hard HEAD~1
  exit 1
fi

git tag -a "v$NEW_VERSION" -m "Release version $NEW_VERSION"

# Step 7: Push to remote
log_info "Step 7: Pushing to remote..."

# Push commits
if ! git push origin "$CURRENT_BRANCH"; then
  log_error "Failed to push commits"
  log_error "Rolling back tag and commit..."
  git tag -d "v$NEW_VERSION"
  git reset --hard HEAD~1
  exit 1
fi

# Push tags
if ! git push origin "v$NEW_VERSION"; then
  log_error "Failed to push tag"
  log_warn "Commits were pushed but tag was not. You may need to manually push the tag:"
  log_warn "  git push origin v$NEW_VERSION"
  exit 1
fi

log_info ""
log_info "═══════════════════════════════════════════════════"
log_info "✓ Release v$NEW_VERSION completed successfully!"
log_info "═══════════════════════════════════════════════════"
log_info ""
log_info "Next steps:"
log_info "1. GitHub Actions will automatically create a release"
log_info "2. The Homebrew tap will be updated automatically"
log_info "3. Monitor: https://github.com/raulanatol/rautils/actions"
log_info ""
