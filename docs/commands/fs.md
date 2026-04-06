# fs

Filesystem utilities.

## Usage

```bash
rautils fs <subcommand> [path]
```

## Subcommands

### `folder-size`

Shows the total size of a folder. Defaults to the current directory if no path is given.

```bash
rautils fs folder-size
# 1.2G    .

rautils fs folder-size ~/Projects
# 15G     /Users/me/Projects
```

## Examples

```bash
# Check current directory size
rautils fs folder-size

# Check a specific folder
rautils fs folder-size node_modules
```

## Shell aliases

After running `eval "$(rautils load)"`, you can use shorthand functions:

```bash
ra::fs::folder-size
ra::fs::folder-size ~/Projects
```
