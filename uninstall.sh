#!/usr/bin/env bash
set -euo pipefail

rm -f "$HOME/.local/bin/muck"
rm -f "$HOME/.local/bin/muck-serve"
rm -rf "$HOME/.muck"

echo "muck uninstalled."
echo "Note: ~/.local/bin was left in your PATH. Remove it from your shell rc if you no longer need it."
