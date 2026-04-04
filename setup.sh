#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/packages.sh"
source "$SCRIPT_DIR/log.sh"

log_header "Setting up your machine"

# Homebrew
log_section "Homebrew"
if command -v brew &>/dev/null; then
  log_skip "Homebrew already installed"
else
  log_info "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  log_success "Installed Homebrew"
fi

# Brew formulae
log_section "Brew formulae"
for entry in "${PROGRAMS[@]}"; do
  parse_program "$entry"
  [[ "$PROG_TYPE" != "formula" ]] && continue

  if brew list "$PROG_NAME" &>/dev/null; then
    log_skip "$PROG_NAME already installed"
  else
    log_info "Installing $PROG_NAME..."
    brew install "$PROG_NAME"
    log_success "Installed $PROG_NAME"
  fi
done

# tree-sitter-cli (required by nvim-treesitter)
log_section "tree-sitter-cli"
if command -v tree-sitter &>/dev/null; then
  log_skip "tree-sitter-cli already installed"
else
  log_info "Installing tree-sitter-cli..."
  cargo install --locked tree-sitter-cli
  log_success "Installed tree-sitter-cli"
fi

# Brew casks
log_section "Brew casks"
for entry in "${PROGRAMS[@]}"; do
  parse_program "$entry"
  [[ "$PROG_TYPE" != "cask" ]] && continue

  if brew list --cask "$PROG_NAME" &>/dev/null; then
    log_skip "$PROG_NAME already installed"
  else
    log_info "Installing $PROG_NAME..."
    brew install --cask "$PROG_NAME"
    log_success "Installed $PROG_NAME"
  fi
done

# Oh My Zsh
log_section "Oh My Zsh"
if [ -d "$HOME/.oh-my-zsh" ]; then
  log_skip "Oh My Zsh already installed"
else
  log_info "Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  log_success "Installed Oh My Zsh"
fi

# Spaceship prompt
log_section "Spaceship prompt"
SPACESHIP_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/spaceship-prompt"

if [ -d "$SPACESHIP_DIR" ]; then
  log_skip "Spaceship prompt already installed"
else
  log_info "Installing Spaceship prompt..."
  git clone https://github.com/spaceship-prompt/spaceship-prompt.git "$SPACESHIP_DIR" --depth=1
  ln -s "$SPACESHIP_DIR/spaceship.zsh-theme" "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/spaceship.zsh-theme"
  log_success "Installed Spaceship prompt"
fi

# Zsh plugins
log_section "Zsh plugins"
ZSH_CUSTOM_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

if [ -d "$ZSH_CUSTOM_DIR/plugins/zsh-autosuggestions" ]; then
  log_skip "zsh-autosuggestions already installed"
else
  log_info "Installing zsh-autosuggestions..."
  git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM_DIR/plugins/zsh-autosuggestions"
  log_success "Installed zsh-autosuggestions"
fi

if [ -d "$ZSH_CUSTOM_DIR/plugins/zsh-syntax-highlighting" ]; then
  log_skip "zsh-syntax-highlighting already installed"
else
  log_info "Installing zsh-syntax-highlighting..."
  git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM_DIR/plugins/zsh-syntax-highlighting"
  log_success "Installed zsh-syntax-highlighting"
fi

# Config symlinks
log_section "Config symlinks"

if [ -e "$HOME/.zshrc" ]; then
  log_warn "~/.zshrc exists, backing up to ~/.zshrc.bak"
  mv "$HOME/.zshrc" "$HOME/.zshrc.bak"
fi

BAT_SYNTAX_LINKED=false
for entry in "${PROGRAMS[@]}"; do
  parse_program "$entry"
  for config in "${PROG_CONFIGS[@]}"; do
    [[ -z "$config" ]] && continue
    parse_config "$config"

    if [ -e "$CONFIG_TARGET" ]; then
      log_skip "$CONFIG_TARGET already exists"
      continue
    fi

    mkdir -p "$(dirname "$CONFIG_TARGET")"
    ln -s "$SCRIPT_DIR/$CONFIG_SOURCE" "$CONFIG_TARGET"
    log_success "Symlinked $CONFIG_SOURCE -> $CONFIG_TARGET"

    if [[ "$CONFIG_TARGET" == *"bat/syntaxes"* ]]; then
      BAT_SYNTAX_LINKED=true
    fi
  done
done

if $BAT_SYNTAX_LINKED; then
  bat cache --build
fi

# Delta theme
log_section "Delta theme"
if grep -q "delta-themes.gitconfig" "$HOME/.gitconfig" 2>/dev/null; then
  log_skip "Delta theme already configured"
else
  log_info "Configuring delta with rose-pine theme..."
  git config --global include.path "$SCRIPT_DIR/delta-themes.gitconfig"
  git config --global delta.features "rose-pine"
  git config --global delta.navigate true
  git config --global core.pager "delta"
  git config --global interactive.diffFilter "delta --color-only"
  log_success "Configured delta with rose-pine theme"
fi

# Claude Code
log_section "Claude Code"
if command -v claude &>/dev/null; then
  log_skip "Claude Code already installed"
else
  log_info "Installing Claude Code..."
  curl -fsSL https://claude.ai/install.sh | sh
  log_success "Installed Claude Code"
fi

# GitHub CLI Auth & Extensions
log_section "GitHub CLI"
if gh auth status &>/dev/null; then
  log_skip "gh already authenticated"
else
  log_info "Authenticating with GitHub CLI..."
  gh auth login
fi

if gh extension list | grep -q "dlvhdr/gh-dash"; then
  log_skip "gh-dash already installed"
else
  log_info "Installing gh-dash..."
  gh extension install dlvhdr/gh-dash
  log_success "Installed gh-dash"
fi

if gh extension list | grep -q "gh-enhance"; then
  log_skip "gh-enhance already installed"
else
  log_info "Installing gh-enhance..."
  gh extension install gh-enhance
  log_success "Installed gh-enhance"
fi

# Keystroke Count
log_section "Keystroke Count"
if command -v keystroke-count &>/dev/null; then
  log_skip "keystroke-count already installed"
else
  log_info "Installing keystroke-count..."
  pip install git+https://github.com/SimeonGrancharov/keystroke_count.git
  log_success "Installed keystroke-count"
fi

log_done "Setup complete"
