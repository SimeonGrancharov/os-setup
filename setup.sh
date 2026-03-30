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
FORMULAE=(neovim tmux fzf ripgrep node nvm btop bat git-delta gh zoxide eza markmarkoh/lt/lt)
CASKS=(ghostty font-hack-nerd-font font-fira-code-nerd-font raycast arc)

echo "Installing brew formulae..."
for formula in "${FORMULAE[@]}"; do
  if brew list "$formula" &>/dev/null; then
    echo "$formula already installed, skipping"
  else
    brew install "$formula"
  fi
done

echo "Installing brew casks..."
for cask in "${CASKS[@]}"; do
  if brew list --cask "$cask" &>/dev/null; then
    echo "$cask already installed, skipping"
  else
    brew install --cask "$cask"
  fi
done

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

# Zsh plugins
ZSH_CUSTOM_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

if [ -d "$ZSH_CUSTOM_DIR/plugins/zsh-autosuggestions" ]; then
  echo "zsh-autosuggestions already installed, skipping"
else
  git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM_DIR/plugins/zsh-autosuggestions"
  echo "Installed zsh-autosuggestions"
fi

if [ -d "$ZSH_CUSTOM_DIR/plugins/zsh-syntax-highlighting" ]; then
  echo "zsh-syntax-highlighting already installed, skipping"
else
  git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM_DIR/plugins/zsh-syntax-highlighting"
  echo "Installed zsh-syntax-highlighting"
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

# Delta theme
if grep -q "delta-themes.gitconfig" "$HOME/.gitconfig" 2>/dev/null; then
  echo "Delta theme already included in .gitconfig, skipping"
else
  git config --global include.path "$SCRIPT_DIR/delta-themes.gitconfig"
  git config --global delta.features "rose-pine"
  git config --global delta.navigate true
  git config --global core.pager "delta"
  git config --global interactive.diffFilter "delta --color-only"
  echo "Configured delta with rose-pine theme"
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

# gh-dash config
GH_DASH_CONFIG_DIR="$HOME/.config/gh-dash"

if [ -e "$GH_DASH_CONFIG_DIR/config.yml" ]; then
  echo "~/.config/gh-dash/config.yml already exists, skipping symlink"
else
  mkdir -p "$GH_DASH_CONFIG_DIR"
  ln -s "$SCRIPT_DIR/gh-dash-config.yml" "$GH_DASH_CONFIG_DIR/config.yml"
  echo "Symlinked gh-dash config"
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
