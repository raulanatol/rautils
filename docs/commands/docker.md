# docker

Docker utilities.

## Usage

```bash
rautils docker <subcommand>
```

## Subcommands

### `connect`

Lists running Docker containers and opens an interactive shell into the selected one. Uses `fzf` for selection if available, otherwise falls back to a numbered list. Tries `/bin/bash` first, then `/bin/sh`.

```bash
rautils docker connect
```

## Examples

```bash
# Connect to a running container
rautils docker connect
# Select container: 1  my-app  node:18-alpine
# Opens /bin/bash (or /bin/sh) in the container
```

## Shell aliases

After running `eval "$(rautils load)"`, you can use shorthand functions:

```bash
ra::docker::connect
```
