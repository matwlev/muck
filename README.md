# muck

A bash tool that converts Markdown files to HTML or PDF.

## Prerequisites

muck requires [pandoc](https://pandoc.org) for Markdown-to-HTML conversion:

```bash
brew install pandoc        # macOS
sudo apt install pandoc    # Debian/Ubuntu
choco install pandoc       # Windows
```

### PDF generation (optional)

muck defaults to [weasyprint](https://weasyprint.org):

```bash
brew install weasyprint    # macOS
sudo apt install weasyprint  # Debian/Ubuntu
pip install weasyprint     # pip (also needs: brew install pango on macOS)
```

Other supported engines: [wkhtmltopdf](https://wkhtmltopdf.org), `pdflatex`. Pass with `--pdf-engine`.

## Install

```bash
cd ~/projects/muck
./install.sh
```

Installs to `~/.local/bin/` and creates `~/.muck/` with built-in themes and a default config.

```
~/.local/bin/muck
~/.local/bin/muck-serve
~/.muck/
  config              ← default config (--theme dynamic)
  themes/
    light/            ← style.css
    dark/             ← style.css
    dynamic/          ← style.css
    nav-light/        ← style.css, script.js
    nav-dark/         ← style.css, script.js
    nav-dynamic/      ← style.css, script.js
```

### Install options

```bash
./install.sh --no-config      # skip ~/.muck/ setup entirely
./install.sh --reset-config   # overwrite existing ~/.muck/
```

### Uninstall

```bash
./uninstall.sh
```

## Usage

### Basic

```bash
# Plain HTML, no theme
muck -i notes.md

# With a theme
muck -i notes.md --theme dynamic

# Specify output filename
muck -i notes.md -o notes.html

# Custom stylesheet
muck -i notes.md -s ./my-theme.css

# Multiple stylesheets (applied in order)
muck -i notes.md -s ./reset.css --style-link https://cdn.example.com/base.css -s ./custom.css
```

### Multiple files

```bash
muck -i ch1.md -i ch2.md -i ch3.md
muck -i ~/Documents/markdown/
muck -i ~/Documents/markdown/*.md
muck -i ~/Documents/markdown/ -o ./output/
muck -i ~/Documents/markdown/ -o ./output/ --mirror-structure
```

When converting multiple files, each gets its own output file. Use `-o dir/` to collect all outputs in one place. When `-i` is a directory, all `.md` files inside are converted.

### Linked stylesheets

```bash
muck -i notes.md --style-link https://example.com/style.css
muck -i notes.md --style-link ./my-theme.css  # creates output folder with HTML + CSS
```

### JavaScript

```bash
muck -i notes.md --script ./app.js
muck -i notes.md --script-link https://cdn.example.com/lib.js
muck -i notes.md --script-link ./app.js  # creates output folder with HTML + JS
```

### PDF generation

```bash
muck -i notes.md -o notes.pdf
muck -i notes.md -o report.pdf --pdf-engine weasyprint --page-size A4 --margin 2cm
```

### Themes

The default install creates six themes in `~/.muck/themes/`, ready to use:

| Theme | Description |
|-------|-------------|
| `light` | Light mode |
| `dark` | Dark mode |
| `dynamic` | Auto light/dark based on system preference |
| `nav-light` | Light mode with sidebar navigation |
| `nav-dark` | Dark mode with sidebar navigation |
| `nav-dynamic` | Auto light/dark with sidebar navigation |

```bash
muck -i notes.md --theme dynamic
muck -i notes.md --theme dark
muck -i notes.md --no-theme   # suppress config default for this run
```

Any folder in `~/.muck/themes/` is automatically a valid theme — no config entry needed. A theme folder can contain a `style.css`, a `script.js`, or both:

```
~/.muck/themes/
  my-theme/
    style.css
    script.js   ← optional
```

You can also define themes explicitly in the config `[themes]` section (see [Config file](#config-file)). If a theme name exists as both a folder and a `[themes]` entry, the folder assets load first and the config assets are appended after. This lets you extend a folder-based theme with extra styles or scripts:

```
[themes]
my-theme  ./overrides.css script-link:./extra.js
```

The `nav-*` themes add a sidebar showing the full file tree with the current page highlighted. They work best with `--mirror-structure`:

```bash
muck -i ./docs/ -o ./output/ --mirror-structure --theme nav-dynamic
muck-serve -i ./docs/ --mirror-structure --open -- --theme nav-dynamic
```

### CSS custom properties

The built-in themes are built on a two-layer CSS custom property system:

- `--muck-color-*` — fixed color options (palette scale, never change)
- `--muck-theme-palette-*` — semantic intent tokens that map to color options

To customize, override intent tokens in your own stylesheet:

```css
:root {
  --muck-theme-palette-primary-main: var(--muck-color-purple-30);
  --muck-theme-palette-primary-contrast: var(--muck-color-gray-100);
}
```

Or swap a palette color entirely:

```css
:root {
  --muck-color-blue-30: #005cc5;
}
```

### muck script

Every conversion injects a `const muck` at the top of `<body>`:

```js
const muck = {
  tree: [ /* nested file tree */ ],
  current: "/path/to/current.html"
};
```

`tree` is a nested array of converted files. Each node is a file (`{ label, path }`) or directory (`{ label, children }`). `current` is the root-relative path of the current page. The `nav-*` themes use this to render the sidebar.

```bash
muck -i notes.md --no-muck-script  # suppress injection
```

### Filename transforms

```bash
muck -i "My Notes.md" --filename-transform lowercase
# -> my notes.html

muck -i "My Notes.md" --filename-transform lowercase --filename-transform kebab
# -> my-notes.html

muck -i Draft_Report.md --filename-transform 's/Draft_//'
# -> Report.html
```

### Live preview

```bash
muck-serve -i notes.md
muck-serve -i ./docs/
muck-serve -i notes.md --open
muck-serve -i notes.md -p 3000 -- -s ./my-theme.css
muck-serve -i ./docs/ --mirror-structure -- --theme nav-dynamic
```

Editing any file triggers a rebuild and live-reload. New `.md` files are picked up automatically. Press `Ctrl+C` to stop.

`muck-serve` invokes `muck` for each conversion, so any defaults set in `~/.muck/config` (including `--theme`) apply automatically.

## Command reference

### muck

| Flag | Short | Description |
|------|-------|-------------|
| `--input FILE\|DIR` | `-i` | Input Markdown file or directory (required, repeatable) |
| `--output FILE\|DIR` | `-o` | Output file or directory (trailing `/`). Defaults to input filename with `.html` |
| `--stylesheet FILE` | `-s` | Inline a CSS file (repeatable) |
| `--style-link FILE\|URL` | | Link a stylesheet (repeatable) |
| `--script FILE` | | Inline a JavaScript file (repeatable) |
| `--script-link FILE\|URL` | | Link a JavaScript file or URL (repeatable) |
| `--pdf-engine ENGINE` | | PDF engine (default: `weasyprint`) |
| `--page-size SIZE` | | PDF page size (default: `letter`) |
| `--margin MARGIN` | | PDF page margin (default: `1in`) |
| `--config FILE` | `-c` | Config file (defaults to `./muck.config`, then `~/.muck/config`) |
| `--theme NAME` | | Apply a theme defined in config |
| `--no-theme` | | Suppress config default theme for this run |
| `--filename-transform T` | | Transform output filename (repeatable). Presets: `lowercase`, `kebab`, `snake` |
| `--no-rewrite-links` | | Don't rewrite `.md` links to `.html` |
| `--keep-theme` | | Keep config theme when `-s`/`--style-link` is also used |
| `--mirror-structure` | | Preserve input directory structure in output (default: on) |
| `--no-mirror-structure` | | Flatten all outputs into the output directory |
| `--no-muck-script` | | Don't inject the `muck` script |
| `--help` | `-h` | Show help |
| `--version` | | Show version |

### muck-serve

| Flag | Short | Description |
|------|-------|-------------|
| `--input FILE\|DIR` | `-i` | Input Markdown file or directory (required, repeatable) |
| `--port PORT` | `-p` | HTTP server port (default: `8080`) |
| `--open` | | Open preview in default browser |
| `--mirror-structure` | | Preserve input directory structure in output (default: on) |
| `--no-mirror-structure` | | Flatten all outputs into the output directory |
| `--` | | Pass remaining arguments to muck |
| `--help` | `-h` | Show help |
| `--version` | | Show version |

## Config file

muck looks for a config in this order:
1. `--config` / `-c` flag
2. `./muck.config` (current directory)
3. `~/.muck/config` (home directory)

Options are listed one per line. CLI args always override config values.

```
# muck.config
--theme dynamic
--page-size A4
--margin 2cm
```

### Themes

Any folder in `~/.muck/themes/` is automatically a valid theme — no config entry needed. You can also define themes explicitly in a `[themes]` section. Each line is a name followed by space-separated assets. Unprefixed paths/URLs are stylesheets; `script:` inlines JS; `script-link:` links JS:

```
[themes]
dracula  https://cdn.example.com/dracula.css
fancy    ./style.css ./extra.css script:./toggle.js
none
```

If a theme name exists as both a folder and a `[themes]` entry, the folder assets load first and the config assets are appended after. This lets you extend a folder-based theme with extra styles or scripts:

```
[themes]
my-theme  ./overrides.css script-link:./extra.js
```

Theme assets are applied first; `-s`/`--style-link`/`--script`/`--script-link` layer on top.

### Scripts

```
[scripts]
./analytics.js
link:./app.js
https://cdn.example.com/lib.js
```

Config scripts are applied before any `--script`/`--script-link` flags.

### Custom filename transforms

```
[filename-transforms]
strip-draft  s/Draft_//
no-spaces    s/ /-/g
```

## Supported Markdown

Headings, bold, italic, links, images, inline code, fenced code blocks, tables, blockquotes, ordered/unordered lists, task lists, strikethrough, horizontal rules, paragraphs.

## Notes

- Links to `.md` files are automatically rewritten to `.html` (disable with `--no-rewrite-links`)
- Default output is a self-contained HTML file with styles and scripts inlined
- When linking local CSS or JS files, muck creates an output folder containing the HTML and asset copies
- Stylesheets are added to `<head>` in order; scripts are added to `<body>` in order
