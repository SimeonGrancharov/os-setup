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
FORMULAE=(neovim tmux fzf ripgrep node nvm btop bat)
CASKS=(ghostty font-hack-nerd-font)

echo "Installing brew formulae..."
brew install "${FORMULAE[@]}"

echo "Installing brew casks..."
brew install --cask "${CASKS[@]}"

# Oh My Zsh
if [ -d "$HOME/.oh-my-zsh" ]; then
  echo "Oh My Zsh already installed, skipping"
else
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  echo "Installed Oh My Zsh"
fi

# Spaceship prompt
SPACESHIP_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/spaceship-prompt"

if [ -d "$SPACESHIP_DIR" ]; then
  echo "Spaceship prompt already installed, skipping"
else
  git clone https://github.com/spaceship-prompt/spaceship-prompt.git "$SPACESHIP_DIR" --depth=1
  ln -s "$SPACESHIP_DIR/spaceship.zsh-theme" "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/spaceship.zsh-theme"
  echo "Installed Spaceship prompt"
fi

# Zsh config
if [ -e "$HOME/.zshrc" ]; then
  echo "~/.zshrc already exists, backing up to ~/.zshrc.bak"
  mv "$HOME/.zshrc" "$HOME/.zshrc.bak"
fi
ln -s "$SCRIPT_DIR/.zshrc" "$HOME/.zshrc"
echo "Symlinked zsh config"

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

# Btop config
BTOP_CONFIG_DIR="$HOME/.config/btop"

if [ -e "$BTOP_CONFIG_DIR/btop.conf" ]; then
  echo "~/.config/btop/btop.conf already exists, skipping symlink"
else
  mkdir -p "$BTOP_CONFIG_DIR"
  ln -s "$SCRIPT_DIR/btop.conf" "$BTOP_CONFIG_DIR/btop.conf"
  echo "Symlinked btop config"
fi

# Claude Code
if command -v claude &>/dev/null; then
  echo "Claude Code already installed, skipping"
else
  curl -fsSL https://claude.ai/install.sh | sh
  echo "Installed Claude Code"
fi

# GitHub CLI Auth & Extensions
if gh auth status &>/dev/null; then
  echo "gh already authenticated, skipping"
else
  gh auth login
fi

if gh extension list | grep -q "dlvhdr/gh-dash"; then
  echo "gh-dash already installed, skipping"
else
  gh extension install dlvhdr/gh-dash
  echo "Installed gh-dash"
fi

if gh extension list | grep -q "gh-enhance"; then
  echo "gh-enhance already installed, skipping"
else
  gh extension install gh-enhance
  echo "Installed gh-enhance"
fi

# Keystroke Count
if command -v keystroke-count &>/dev/null; then
  echo "keystroke-count already installed, skipping"
else
  pip install git+https://github.com/SimeonGrancharov/keystroke_count.git
  echo "Installed keystroke-count"
fi
