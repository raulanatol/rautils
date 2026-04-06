# rautils

A collection of utility commands for macOS.

## Installation

### Via Homebrew (Recommended)

```bash
brew install raulanatol/rautils/rautils
```

### From Source

```bash
git clone https://github.com/raulanatol/rautils.git
cd rautils
./bin/rautils help
```

## Quick Start

```bash
rautils help                          # Show all available commands
rautils generate-app-icons logo.png   # Generate macOS app icons
rautils log info "Hello world"        # Print formatted log message
```

To use commands as `ra::*` shell functions, add this to your `.zshrc` or `.bashrc`:

```bash
eval "$(rautils load)"
```

Then:

```bash
ra::log::info "Deploying..."
ra::log::success "Done"
ra::generate-app-icons logo.png
```

## Commands

| Command | Description |
|---------|-------------|
| [`docker`](docs/commands/docker.md) | Docker utilities (connect) |
| [`fs`](docs/commands/fs.md) | Filesystem utilities (folder-size) |
| [`generate-app-icons`](docs/commands/generate-app-icons.md) | Generates macOS app icons (`.icns`) and favicon from a PNG |
| [`generate-app-tray-icons`](docs/commands/generate-app-tray-icons.md) | Generates macOS menu bar icons from a PNG |
| [`git`](docs/commands/git.md) | Git utilities (delete-merged, sync) |
| [`github`](docs/commands/github.md) | GitHub utilities (open-actions) |
| [`load`](docs/commands/load.md) | Outputs shell functions for `ra::*` aliases |
| [`log`](docs/commands/log.md) | Prints formatted log messages (info, success, error) |
| [`mac`](docs/commands/mac.md) | macOS utilities (hidden-files, bluetooth, temperature) |
| [`network`](docs/commands/network.md) | Network utilities (ip, ports) |
| [`string`](docs/commands/string.md) | String manipulation (uppercase, lowercase, is-number) |
| `help` | Shows all available commands |

## Development

### Prerequisites

- macOS
- Bash 4.0+
- Git

### Project Structure

```
rautils/
├── bin/rautils              # Main executable (command router)
├── libexec/rautils-*        # Command implementations
├── scripts/                 # Release and validation scripts
├── homebrew/rautils.rb      # Homebrew formula
├── docs/commands/           # Command documentation
├── VERSION                  # Current version (semver)
└── Makefile                 # Build/release commands
```

### Adding New Commands

1. Create `libexec/rautils-mycommand` with a `# Description:` header
2. Make it executable: `chmod +x libexec/rautils-mycommand`
3. Run `make validate`
4. Test: `./bin/rautils mycommand`
5. Add documentation in `docs/commands/mycommand.md`

The command automatically appears in `rautils help`.

### Validation

```bash
make validate
```

### Releasing

```bash
make release type=patch   # Bug fixes (0.1.0 -> 0.1.1)
make release type=minor   # New features (0.1.0 -> 0.2.0)
make release type=major   # Breaking changes (0.1.0 -> 1.0.0)
```

## License

MIT License - See [LICENSE](LICENSE) for details.
