#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "⚠️  This will remove everything installed by setup.sh."
read -p "Are you sure? (y/N) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  echo "Aborted."
  exit 0
fi

# Remove symlinks (only if they point back to this repo)
remove_symlink() {
  local link="$1"
  if [ -L "$link" ] && [[ "$(readlink "$link")" == "$SCRIPT_DIR"* ]]; then
    rm "$link"
    echo "Removed symlink $link"
  else
    echo "$link is not a symlink to this repo, skipping"
  fi
}

echo ""
echo "=== Removing symlinks ==="
remove_symlink "$HOME/.zshrc"
remove_symlink "$HOME/.config/nvim"
remove_symlink "$HOME/.tmux.conf"
remove_symlink "$HOME/.config/ghostty/config"
remove_symlink "$HOME/.config/btop/btop.conf"
remove_symlink "$HOME/.config/gh-dash/config.yml"

# Restore .zshrc backup if it exists
if [ -f "$HOME/.zshrc.bak" ]; then
  mv "$HOME/.zshrc.bak" "$HOME/.zshrc"
  echo "Restored ~/.zshrc from backup"
fi

# Keystroke Count
echo ""
echo "=== Removing keystroke-count ==="
if command -v keystroke-count &>/dev/null; then
  pip uninstall -y keystroke-count
  echo "Removed keystroke-count"
else
  echo "keystroke-count not installed, skipping"
fi

# GitHub CLI Extensions
echo ""
echo "=== Removing GitHub CLI extensions ==="
if command -v gh &>/dev/null; then
  if gh extension list | grep -q "gh-enhance"; then
    gh extension remove gh-enhance
    echo "Removed gh-enhance"
  fi

  if gh extension list | grep -q "dlvhdr/gh-dash"; then
    gh extension remove dlvhdr/gh-dash
    echo "Removed gh-dash"
  fi

  gh auth logout
  echo "Logged out of GitHub CLI"
fi

# Claude Code
echo ""
echo "=== Removing Claude Code ==="
if command -v claude &>/dev/null; then
  rm -f "$(which claude)"
  echo "Removed Claude Code"
else
  echo "Claude Code not installed, skipping"
fi

# Delta git config
echo ""
echo "=== Removing delta git config ==="
if grep -q "delta-themes.gitconfig" "$HOME/.gitconfig" 2>/dev/null; then
  git config --global --unset include.path "$SCRIPT_DIR/delta-themes.gitconfig"
  git config --global --unset delta.features
  git config --global --unset delta.navigate
  git config --global --unset core.pager
  git config --global --unset interactive.diffFilter
  echo "Removed delta config from .gitconfig"
else
  echo "Delta config not found in .gitconfig, skipping"
fi

# Zsh plugins
echo ""
echo "=== Removing Zsh plugins ==="
ZSH_CUSTOM_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

if [ -d "$ZSH_CUSTOM_DIR/plugins/zsh-autosuggestions" ]; then
  rm -rf "$ZSH_CUSTOM_DIR/plugins/zsh-autosuggestions"
  echo "Removed zsh-autosuggestions"
fi

if [ -d "$ZSH_CUSTOM_DIR/plugins/zsh-syntax-highlighting" ]; then
  rm -rf "$ZSH_CUSTOM_DIR/plugins/zsh-syntax-highlighting"
  echo "Removed zsh-syntax-highlighting"
fi

# Spaceship prompt
echo ""
echo "=== Removing Spaceship prompt ==="
SPACESHIP_DIR="$ZSH_CUSTOM_DIR/themes/spaceship-prompt"
SPACESHIP_LINK="$ZSH_CUSTOM_DIR/themes/spaceship.zsh-theme"

if [ -L "$SPACESHIP_LINK" ]; then
  rm "$SPACESHIP_LINK"
  echo "Removed spaceship theme symlink"
fi

if [ -d "$SPACESHIP_DIR" ]; then
  rm -rf "$SPACESHIP_DIR"
  echo "Removed spaceship-prompt"
fi

# Oh My Zsh
echo ""
echo "=== Removing Oh My Zsh ==="
if [ -d "$HOME/.oh-my-zsh" ]; then
  rm -rf "$HOME/.oh-my-zsh"
  echo "Removed Oh My Zsh"
else
  echo "Oh My Zsh not installed, skipping"
fi

# Brew packages
echo ""
echo "=== Removing brew casks ==="
CASKS=(ghostty font-hack-nerd-font font-fira-code-nerd-font raycast arc)
if command -v brew &>/dev/null; then
  for cask in "${CASKS[@]}"; do
    if brew list --cask "$cask" &>/dev/null; then
      brew uninstall --cask "$cask"
      echo "Removed $cask"
    else
      echo "$cask not installed, skipping"
    fi
  done
else
  echo "Homebrew not installed, skipping cask removal"
fi

echo ""
echo "=== Removing brew formulae ==="
FORMULAE=(neovim tmux fzf ripgrep node nvm btop bat git-delta gh zoxide eza markmarkoh/lt/lt)
if command -v brew &>/dev/null; then
  for formula in "${FORMULAE[@]}"; do
    if brew list "$formula" &>/dev/null; then
      brew uninstall "$formula"
      echo "Removed $formula"
    else
      echo "$formula not installed, skipping"
    fi
  done
else
  echo "Homebrew not installed, skipping formulae removal"
fi

# Homebrew itself
echo ""
echo "=== Removing Homebrew ==="
if command -v brew &>/dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"
  echo "Removed Homebrew"
else
  echo "Homebrew not installed, skipping"
fi

echo ""
echo "Cleanup complete!"
