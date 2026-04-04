#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/log.sh"

show_menu() {
  echo ""
  echo -e "${_BOLD}${_MAGENTA}"
  echo "   ┌───────────────────────────┐"
  echo "   │     OS Setup Manager      │"
  echo "   └───────────────────────────┘"
  echo -e "${_RESET}"
  echo -e "  ${_CYAN}1)${_RESET} Setup everything"
  echo -e "  ${_CYAN}2)${_RESET} Update existing modules"
  echo -e "  ${_CYAN}3)${_RESET} Cleanup everything"
  echo -e "  ${_DIM}q) Quit${_RESET}"
  echo ""
}

show_menu
read -p "  Choose an option: " -n 1 choice
echo ""

case "$choice" in
  1)
    bash "$SCRIPT_DIR/setup.sh"
    ;;
  2)
    bash "$SCRIPT_DIR/update.sh"
    ;;
  3)
    bash "$SCRIPT_DIR/cleanup.sh"
    ;;
  q|Q)
    ;;
  *)
    log_warn "Invalid option."
    exit 1
    ;;
esac
