# generate-app-tray-icons

Generates macOS menu bar (system tray) icons from a source PNG image.

## Usage

```bash
rautils generate-app-tray-icons <source-png-file>
```

## Arguments

| Argument           | Description                                                  |
|--------------------|--------------------------------------------------------------|
| `<source-png-file>` | Path to a high-resolution, square, monochrome PNG (white on transparent) |

## Output

All icons are generated in a `tray-icons/` directory:

| File              | Size  | Description       |
|-------------------|-------|-------------------|
| `tray-16.png`     | 16x16 | 16pt @1x          |
| `tray-16@2x.png`  | 32x32 | 16pt @2x (Retina) |
| `tray-20.png`     | 20x20 | 20pt @1x          |
| `tray-20@2x.png`  | 40x40 | 20pt @2x (Retina) |
| `tray-24.png`     | 24x24 | 24pt @1x          |
| `tray-24@2x.png`  | 48x48 | 24pt @2x (Retina) |

## Requirements

- `sips` (included with macOS)

## Example

```bash
rautils generate-app-tray-icons tray-icon-source.png
```

This creates a `tray-icons/` directory with all standard menu bar icon sizes.
