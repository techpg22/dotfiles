# Only run in bash
[ -z "$BASH_VERSION" ] && return

shopt -s histappend
shopt -s checkwinsize

# Bash-only aliases or helpers
alias ll='ls -lah'
