# string

String manipulation utilities.

## Usage

```bash
rautils string <subcommand> <value>
```

## Subcommands

### `uppercase`

Converts a string to uppercase.

```bash
rautils string uppercase "hello world"
# HELLO WORLD
```

### `lowercase`

Converts a string to lowercase.

```bash
rautils string lowercase "HELLO WORLD"
# hello world
```

### `is-number`

Checks if a value is a number. Prints `true` and exits with code 0 if it is, prints `false` and exits with code 1 otherwise. Supports integers, decimals, and negative numbers.

```bash
rautils string is-number 42
# true (exit code 0)

rautils string is-number "hello"
# false (exit code 1)
```

## Examples

```bash
# Convert to uppercase
rautils string uppercase "deploy started"

# Use in conditionals
if rautils string is-number "$VALUE"; then
    echo "$VALUE is a number"
fi
```

## Shell aliases

After running `eval "$(rautils load)"`, you can use shorthand functions:

```bash
ra::string::uppercase "hello"
ra::string::lowercase "HELLO"
ra::string::is-number 42
```
