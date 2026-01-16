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
```

**Syntax validation:**
```bash
bash -n bin/rautils             # Validate main script syntax
bash -n libexec/rautils-*       # Validate all command scripts
```

**Testing a new command:**
```bash
./bin/rautils <command>         # Execute command locally before installation
```

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
The `VERSION` file contains the current version. The main script reads this and makes it available to all commands via the `RAUTILS_VERSION` environment variable.

## Adding New Commands

1. Create `libexec/rautils-mycommand` with proper shebang, description, and implementation
2. Make it executable: `chmod +x libexec/rautils-mycommand`
3. Validate syntax: `bash -n libexec/rautils-mycommand`
4. Test locally: `./bin/rautils mycommand`
5. The command automatically appears in `rautils help` output

The description header is critical—it's parsed by the help system and displayed to users.

## Releasing Versions

Update the `VERSION` file and `homebrew/rautils.rb` with the new version, then:
```bash
git commit -am "Bump version to X.Y.Z"
git tag -a vX.Y.Z -m "Release version X.Y.Z"
git push origin main --tags
```
After pushing, the Homebrew tap repository needs to be updated separately.
