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

mkdir -p "$MUCK_HOME/themes"

# Build theme folders by concatenating CSS sources
make_theme() {
  local name="$1"; shift
  mkdir -p "$MUCK_HOME/themes/$name"
  cat "$@" > "$MUCK_HOME/themes/$name/style.css"
}

make_theme light       "$SCRIPT_DIR/muck-colors.css" "$SCRIPT_DIR/muck-light.css"   "$SCRIPT_DIR/muck-base.css"
make_theme dark        "$SCRIPT_DIR/muck-colors.css" "$SCRIPT_DIR/muck-dark.css"    "$SCRIPT_DIR/muck-base.css"
make_theme dynamic     "$SCRIPT_DIR/muck-colors.css" "$SCRIPT_DIR/muck-dynamic.css" "$SCRIPT_DIR/muck-base.css"
make_theme nav-light   "$SCRIPT_DIR/muck-colors.css" "$SCRIPT_DIR/muck-light.css"   "$SCRIPT_DIR/muck-base.css" "$SCRIPT_DIR/muck-nav.css"
make_theme nav-dark    "$SCRIPT_DIR/muck-colors.css" "$SCRIPT_DIR/muck-dark.css"    "$SCRIPT_DIR/muck-base.css" "$SCRIPT_DIR/muck-nav.css"
make_theme nav-dynamic "$SCRIPT_DIR/muck-colors.css" "$SCRIPT_DIR/muck-dynamic.css" "$SCRIPT_DIR/muck-base.css" "$SCRIPT_DIR/muck-nav.css"

# nav themes also need the JS
cp "$SCRIPT_DIR/muck-nav.js" "$MUCK_HOME/themes/nav-light/script.js"
cp "$SCRIPT_DIR/muck-nav.js" "$MUCK_HOME/themes/nav-dark/script.js"
cp "$SCRIPT_DIR/muck-nav.js" "$MUCK_HOME/themes/nav-dynamic/script.js"

# Generate config (no [themes] section needed — themes/ dir is auto-discovered)
cat > "$MUCK_HOME/config" <<EOF
--theme dynamic
EOF

echo "muck installed to ~/.local/bin"
echo "Config and assets created in ~/.muck/"
