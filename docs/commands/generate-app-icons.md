# generate-app-icons

Generates macOS app icons (`.icns`) and favicon from a source PNG image.

## Usage

```bash
rautils generate-app-icons <source-png-file>
```

## Arguments

| Argument           | Description                                  |
|--------------------|----------------------------------------------|
| `<source-png-file>` | Path to a square PNG file (minimum 1024x1024) |

## Output

- `<name>.iconset/` — folder containing all icon sizes
- `<name>.icns` — macOS app icon file
- `favicon.ico` — multi-resolution favicon (if ImageMagick or ffmpeg available)

### Generated icon sizes

| File                    | Size      |
|-------------------------|-----------|
| `icon_16x16.png`        | 16x16     |
| `icon_16x16@2x.png`     | 32x32     |
| `icon_32x32.png`        | 32x32     |
| `icon_32x32@2x.png`     | 64x64     |
| `icon_128x128.png`      | 128x128   |
| `icon_128x128@2x.png`   | 256x256   |
| `icon_256x256.png`      | 256x256   |
| `icon_256x256@2x.png`   | 512x512   |
| `icon_512x512.png`      | 512x512   |
| `icon_512x512@2x.png`   | 1024x1024 |

## Requirements

- `sips` (included with macOS)
- `iconutil` (included with Xcode Command Line Tools)
- For favicon: `ImageMagick` (recommended) or `ffmpeg`

## Example

```bash
rautils generate-app-icons my-logo.png
```

This creates `my-logo.iconset/`, `my-logo.icns`, and `favicon.ico`.
