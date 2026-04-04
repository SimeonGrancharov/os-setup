#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/packages.sh"
source "$SCRIPT_DIR/log.sh"

log_header "Updating modules"

# Homebrew
log_section "Homebrew"
if command -v brew &>/dev/null; then
  log_info "Updating Homebrew..."
  brew update
  log_success "Homebrew updated"
else
  log_error "Homebrew not installed"
  exit 1
fi

# Brew formulae
log_section "Brew formulae"
for entry in "${PROGRAMS[@]}"; do
  parse_program "$entry"
  [[ "$PROG_TYPE" != "formula" ]] && continue

  if brew list "$PROG_NAME" &>/dev/null; then
    log_info "Upgrading $PROG_NAME..."
    brew upgrade "$PROG_NAME" 2>/dev/null || log_skip "$PROG_NAME already up-to-date"
  else
    log_skip "$PROG_NAME not installed"
  fi
done

# Brew casks
log_section "Brew casks"
for entry in "${PROGRAMS[@]}"; do
  parse_program "$entry"
  [[ "$PROG_TYPE" != "cask" ]] && continue

  if brew list --cask "$PROG_NAME" &>/dev/null; then
    log_info "Upgrading $PROG_NAME..."
    brew upgrade --cask "$PROG_NAME" 2>/dev/null || log_skip "$PROG_NAME already up-to-date"
  else
    log_skip "$PROG_NAME not installed"
  fi
done

# Oh My Zsh
log_section "Oh My Zsh"
if [ -d "$HOME/.oh-my-zsh" ]; then
  log_info "Pulling latest..."
  (cd "$HOME/.oh-my-zsh" && git pull --rebase --quiet)
  log_success "Updated Oh My Zsh"
else
  log_skip "Oh My Zsh not installed"
fi

# Spaceship prompt
log_section "Spaceship prompt"
SPACESHIP_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/spaceship-prompt"
if [ -d "$SPACESHIP_DIR" ]; then
  log_info "Pulling latest..."
  (cd "$SPACESHIP_DIR" && git pull --rebase --quiet)
  log_success "Updated Spaceship prompt"
else
  log_skip "Spaceship prompt not installed"
fi

# Zsh plugins
log_section "Zsh plugins"
ZSH_CUSTOM_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

if [ -d "$ZSH_CUSTOM_DIR/plugins/zsh-autosuggestions" ]; then
  log_info "Pulling zsh-autosuggestions..."
  (cd "$ZSH_CUSTOM_DIR/plugins/zsh-autosuggestions" && git pull --rebase --quiet)
  log_success "Updated zsh-autosuggestions"
else
  log_skip "zsh-autosuggestions not installed"
fi

if [ -d "$ZSH_CUSTOM_DIR/plugins/zsh-syntax-highlighting" ]; then
  log_info "Pulling zsh-syntax-highlighting..."
  (cd "$ZSH_CUSTOM_DIR/plugins/zsh-syntax-highlighting" && git pull --rebase --quiet)
  log_success "Updated zsh-syntax-highlighting"
else
  log_skip "zsh-syntax-highlighting not installed"
fi

# GitHub CLI extensions
log_section "GitHub CLI extensions"
if command -v gh &>/dev/null; then
  log_info "Upgrading extensions..."
  gh extension upgrade --all 2>/dev/null || log_skip "No extensions to update"
  log_success "Updated GitHub CLI extensions"
else
  log_skip "gh not installed"
fi

log_done "Update complete"
