#!/usr/bin/env bash
# Description: Validate bash scripts and project structure

set -eo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

ERRORS=0

echo "Validating rautils project..."
echo ""

# 1. Check VERSION file exists and is valid
echo "[1/5] Checking VERSION file..."
if [ ! -f "$PROJECT_ROOT/VERSION" ]; then
  echo "  ✗ VERSION file not found"
  ERRORS=$((ERRORS + 1))
else
  VERSION=$(cat "$PROJECT_ROOT/VERSION" | tr -d '[:space:]')
  if [[ "$VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "  ✓ VERSION file valid: $VERSION"
  else
    echo "  ✗ VERSION file has invalid format: $VERSION"
    echo "    Expected: MAJOR.MINOR.PATCH (e.g., 0.1.0)"
    ERRORS=$((ERRORS + 1))
  fi
fi

# 2. Validate main executable
echo "[2/5] Checking main executable..."
if [ ! -f "$PROJECT_ROOT/bin/rautils" ]; then
  echo "  ✗ bin/rautils not found"
  ERRORS=$((ERRORS + 1))
elif [ ! -x "$PROJECT_ROOT/bin/rautils" ]; then
  echo "  ✗ bin/rautils is not executable"
  ERRORS=$((ERRORS + 1))
else
  if bash -n "$PROJECT_ROOT/bin/rautils" 2>/dev/null; then
    echo "  ✓ bin/rautils syntax valid"
  else
    echo "  ✗ bin/rautils has syntax errors"
    bash -n "$PROJECT_ROOT/bin/rautils"
    ERRORS=$((ERRORS + 1))
  fi
fi

# 3. Validate libexec scripts
echo "[3/5] Checking libexec scripts..."
LIBEXEC_DIR="$PROJECT_ROOT/libexec"
if [ ! -d "$LIBEXEC_DIR" ]; then
  echo "  ✗ libexec directory not found"
  ERRORS=$((ERRORS + 1))
else
  SCRIPT_COUNT=0
  VALID_COUNT=0

  for script in "$LIBEXEC_DIR"/rautils-*; do
    if [ -f "$script" ]; then
      SCRIPT_COUNT=$((SCRIPT_COUNT + 1))
      SCRIPT_NAME=$(basename "$script")

      # Check if executable
      if [ ! -x "$script" ]; then
        echo "  ✗ $SCRIPT_NAME is not executable"
        ERRORS=$((ERRORS + 1))
        continue
      fi

      # Check syntax
      if bash -n "$script" 2>/dev/null; then
        VALID_COUNT=$((VALID_COUNT + 1))
      else
        echo "  ✗ $SCRIPT_NAME has syntax errors"
        bash -n "$script"
        ERRORS=$((ERRORS + 1))
      fi
    fi
  done

  if [ $SCRIPT_COUNT -eq 0 ]; then
    echo "  ! No rautils-* scripts found in libexec"
  else
    echo "  ✓ $VALID_COUNT/$SCRIPT_COUNT libexec scripts valid"
  fi
fi

# 4. Validate scripts directory (if exists)
echo "[4/5] Checking scripts directory..."
if [ -d "$PROJECT_ROOT/scripts" ]; then
  SCRIPT_ERRORS=0
  for script in "$PROJECT_ROOT/scripts"/*.sh; do
    if [ -f "$script" ]; then
      SCRIPT_NAME=$(basename "$script")
      if ! bash -n "$script" 2>/dev/null; then
        echo "  ✗ scripts/$SCRIPT_NAME has syntax errors"
        SCRIPT_ERRORS=$((SCRIPT_ERRORS + 1))
        ERRORS=$((ERRORS + 1))
      fi
    fi
  done

  if [ $SCRIPT_ERRORS -eq 0 ] && [ "$(ls "$PROJECT_ROOT/scripts"/*.sh 2>/dev/null | wc -l)" -gt 0 ]; then
    echo "  ✓ All scripts valid"
  fi
else
  echo "  - scripts directory not found (skipping)"
fi

# 5. Check git repository status
echo "[5/5] Checking git repository..."
if ! git rev-parse --git-dir > /dev/null 2>&1; then
  echo "  ✗ Not a git repository"
  ERRORS=$((ERRORS + 1))
else
  echo "  ✓ Git repository valid"

  # Check for uncommitted changes
  if [ -n "$(git status --porcelain)" ]; then
    echo "  ! Warning: Working directory has uncommitted changes"
  fi
fi

echo ""
echo "Validation complete!"
echo ""

if [ $ERRORS -eq 0 ]; then
  echo "✓ All checks passed"
  exit 0
else
  echo "✗ $ERRORS error(s) found"
  exit 1
fi
