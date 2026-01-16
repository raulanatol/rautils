# rautils

A collection of utility commands for macOS. This project provides a CLI tool with extensible subcommands for common tasks and utilities.

## Installation

### Via Homebrew (Recommended)

```bash
brew tap raulanatol/rautils
brew install rautils
```

Or install directly without adding the tap:

```bash
brew install raulanatol/rautils/rautils
```

### From Source

```bash
git clone https://github.com/raulanatol/rautils.git
cd rautils
./bin/rautils help
```

## Usage

The main command is `rautils` followed by a subcommand:

```bash
rautils <command> [options]
```

### View Available Commands

```bash
rautils help
```

Output:
```
rautils version 0.1.0

Usage: rautils <command> [options]

Available commands:
  help        Show this help message

For more information on a specific command, run:
  rautils <command> --help
```

## Development

### Prerequisites

- macOS
- Bash 4.0+
- Git

### Project Structure

```
rautils/
├── VERSION                  # Version file
├── bin/
│   └── rautils             # Main executable (command router)
├── libexec/
│   └── rautils-help        # Help subcommand implementation
├── homebrew/
│   └── rautils.rb          # Homebrew formula
├── README.md               # This file
└── LICENSE                 # MIT License
```

### Running Locally

```bash
./bin/rautils help
./bin/rautils              # Defaults to help
```

### Adding New Commands

To add a new command, create a new script in the `libexec/` directory:

1. Create the script file: `libexec/rautils-mycommand`
2. Add a description comment on the first line:
   ```bash
   #!/usr/bin/env bash
   # Description: Brief description of what this command does
   ```
3. Implement your command logic
4. Make it executable: `chmod +x libexec/rautils-mycommand`
5. The command will automatically appear in `rautils help` output

#### Example New Command

```bash
#!/usr/bin/env bash
# Description: Display system information

set -eo pipefail

echo "System Information"
echo "Version: $RAUTILS_VERSION"
echo "Installed at: $RAUTILS_PREFIX"
uname -a
```

### Testing

Run syntax checks:

```bash
bash -n bin/rautils
bash -n libexec/rautils-*
```

Test commands locally:

```bash
./bin/rautils help
./bin/rautils nonexistent  # Test error handling
```

### Environment Variables

When a subcommand is executed, the following environment variables are available:

- `RAUTILS_PREFIX`: Installation directory (where bin/, libexec/, VERSION are located)
- `RAUTILS_VERSION`: Current version from VERSION file
- `RAUTILS_LIBEXEC`: Path to the libexec directory

### Releasing a New Version

1. Update the VERSION file with the new version number
2. Update `homebrew/rautils.rb` with the new version
3. Commit and tag:
   ```bash
   git commit -am "Bump version to X.Y.Z"
   git tag -a vX.Y.Z -m "Release version X.Y.Z"
   git push origin main --tags
   ```
4. Update the Homebrew tap repository

## Installation Verification

After installing via Homebrew, verify the installation:

```bash
# Check if rautils is in PATH
which rautils

# Test the help command
rautils help

# Test from any directory
cd ~
rautils help
```

## Uninstallation

To uninstall via Homebrew:

```bash
brew uninstall rautils

# If you added the tap, optionally remove it:
brew untap raulanatol/rautils
```

## Contributing

Contributions are welcome! To contribute:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test your changes locally
5. Submit a pull request

When adding new commands, please:
- Follow bash best practices and style conventions
- Include a description comment in the script header
- Test your command works with the main `rautils` router
- Update this README if adding user-facing features

## License

MIT License - See [LICENSE](LICENSE) file for details

## Support

For issues, questions, or suggestions, please open an issue on GitHub:
https://github.com/raulanatol/rautils/issues
