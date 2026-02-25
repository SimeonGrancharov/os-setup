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

# Tmux config
if [ -e "$HOME/.tmux.conf" ]; then
  echo "~/.tmux.conf already exists, skipping symlink"
else
  ln -s "$SCRIPT_DIR/.tmux.conf" "$HOME/.tmux.conf"
  echo "Symlinked tmux config"
fi

# Ghostty config
GHOSTTY_CONFIG_DIR="$HOME/.config/ghostty"

if [ -e "$GHOSTTY_CONFIG_DIR/config" ]; then
  echo "~/.config/ghostty/config already exists, skipping symlink"
else
  mkdir -p "$GHOSTTY_CONFIG_DIR"
  ln -s "$SCRIPT_DIR/ghostty-config" "$GHOSTTY_CONFIG_DIR/config"
  echo "Symlinked ghostty config"
fi
