export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="spaceship"

export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# Vi mode
bindkey -v
# Aliases
alias l="eza -la --icons --git"
alias ls="eza"
alias tree="eza --tree"
alias v="nvim"

export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"
export PATH="/opt/homebrew/opt/python@3.11/libexec/bin:$PATH"

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME/bin:"*) ;;
  *) export PATH="$PNPM_HOME/bin:$PATH" ;;
esac
# pnpm end

# Machine-specific overrides
[ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"

# fzf shell integration: Ctrl-R fuzzy history, Ctrl-T file picker, Alt-C cd
# (must come after vi mode so its bindings win)
source <(fzf --zsh)

# Zoxide (keep last — it wants to be initialized at the end of the file)
eval "$(zoxide init zsh --cmd cd)"
