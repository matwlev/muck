#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

mkdir -p "$HOME/.local/bin"
cp "$SCRIPT_DIR/muck" "$HOME/.local/bin/muck"
chmod +x "$HOME/.local/bin/muck"
cp "$SCRIPT_DIR/muck-serve" "$HOME/.local/bin/muck-serve"
chmod +x "$HOME/.local/bin/muck-serve"
cp "$SCRIPT_DIR/muck-dynamic.min.css" "$HOME/.local/bin/muck-dynamic.min.css"
cp "$SCRIPT_DIR/muck-light.min.css" "$HOME/.local/bin/muck-light.min.css"
cp "$SCRIPT_DIR/muck-dark.min.css" "$HOME/.local/bin/muck-dark.min.css"

# Add to PATH if needed
if ! echo "$PATH" | grep -q "$HOME/.local/bin"; then
  SHELL_RC="$HOME/.zshrc"
  [ -f "$HOME/.bashrc" ] && [ ! -f "$HOME/.zshrc" ] && SHELL_RC="$HOME/.bashrc"
  echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$SHELL_RC"
  echo "Added ~/.local/bin to PATH in $(basename "$SHELL_RC"). Restart your terminal or run: source $SHELL_RC"
fi

echo "muck installed to ~/.local/bin"
