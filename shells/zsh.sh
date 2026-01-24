# Only run in zsh
[ -z "$ZSH_VERSION" ] && return

setopt autocd
setopt correct

# Zsh-only helpers
alias ll='ls -lah'
