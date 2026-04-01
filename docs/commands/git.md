# git

Git utility commands for branch cleanup and synchronization.

## Usage

```bash
rautils git <subcommand>
```

## Subcommands

### `delete-merged`

Deletes local branches that have already been merged into the current branch. Branches named `main`, `master`, and `develop` are always preserved. Also prunes stale git worktrees.

```bash
rautils git delete-merged
```

### `sync`

Switches to the default branch (auto-detected: `main` or `master`), pulls latest changes, and deletes merged branches.

```bash
rautils git sync
```

## Examples

```bash
# Clean up merged branches from the current branch
rautils git delete-merged

# Full sync: switch to main, pull, and clean up
rautils git sync
```

## Shell aliases

After running `eval "$(rautils load)"`, you can use shorthand functions:

```bash
ra::git::delete-merged
ra::git::sync
```
