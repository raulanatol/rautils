# network

Network utilities.

## Usage

```bash
rautils network <subcommand> [options]
```

## Subcommands

### `ip`

Shows your public IP address. Use `--local` to show the local network IP instead.

```bash
rautils network ip
# 203.0.113.42

rautils network ip --local
# 192.168.1.10
```

Uses `dig` (OpenDNS) by default, falling back to `wget`/`curl` for public IP. Uses `ipconfig` for local IP.

### `ports`

Lists all TCP ports currently in use (listening state). Requires `sudo`.

```bash
rautils network ports
```

## Examples

```bash
# Check your public IP
rautils network ip

# Check your local IP
rautils network ip -l

# See what's listening on your machine
rautils network ports
```

## Shell aliases

After running `eval "$(rautils load)"`, you can use shorthand functions:

```bash
ra::network::ip
ra::network::ip --local
ra::network::ports
```
