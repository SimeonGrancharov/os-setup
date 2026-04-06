# os-setup

macOS development environment setup with automated installation and symlinked dotfiles.

## What's included

### Terminal & Shell

- **Ghostty** terminal with Rose Pine Moon theme, transparency, and auto-launch into tmux
- **Zsh** with Oh My Zsh, Spaceship prompt, Vi mode, autosuggestions, and syntax highlighting
- **Tmux** with `Ctrl-A` prefix, vim-style navigation, seamless Neovim pane switching, and Rose Pine status bar
- **Machine-specific overrides** via `~/.zshrc.local` (see `.zshrc.local.example`)

### Editor

- **Neovim** config (git submodule) with LSP, Treesitter, fzf, gitsigns, Claude Code integration, and more

### CLI Tools

| Tool | Purpose |
|------|---------|
| fzf | Fuzzy finder |
| ripgrep | Fast search |
| eza | Modern `ls` with icons and git status |
| zoxide | Smart `cd` |
| bat | `cat` with syntax highlighting |
| git-delta | Better git diffs (Rose Pine theme) |
| btop | System monitor (vim keys) |
| gh | GitHub CLI |
| gh-dash | GitHub dashboard with custom keybindings |
| gh-enhance | GitHub CLI enhancement |
| node | Node.js runtime |
| nvm | Node version manager |
| rust | Rust toolchain |
| tree-sitter-cli | Tree-sitter parser (for Neovim) |
| thefuck | Command correction |
| claude | Claude Code AI assistant |
| keystroke-count | Keystroke tracking |

### Apps (Homebrew Casks)

Ghostty, Raycast, Arc, Hack Nerd Font, Fira Code Nerd Font

## Prerequisites

- macOS
- Xcode Command Line Tools (`xcode-select --install`)

## Usage

### Install everything

```sh
git clone --recurse-submodules git@github.com:SimeonGrancharov/os-setup.git
cd os-setup
./setup.sh
```

### Remove everything

```sh
./cleanup.sh
```

## Shell Aliases

| Alias | Command |
|-------|---------|
| `l` | `eza -la --icons --git` |
| `ls` | `eza` |
| `tree` | `eza --tree` |
| `v` | `nvim` |
| `cd` | `zoxide` (smart directory jumping) |
| `fuck` | `thefuck` (correct previous command) |

## Key Tmux Bindings

| Key | Action |
|-----|--------|
| `Ctrl-A` | Prefix |
| `\|` | Split vertical |
| `-` | Split horizontal |
| `Ctrl-h/j/k/l` | Navigate panes (works across Neovim, no prefix) |
| `prefix + H/J/K/L` | Resize panes |
| `prefix + b t` | Btop popup |

## Theme

Rose Pine Moon across all tools — Ghostty, tmux, Neovim, delta, and btop (Gruvbox).
