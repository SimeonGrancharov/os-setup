#!/bin/bash

# Each entry: "type|name[|config_source:config_target|...]"
# Types: formula (brew), cask (brew --cask), config (no install, symlinks only)
PROGRAMS=(
  "formula|neovim|nvimconfig:$HOME/.config/nvim"
  "formula|tmux|.tmux.conf:$HOME/.tmux.conf"
  "formula|fzf"
  "formula|ripgrep"
  "formula|node"
  "formula|nvm"
  "formula|btop|btop.conf:$HOME/.config/btop/btop.conf"
  "formula|bat|bat-config:$HOME/.config/bat/config|bat-log.sublime-syntax:$HOME/.config/bat/syntaxes/log.sublime-syntax"
  "formula|git-delta"
  "formula|gh"
  "formula|zoxide"
  "formula|eza"
  "formula|rust"
  "formula|thefuck"
  "cask|ghostty|ghostty-config:$HOME/.config/ghostty/config"
  "cask|font-hack-nerd-font"
  "cask|font-fira-code-nerd-font"
  "cask|raycast"
  "cask|arc"
  "config|zsh|.zshrc:$HOME/.zshrc"
  "config|gh-dash|gh-dash-config.yml:$HOME/.config/gh-dash/config.yml"
)

parse_program() {
  IFS='|' read -ra _fields <<< "$1"
  PROG_TYPE="${_fields[0]}"
  PROG_NAME="${_fields[1]}"
  PROG_CONFIGS=("${_fields[@]:2}")
}

parse_config() {
  CONFIG_SOURCE="${1%%:*}"
  CONFIG_TARGET="${1#*:}"
}
