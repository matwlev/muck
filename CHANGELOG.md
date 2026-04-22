# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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
