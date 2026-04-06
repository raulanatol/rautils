# github

GitHub utilities.

## Usage

```bash
rautils github <subcommand>
```

## Subcommands

### `actions`

Opens the GitHub Actions page for the current repository in your default browser. Automatically converts SSH remote URLs to HTTPS.

```bash
rautils github actions
```

## Examples

```bash
# Open Actions page for current repo
cd ~/Projects/my-repo
rautils github actions
# Opening https://github.com/user/my-repo/actions
```

## Shell aliases

After running `eval "$(rautils load)"`, you can use shorthand functions:

```bash
ra::github::actions
```
