# mac

macOS-specific utilities.

## Usage

```bash
rautils mac <subcommand> [options]
```

## Subcommands

### `hidden-files`

Shows or hides hidden files in Finder. Restarts Finder automatically.

```bash
rautils mac hidden-files on
rautils mac hidden-files off
```

### `bluetooth`

Toggles Bluetooth on or off. Requires [blueutil](http://www.frederikseiffert.de/blueutil/) (`brew install blueutil`).

```bash
rautils mac bluetooth on
rautils mac bluetooth off
```

### `temperature`

Shows the CPU die temperature. Requires `sudo`.

```bash
rautils mac temperature
```

## Examples

```bash
# Show hidden files in Finder
rautils mac hidden-files on

# Turn off Bluetooth
rautils mac bluetooth off

# Check CPU temperature
rautils mac temperature
```

## Shell aliases

After running `eval "$(rautils load)"`, you can use shorthand functions:

```bash
ra::mac::hidden-files on
ra::mac::bluetooth off
ra::mac::temperature
```
