#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Homebrew
if command -v brew &>/dev/null; then
  echo "Homebrew already installed, skipping"
else
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo "Installed Homebrew"
fi

# Brew packages
FORMULAE=(neovim tmux fzf ripgrep node nvm)
CASKS=(ghostty font-hack-nerd-font)

echo "Installing brew formulae..."
brew install "${FORMULAE[@]}"

echo "Installing brew casks..."
brew install --cask "${CASKS[@]}"

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
