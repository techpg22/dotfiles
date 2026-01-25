# Prevent multiple loads
[ -n "$DOTFILES_LOADED" ] && return
export DOTFILES_LOADED=1

export DOTFILES_DIR="$HOME/dotfiles"

# -------------------------
# Shell auto-detection
# -------------------------
if [ -n "$BASH_VERSION" ]; then
  export DOTFILES_SHELL="bash"
elif [ -n "$ZSH_VERSION" ]; then
  export DOTFILES_SHELL="zsh"
else
  export DOTFILES_SHELL="unknown"
fi

# Load shell-specific behavior
SHELL_FILE="$DOTFILES_DIR/shells/$DOTFILES_SHELL.sh"
[ -f "$SHELL_FILE" ] && . "$SHELL_FILE"

# -------------------------
# Role detection
# -------------------------
if [ -f "$HOME/.dotfiles_roles" ]; then
  IFS=',' read -ra ROLE_LIST < "$HOME/.dotfiles_roles"
  for ROLE in "${ROLE_LIST[@]}"; do
    ROLE_SCRIPT="$DOTFILES_DIR/roles/$ROLE.sh"
    [ -f "$ROLE_SCRIPT" ] && . "$ROLE_SCRIPT"
  done
fi

# -------------------------
# Host-specific overrides
# -------------------------
HOST_SCRIPT="$DOTFILES_DIR/hosts/$(hostname -s).sh"
[ -f "$HOST_SCRIPT" ] && . "$HOST_SCRIPT"

#--------------------------
# Helper functions
#--------------------------
reload_dotfiles() {
  unset DOTFILES_LOADED
  source ~/.shell_common
}
