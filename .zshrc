export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="spaceship"

export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

plugins=(git)

source $ZSH/oh-my-zsh.sh

# Vi mode
bindkey -v
bindkey '^R' history-incremental-search-backward
# Aliases
alias l="ls -al"
alias v="nvim"

export PATH="$HOME/.local/bin:$PATH"

# Machine-specific overrides
[ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"
