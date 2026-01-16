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

This project uses an automated release system. To create a new release:

1. Ensure all changes are committed and pushed
2. Run the release command:
   ```bash
   make release type=patch   # For bug fixes (0.1.0 -> 0.1.1)
   make release type=minor   # For new features (0.1.0 -> 0.2.0)
   make release type=major   # For breaking changes (0.1.0 -> 1.0.0)
   ```

The release process will automatically:
- Run validation checks on all bash scripts
- Bump the version in the VERSION file (semantic versioning)
- Update the Homebrew formula template
- Create a git commit and tag
- Push changes and tags to GitHub
- Trigger GitHub Actions to create the release
- Update the Homebrew tap repository with the correct SHA256

#### Validation Before Release

To manually validate the project before releasing:

```bash
make validate
```

This checks:
- VERSION file format (MAJOR.MINOR.PATCH)
- Bash syntax of all scripts
- Executable permissions
- Git repository status

#### Troubleshooting Releases

If a release fails:
- Check the GitHub Actions logs: https://github.com/raulanatol/rautils/actions
- For tap update failures, you may need to manually update the Homebrew tap
- The release scripts include automatic rollback for most failure scenarios

#### Requirements

- Git configured with push access to the repository
- If setting up automated Homebrew tap updates: configure `HOMEBREW_TAP_TOKEN` secret in GitHub repository settings

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
