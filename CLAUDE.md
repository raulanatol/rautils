# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**rautils** is a macOS CLI utility tool that provides a collection of utility commands. It's built as a modular, extensible system where:
- The main entry point (`bin/rautils`) is a command router that handles symlink resolution for Homebrew compatibility
- Each subcommand is implemented as a separate executable script in the `libexec/` directory
- The `rautils-help` command dynamically discovers and displays all available commands by scanning the libexec directory for executable scripts with description headers

The system is simple by design: commands are bash scripts, and the help system works by parsing description comments from each script's header.

## Common Commands

**Running commands locally:**
```bash
./bin/rautils help              # Show all available commands
./bin/rautils <command> --help  # Show help for a specific command
./bin/rautils <command>         # Execute command locally before installation
```

**Validation and testing (via Makefile):**
```bash
make validate                   # Run bash syntax checks and project structure validation
make test                       # Same as validate (alias)
```

**Releasing:**
```bash
make release type=patch         # Bug fixes (0.1.0 -> 0.1.1)
make release type=minor         # New features (0.1.0 -> 0.2.0)
make release type=major         # Breaking changes (0.1.0 -> 1.0.0)
```

The release process runs validation, bumps VERSION, updates `homebrew/rautils.rb`, commits, tags, and pushes. GitHub Actions then creates the GitHub Release and updates the Homebrew tap (`raulanatol/homebrew-rautils`) with the correct SHA256. The `HOMEBREW_TAP_TOKEN` secret must be configured in the repo for tap updates.

## Architecture

### Command Router (`bin/rautils`)
The main executable that:
1. Resolves symlinks to find the installation prefix (critical for Homebrew compatibility where the binary may be symlinked)
2. Sets up environment variables: `RAUTILS_PREFIX`, `RAUTILS_VERSION`, `RAUTILS_LIBEXEC`
3. Routes to the appropriate command in `libexec/` based on the first argument
4. Defaults to `help` if no command is specified or if the command doesn't exist

### Command Implementation Pattern (`libexec/rautils-*`)
Each command is a bash script following this pattern:
- **Shebang:** `#!/usr/bin/env bash`
- **Description header:** First line of comments must include `# Description: <text>` (used by help system)
- **Error handling:** Include `set -eo pipefail` for strict error handling
- **Environment variables available:** `RAUTILS_PREFIX`, `RAUTILS_VERSION`, `RAUTILS_LIBEXEC`
- **Must be executable:** `chmod +x libexec/rautils-mycommand`

### Version Management
The `VERSION` file contains the current version (semver format). The main script reads this and makes it available to all commands via the `RAUTILS_VERSION` environment variable.

### Release Pipeline
- `scripts/validate.sh` — validates VERSION format, bash syntax of all scripts, executable permissions, git status
- `scripts/bump-version.sh` — increments the version in the VERSION file
- `scripts/create-release.sh` — orchestrates the full release (validate, bump, update formula, commit, tag, push)
- `scripts/update-homebrew-formula.sh` — updates the Homebrew formula template
- `.github/workflows/release.yml` — triggered on `v*` tags; creates GitHub Release and pushes updated formula to the Homebrew tap repo

### Shell Aliases (`rautils load`)
The `load` command generates shell functions so commands can be called as `ra::*` instead of `rautils <command>`:

```bash
# Add to .zshrc or .bashrc:
eval "$(rautils load)"

# Then use:
ra::log::info "Deploying..."
ra::log::success "Done"
ra::generate-app-icons image.png
```

For each command in `libexec/`, `load` generates a base function `ra::<command>()`. If the command supports `--aliases`, it also generates sub-functions like `ra::<command>::<sub>()`.

### Subcommand Aliases (`--aliases` convention)
Commands with sublevels (like `log`) can expose them by handling a `--aliases` flag that prints one alias per line. Example from `rautils-log`:

```bash
if [[ "$1" == "--aliases" ]]; then
    echo "info"
    echo "success"
    echo "error"
    exit 0
fi
```

This makes `rautils load` automatically generate `ra::log::info`, `ra::log::success`, and `ra::log::error`.

## Adding New Commands

1. Create `libexec/rautils-mycommand` with proper shebang, description, and implementation
2. Make it executable: `chmod +x libexec/rautils-mycommand`
3. Validate: `make validate`
4. Test locally: `./bin/rautils mycommand`
5. The command automatically appears in `rautils help` output
6. If the command has sublevels, implement `--aliases` so `rautils load` generates `ra::mycommand::*` functions

The description header is critical — it's parsed by the help system and displayed to users.
