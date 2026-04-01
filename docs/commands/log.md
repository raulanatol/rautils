# log

Prints formatted log messages to the terminal.

## Usage

```bash
rautils log <level> <message>
```

## Levels

| Level     | Color | Prefix |
|-----------|-------|--------|
| `info`    | Blue  | —      |
| `success` | Green | 🤘     |
| `error`   | Red   | ❗     |

## Examples

```bash
rautils log info "Deploying to staging..."
rautils log success "Deploy complete"
rautils log error "Connection failed"
```

## Shell aliases

After running `eval "$(rautils load)"`, you can use shorthand functions:

```bash
ra::log::info "Deploying..."
ra::log::success "Done"
ra::log::error "Something went wrong"
```
