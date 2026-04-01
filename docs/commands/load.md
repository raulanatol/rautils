# load

Outputs shell functions so rautils commands can be called as `ra::*` functions.

## Setup

Add this line to your `.zshrc` or `.bashrc`:

```bash
eval "$(rautils load)"
```

## What it does

For each command in `libexec/`, `load` generates a function `ra::<command>()`. If the command supports subcommands (via `--aliases`), it also generates sub-functions like `ra::<command>::<sub>()`.

## Available functions after loading

```bash
ra::generate-app-icons <source-png>
ra::generate-app-tray-icons <source-png>
ra::log <level> <message>
ra::log::info <message>
ra::log::success <message>
ra::log::error <message>
```
