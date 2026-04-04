#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/packages.sh"

# Homebrew
if command -v brew &>/dev/null; then
  echo "Homebrew already installed, skipping"
else
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo "Installed Homebrew"
fi

# Brew formulae
echo "Installing brew formulae..."
for entry in "${PROGRAMS[@]}"; do
  parse_program "$entry"
  [[ "$PROG_TYPE" != "formula" ]] && continue

  if brew list "$PROG_NAME" &>/dev/null; then
    echo "$PROG_NAME already installed, skipping"
  else
    brew install "$PROG_NAME"
  fi
done

# tree-sitter-cli (required by nvim-treesitter)
if command -v tree-sitter &>/dev/null; then
  echo "tree-sitter-cli already installed, skipping"
else
  cargo install --locked tree-sitter-cli
  echo "Installed tree-sitter-cli"
fi

# Brew casks
echo "Installing brew casks..."
for entry in "${PROGRAMS[@]}"; do
  parse_program "$entry"
  [[ "$PROG_TYPE" != "cask" ]] && continue

  if brew list --cask "$PROG_NAME" &>/dev/null; then
    echo "$PROG_NAME already installed, skipping"
  else
    brew install --cask "$PROG_NAME"
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

# Config symlinks
echo "Creating config symlinks..."

# Backup .zshrc if it exists (will be replaced by symlink)
if [ -e "$HOME/.zshrc" ]; then
  echo "~/.zshrc already exists, backing up to ~/.zshrc.bak"
  mv "$HOME/.zshrc" "$HOME/.zshrc.bak"
fi

BAT_SYNTAX_LINKED=false
for entry in "${PROGRAMS[@]}"; do
  parse_program "$entry"
  for config in "${PROG_CONFIGS[@]}"; do
    [[ -z "$config" ]] && continue
    parse_config "$config"

    if [ -e "$CONFIG_TARGET" ]; then
      echo "$CONFIG_TARGET already exists, skipping"
      continue
    fi

    mkdir -p "$(dirname "$CONFIG_TARGET")"
    ln -s "$SCRIPT_DIR/$CONFIG_SOURCE" "$CONFIG_TARGET"
    echo "Symlinked $CONFIG_SOURCE -> $CONFIG_TARGET"

    if [[ "$CONFIG_TARGET" == *"bat/syntaxes"* ]]; then
      BAT_SYNTAX_LINKED=true
    fi
  done
done

if $BAT_SYNTAX_LINKED; then
  bat cache --build
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
