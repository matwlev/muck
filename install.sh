#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
MUCK_HOME="$HOME/.muck"
BIN="$HOME/.local/bin"

no_config=false
reset_config=false
for arg in "$@"; do
  case $arg in
    --no-config)    no_config=true ;;
    --reset-config) reset_config=true ;;
  esac
done

# Install binaries
mkdir -p "$BIN"
cp "$SCRIPT_DIR/muck"       "$BIN/muck";       chmod +x "$BIN/muck"
cp "$SCRIPT_DIR/muck-serve" "$BIN/muck-serve"; chmod +x "$BIN/muck-serve"

# Add to PATH if needed
if ! echo "$PATH" | grep -q "$BIN"; then
  SHELL_RC="$HOME/.zshrc"
  [ -f "$HOME/.bashrc" ] && [ ! -f "$HOME/.zshrc" ] && SHELL_RC="$HOME/.bashrc"
  echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$SHELL_RC"
  echo "Added ~/.local/bin to PATH in $(basename "$SHELL_RC"). Restart your terminal or run: source $SHELL_RC"
fi

# Set up ~/.muck/
if $no_config; then
  echo "muck installed to ~/.local/bin (skipped ~/.muck setup)"
  exit 0
fi

if [[ -d "$MUCK_HOME" ]] && ! $reset_config; then
  echo "muck installed to ~/.local/bin (~/.muck already exists, skipping)"
  exit 0
fi

mkdir -p "$MUCK_HOME/styles" "$MUCK_HOME/scripts"

# Copy CSS assets
cp "$SCRIPT_DIR/muck-colors.css"  "$MUCK_HOME/styles/"
cp "$SCRIPT_DIR/muck-light.css"   "$MUCK_HOME/styles/"
cp "$SCRIPT_DIR/muck-dark.css"    "$MUCK_HOME/styles/"
cp "$SCRIPT_DIR/muck-dynamic.css" "$MUCK_HOME/styles/"
cp "$SCRIPT_DIR/muck-nav.css"     "$MUCK_HOME/styles/"

# Copy JS assets
cp "$SCRIPT_DIR/muck-nav.js" "$MUCK_HOME/scripts/"

# Generate config
S="$MUCK_HOME/styles"
J="$MUCK_HOME/scripts"
cat > "$MUCK_HOME/config" <<EOF
--theme dynamic

[themes]
light       $S/muck-colors.css $S/muck-light.css
dark        $S/muck-colors.css $S/muck-dark.css
dynamic     $S/muck-colors.css $S/muck-dynamic.css
nav-light   $S/muck-colors.css $S/muck-light.css $S/muck-nav.css script-link:$J/muck-nav.js
nav-dark    $S/muck-colors.css $S/muck-dark.css $S/muck-nav.css script-link:$J/muck-nav.js
nav-dynamic $S/muck-colors.css $S/muck-dynamic.css $S/muck-nav.css script-link:$J/muck-nav.js
none
EOF

echo "muck installed to ~/.local/bin"
echo "Config and assets created in ~/.muck/"
