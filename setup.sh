#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Neovim config
NVIM_CONFIG_DIR="$HOME/.config/nvim"

if [ -e "$NVIM_CONFIG_DIR" ]; then
  echo "~/.config/nvim already exists, skipping symlink"
else
  mkdir -p "$HOME/.config"
  ln -s "$SCRIPT_DIR/nvimconfig" "$NVIM_CONFIG_DIR"
  echo "Symlinked nvim config"
fi
