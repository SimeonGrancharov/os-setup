#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/packages.sh"
source "$SCRIPT_DIR/log.sh"

log_header "Cleanup"
log_warn "This will remove everything installed by setup.sh."
echo ""
read -p "  Are you sure? (y/N) " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  log_info "Aborted."
  exit 0
fi

# Remove symlinks (only if they point back to this repo)
remove_symlink() {
  local link="$1"
  if [ -L "$link" ] && [[ "$(readlink "$link")" == "$SCRIPT_DIR"* ]]; then
    rm "$link"
    log_success "Removed symlink $link"
  else
    log_skip "$link is not a symlink to this repo"
  fi
}

log_section "Removing symlinks"
for entry in "${PROGRAMS[@]}"; do
  parse_program "$entry"
  for config in "${PROG_CONFIGS[@]}"; do
    [[ -z "$config" ]] && continue
    parse_config "$config"
    remove_symlink "$CONFIG_TARGET"
  done
done

# Restore .zshrc backup if it exists
if [ -f "$HOME/.zshrc.bak" ]; then
  mv "$HOME/.zshrc.bak" "$HOME/.zshrc"
  log_success "Restored ~/.zshrc from backup"
fi

# Keystroke Count
log_section "Removing keystroke-count"
if command -v keystroke-count &>/dev/null; then
  pip uninstall -y keystroke-count
  log_success "Removed keystroke-count"
else
  log_skip "keystroke-count not installed"
fi

# GitHub CLI Extensions
log_section "Removing GitHub CLI extensions"
if command -v gh &>/dev/null; then
  if gh extension list | grep -q "gh-enhance"; then
    gh extension remove gh-enhance
    log_success "Removed gh-enhance"
  fi

  if gh extension list | grep -q "dlvhdr/gh-dash"; then
    gh extension remove dlvhdr/gh-dash
    log_success "Removed gh-dash"
  fi

  gh auth logout
  log_success "Logged out of GitHub CLI"
fi

# Claude Code
log_section "Removing Claude Code"
if command -v claude &>/dev/null; then
  rm -f "$(which claude)"
  log_success "Removed Claude Code"
else
  log_skip "Claude Code not installed"
fi

# Delta git config
log_section "Removing delta config"
if grep -q "delta-themes.gitconfig" "$HOME/.gitconfig" 2>/dev/null; then
  git config --global --unset include.path "$SCRIPT_DIR/delta-themes.gitconfig"
  git config --global --unset delta.features
  git config --global --unset delta.navigate
  git config --global --unset core.pager
  git config --global --unset interactive.diffFilter
  log_success "Removed delta config from .gitconfig"
else
  log_skip "Delta config not found in .gitconfig"
fi

# Zsh plugins
log_section "Removing Zsh plugins"
ZSH_CUSTOM_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

if [ -d "$ZSH_CUSTOM_DIR/plugins/zsh-autosuggestions" ]; then
  rm -rf "$ZSH_CUSTOM_DIR/plugins/zsh-autosuggestions"
  log_success "Removed zsh-autosuggestions"
fi

if [ -d "$ZSH_CUSTOM_DIR/plugins/zsh-syntax-highlighting" ]; then
  rm -rf "$ZSH_CUSTOM_DIR/plugins/zsh-syntax-highlighting"
  log_success "Removed zsh-syntax-highlighting"
fi

# Spaceship prompt
log_section "Removing Spaceship prompt"
SPACESHIP_DIR="$ZSH_CUSTOM_DIR/themes/spaceship-prompt"
SPACESHIP_LINK="$ZSH_CUSTOM_DIR/themes/spaceship.zsh-theme"

if [ -L "$SPACESHIP_LINK" ]; then
  rm "$SPACESHIP_LINK"
  log_success "Removed spaceship theme symlink"
fi

if [ -d "$SPACESHIP_DIR" ]; then
  rm -rf "$SPACESHIP_DIR"
  log_success "Removed spaceship-prompt"
fi

# Oh My Zsh
log_section "Removing Oh My Zsh"
if [ -d "$HOME/.oh-my-zsh" ]; then
  rm -rf "$HOME/.oh-my-zsh"
  log_success "Removed Oh My Zsh"
else
  log_skip "Oh My Zsh not installed"
fi

# Brew casks
log_section "Removing brew casks"
if command -v brew &>/dev/null; then
  for entry in "${PROGRAMS[@]}"; do
    parse_program "$entry"
    [[ "$PROG_TYPE" != "cask" ]] && continue

    if brew list --cask "$PROG_NAME" &>/dev/null; then
      brew uninstall --cask "$PROG_NAME"
      log_success "Removed $PROG_NAME"
    else
      log_skip "$PROG_NAME not installed"
    fi
  done
else
  log_skip "Homebrew not installed"
fi

# Brew formulae
log_section "Removing brew formulae"
if command -v brew &>/dev/null; then
  for entry in "${PROGRAMS[@]}"; do
    parse_program "$entry"
    [[ "$PROG_TYPE" != "formula" ]] && continue

    if brew list "$PROG_NAME" &>/dev/null; then
      brew uninstall "$PROG_NAME"
      log_success "Removed $PROG_NAME"
    else
      log_skip "$PROG_NAME not installed"
    fi
  done
else
  log_skip "Homebrew not installed"
fi

# Homebrew itself
log_section "Removing Homebrew"
if command -v brew &>/dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"
  log_success "Removed Homebrew"
else
  log_skip "Homebrew not installed"
fi

log_done "Cleanup complete"
