# muck

A simple bash tool that converts Markdown files to styled HTML or PDF.

## Prerequisites

muck requires [pandoc](https://pandoc.org) for Markdown-to-HTML conversion. Install it via your package manager:

```bash
# macOS
brew install pandoc

# Debian / Ubuntu
sudo apt install pandoc

# Windows
choco install pandoc
```

Or download it directly from [pandoc.org/installing](https://pandoc.org/installing.html).

### PDF generation (optional)

To generate PDFs, you also need a PDF engine. muck defaults to [weasyprint](https://weasyprint.org):

```bash
# macOS
brew install weasyprint

# Debian / Ubuntu
sudo apt install weasyprint

# pip
pip install weasyprint
```

If you installed weasyprint via `pip`, you also need its system-level dependencies (Pango, GLib, etc.):

```bash
# macOS
brew install pango
```

On Debian/Ubuntu these are pulled in automatically by `apt install weasyprint`.

Other supported engines include [wkhtmltopdf](https://wkhtmltopdf.org) and LaTeX-based engines like `pdflatex`. Pass your preferred engine with `--pdf-engine`.

## What's in this folder

- `muck` — the main script
- `muck-serve` — live-preview server with auto-reload
- `muck-dynamic.min.css` — bundled stylesheet (dynamic, auto light/dark)
- `muck-light.min.css` — light-only stylesheet
- `muck-dark.min.css` — dark-only stylesheet
- `install.sh` — one-step installer
- `uninstall.sh` — removes muck from your system

## Quick install

```bash
cd ~/projects/personal/muck
./install.sh
```

This installs the scripts and stylesheet:
- Scripts → `~/.local/bin/muck` and `~/.local/bin/muck-serve`
- Stylesheet → `~/.local/bin/muck-dynamic.min.css`

## Usage

### Basic

```bash
# Convert with inline styles (default)
muck -i notes.md

# Specify output filename
muck -i notes.md -o notes.html

# Custom stylesheet
muck -i notes.md -s ./my-theme.css

# Multiple stylesheets (applied in order)
muck -i notes.md -s ./reset.css --style-link https://cdn.example.com/base.css -s ./custom.css
```

### Multiple files

```bash
# Convert several files at once
muck -i ch1.md -i ch2.md -i ch3.md

# Convert all Markdown files in a directory
muck -i ~/Documents/markdown/

# Also works with globs
muck -i ~/Documents/markdown/*.md

# Output all to a specific directory
muck -i ~/Documents/markdown/ -o ./output/

# With shared options
muck -i *.md -s ./theme.css --filename-transform lowercase
```

When converting multiple files, each gets its own output file (named after the input). Use `-o dir/` to put all outputs in a specific directory. When `-i` is a directory, all `.md` files inside it are converted.

### Linked stylesheets

```bash
# Link to CSS CDN instead of inlining
muck -i notes.md --style-link

# Link to a remote URL
muck -i notes.md --style-link https://example.com/style.css

# Link to a local CSS file (creates output folder with HTML + CSS)
muck -i notes.md --style-link ./my-theme.css
```

### JavaScript

```bash
# Inline a script
muck -i notes.md --script ./app.js

# Link an external script URL
muck -i notes.md --script-link https://cdn.example.com/lib.js

# Link a local script (creates output folder with HTML + JS)
muck -i notes.md --script-link ./app.js
```

### PDF generation

```bash
# Generate PDF (uses weasyprint by default)
muck -i notes.md -o notes.pdf

# Custom engine and page layout
muck -i notes.md -o report.pdf --pdf-engine weasyprint --page-size A4 --margin 2cm
```

### Themes

```bash
# Use a built-in theme (default is dynamic)
muck -i notes.md --theme dynamic

# Light theme
muck -i notes.md --theme light

# Dark theme
muck -i notes.md --theme dark

# No theme
muck -i notes.md --theme none

# Use a custom theme (defined in config)
muck -i notes.md --theme dracula
```

### Filename transforms

```bash
# Lowercase the output filename
muck -i "My Notes.md" --filename-transform lowercase
# -> my notes.html

# Combine transforms: lowercase + kebab-case
muck -i "My Notes.md" --filename-transform lowercase --filename-transform kebab
# -> my-notes.html

# Use a sed expression to strip a prefix
muck -i Draft_Report.md --filename-transform 's/Draft_//'
# -> Report.html
```

### Live preview

`muck-serve` watches your Markdown files and live-reloads the browser on every save. You can pass a single file or an entire directory.

```bash
# Basic live preview
muck-serve -i notes.md

# Serve a whole directory (all .md files are built and watched)
muck-serve -i ./docs/

# Serve the current directory
muck-serve -i .

# Open in browser automatically
muck-serve -i notes.md --open

# Custom port with a stylesheet
muck-serve -i notes.md -p 3000 -- -s ./my-theme.css
```

When serving a directory, interlinked `.md` files are all converted and kept in sync — editing any file triggers a rebuild and live-reload. New `.md` files added to the directory are picked up automatically.

Press `Ctrl+C` to stop the server.

## Command reference

### muck

| Flag | Short | Description |
|------|-------|-------------|
| `--input FILE\|DIR` | `-i FILE\|DIR` | Input Markdown file or directory (required, repeatable) |
| `--output FILE\|DIR` | `-o FILE\|DIR` | Output file or directory (trailing `/`). Defaults to input filename with .html |
| `--stylesheet FILE` | `-s FILE` | Inline a CSS file (repeatable) |
| `--style-link [FILE\|URL]` | | Link a stylesheet (repeatable). No value = CDN stylesheet |
| `--script FILE` | | Inline a JavaScript file |
| `--script-link FILE\|URL` | | Link a JavaScript file or URL |
| `--pdf-engine ENGINE` | | PDF engine (default: `weasyprint`) |
| `--page-size SIZE` | | PDF page size (default: `letter`) |
| `--margin MARGIN` | | PDF page margin (default: `1in`) |
| `--config FILE` | `-c FILE` | Use a specific config file |
| `--theme NAME` | | Apply a theme (default: `dynamic`). Built-in: `light`, `dark`, `dynamic`, `none` |
| `--filename-transform T` | | Transform output filename (repeatable). Presets: `lowercase`, `kebab`, `snake` |
| `--no-rewrite-links` | | Don't rewrite `.md` links to `.html` in output |
| `--help` | `-h` | Show help |
| `--version` | | Show version |

### muck-serve

| Flag | Short | Description |
|------|-------|-------------|
| `--input FILE\|DIR` | `-i FILE\|DIR` | Input Markdown file or directory (required, repeatable) |
| `--port PORT` | `-p PORT` | HTTP server port (default: `8080`) |
| `--open` | | Open preview in default browser |
| `--` | | Pass remaining arguments to muck |
| `--help` | `-h` | Show help |
| `--version` | | Show version |

## Config file

muck looks for a config in this order:
1. Explicit `--config` / `-c` flag
2. `./muck.config` (current directory)
3. `~/.muck/config` (home directory)

The config file uses the same options as the CLI, one per line. CLI arguments always override config values.

```
# muck.config
--stylesheet ./theme.css
--page-size A4
--margin 2cm
```

### Custom themes

Define custom themes in a `[themes]` section. Each line is a name followed by a stylesheet URL or local file path:

```
[themes]
dracula https://cdn.example.com/dracula.css
custom ./styles/custom.css
```

The theme stylesheet is applied first; any additional `-s`/`--style-link` options layer on top. Built-in themes (`light`, `dark`, `dynamic`, `none`) are always available.

### Custom filename transforms

Define custom transforms in a `[filename-transforms]` section. Each line is a name followed by a sed expression:

```
[filename-transforms]
strip-draft s/Draft_//
no-spaces s/ /-/g
```

Custom transforms can be combined with built-in presets and stacked in any order.

## Supported Markdown

Headings, bold, italic, links, images, inline code, fenced code blocks, tables, blockquotes, ordered/unordered lists, task lists, strikethrough, horizontal rules, and paragraphs.

## Notes

- Links to `.md` files are automatically rewritten to `.html` in the output (disable with `--no-rewrite-links`)
- Default output is a single self-contained HTML file with styling embedded in a `<style>` tag
- When linking local CSS or JS files, muck creates an output folder containing the HTML and copies of the linked files
- Stylesheets are added to the document head in the order they're passed
