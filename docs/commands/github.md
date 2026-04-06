# github

GitHub utility commands.

## Usage

```bash
rautils github <subcommand>
```

## Subcommands

### `open-actions`

Opens the GitHub Actions page for the current repository in the default browser. Detects the repository URL from the `origin` remote (supports both SSH and HTTPS remotes).

```bash
rautils github open-actions
```

## Examples

```bash
# Open the Actions page for the current repo
rautils github open-actions
```

## Shell aliases

After running `eval "$(rautils load)"`, you can use shorthand functions:

```bash
ra::github::open-actions
```
