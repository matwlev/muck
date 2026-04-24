# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.0] - 2026-04-24

### Added
- CSS custom property theme system with two layers: fixed color options (`--muck-color-*`) and semantic intent tokens (`--muck-theme-palette-*`)
- New theme variants: `nav-light`, `nav-dark`, `nav-dynamic`
- `--no-theme` flag to suppress a config-set default theme for a single run
- `install.sh --no-config` to skip `~/.muck/` setup entirely
- `install.sh --reset-config` to overwrite an existing `~/.muck/`
- `~/.muck/styles/` and `~/.muck/scripts/` directories for theme assets

### Changed
- **Breaking:** Default output is now plain unstyled HTML. Previously `dynamic` was applied by default. Set `--theme dynamic` in `~/.muck/config` to restore the old behavior (the default install does this automatically).
- **Breaking:** `muck` no longer has any built-in theme knowledge. All themes (`light`, `dark`, `dynamic`, `nav-*`, `none`) are defined in `~/.muck/config` by the installer.
- **Breaking:** `--theme none` replaced by `--no-theme`.
- Theme assets moved from `~/.local/bin/` to `~/.muck/styles/` and `~/.muck/scripts/`.

### Removed
- Hardcoded `light`, `dark`, `dynamic`, `nav` theme definitions from the `muck` binary
- `muck-light.min.css`, `muck-dark.min.css`, `muck-dynamic.min.css` replaced by unminified source files using CSS custom properties

## [1.1.0] - 2026-04-22

### Added
- `--mirror-structure` flag to preserve input directory layout in output
- `muck-serve`: `-o` flag for specifying output directory
- `muck-serve`: smarter `--open` entry detection when serving a directory

### Fixed
- `muck-serve`: `--mirror-structure` not preserving directory layout during live preview
- `muck`: parent directories now created for mirrored output paths

## [1.0.0] - 2026-04-19

### Added
- Initial release
- Convert Markdown to styled HTML or PDF via `pandoc`
- Built-in light, dark, and dynamic (auto) themes
- Inline or linked stylesheets and JavaScript
- PDF generation via `weasyprint`, `wkhtmltopdf`, or LaTeX engines
- Multiple input files and directory expansion
- Filename transforms: `lowercase`, `kebab`, `snake`, and custom sed expressions
- Automatic `.md` → `.html` link rewriting
- Config file support (`muck.config` / `~/.muck/config`) with custom themes and transforms
- `muck-serve` live-preview server with auto-reload
- `--version` flag for both `muck` and `muck-serve`
