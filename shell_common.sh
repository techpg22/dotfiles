# Prevent multiple loads
[ -n "$DOTFILES_LOADED" ] && return
export DOTFILES_LOADED=1

DOTFILES_DIR="$HOME/dotfiles"

# -------------------------
# Shell auto-detection
# -------------------------
if [ -n "$BASH_VERSION" ]; then
  SHELL_TYPE="bash"
elif [ -n "$ZSH_VERSION" ]; then
  SHELL_TYPE="zsh"
else
  SHELL_TYPE="unknown"
fi

# Load shell-specific behavior
SHELL_FILE="$DOTFILES_DIR/shells/$SHELL_TYPE.sh"
[ -f "$SHELL_FILE" ] && . "$SHELL_FILE"

# -------------------------
# Role detection
# -------------------------
ROLE_FILE="$HOME/.dotfiles_role"

# Read roles file
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
