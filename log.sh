#!/bin/bash

# Colors
_BOLD='\033[1m'
_DIM='\033[2m'
_RESET='\033[0m'
_GREEN='\033[0;32m'
_BLUE='\033[0;34m'
_YELLOW='\033[0;33m'
_RED='\033[0;31m'
_CYAN='\033[0;36m'
_MAGENTA='\033[0;35m'

log_header() {
  echo ""
  echo -e "${_BOLD}${_MAGENTA}  $1${_RESET}"
  echo -e "${_DIM}  ─────────────────────────────────────${_RESET}"
}

log_section() {
  echo ""
  echo -e "  ${_BOLD}${_CYAN}:: ${1}${_RESET}"
}

log_info() {
  echo -e "  ${_BLUE}>${_RESET} $1"
}

log_success() {
  echo -e "  ${_GREEN}✓${_RESET} $1"
}

log_skip() {
  echo -e "  ${_DIM}-${_RESET} ${_DIM}$1${_RESET}"
}

log_warn() {
  echo -e "  ${_YELLOW}!${_RESET} $1"
}

log_error() {
  echo -e "  ${_RED}✗${_RESET} $1"
}

log_done() {
  echo ""
  echo -e "  ${_GREEN}${_BOLD}Done!${_RESET} ${_DIM}$1${_RESET}"
  echo ""
}
