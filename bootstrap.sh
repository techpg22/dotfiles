#!/usr/bin/env bash
set -e

DOTFILES_DIR="$HOME/dotfiles"
ROLES_DIR="$DOTFILES_DIR/roles"
ROLE_FILE="$HOME/.dotfiles_roles"

PRIMARY_ROLES=("server" "workstation" "laptop")

echo "== Dotfiles Bootstrap =="

# -------------------------
# Ensure dotfiles directory
# -------------------------
if [ ! -d "$DOTFILES_DIR" ]; then
  echo "Cloning dotfiles repo..."
  git clone https://github.com/techpg22/dotfiles.git "$DOTFILES_DIR"
else
  echo "Dotfiles directory exists."
fi

# -------------------------
# Create safe symlinks
# -------------------------
link_if_missing() {
  local target="$1"
  local link="$2"

  if [ -e "$link" ] && [ ! -L "$link" ]; then
    echo "Skipping $link (exists and not a symlink)"
    return
  fi

  ln -sf "$target" "$link"
  echo "Linked $link → $target"
}

link_if_missing "$DOTFILES_DIR/shell_common.sh" "$HOME/.shell_common"
link_if_missing "$DOTFILES_DIR/shells/bash.sh" "$HOME/.bash_extras"
link_if_missing "$DOTFILES_DIR/shells/zsh.sh" "$HOME/.zsh_extras"

# -------------------------
# Select primary role
# -------------------------
echo
echo "Select primary role:"
for i in "${!PRIMARY_ROLES[@]}"; do
  printf "  %d) %s\n" $((i+1)) "${PRIMARY_ROLES[$i]}"
done

while true; do
  read -rp "Enter number: " PRIMARY_IDX
  if [[ "$PRIMARY_IDX" =~ ^[0-9]+$ ]] && (( PRIMARY_IDX >= 1 && PRIMARY_IDX <= ${#PRIMARY_ROLES[@]} )); then
    PRIMARY_ROLE="${PRIMARY_ROLES[$((PRIMARY_IDX-1))]}"
    break
  fi
  echo "Invalid selection. Try again."
done

# -------------------------
# Build optional roles list
# -------------------------
OPTIONAL_ROLES=()
for file in "$ROLES_DIR"/*.sh; do
  role="$(basename "$file" .sh)"

  # Skip primary roles
  if [[ " ${PRIMARY_ROLES[*]} " == *" $role "* ]]; then
    continue
  fi

  OPTIONAL_ROLES+=("$role")
done

SELECTED_OPTIONAL_ROLES=()

# -------------------------
# Select optional roles
# -------------------------
if [ "${#OPTIONAL_ROLES[@]}" -gt 0 ]; then
  echo
  echo "Optional roles:"
  for i in "${!OPTIONAL_ROLES[@]}"; do
    printf "  %d) %s\n" $((i+1)) "${OPTIONAL_ROLES[$i]}"
  done

  read -rp "Enter comma-separated numbers (or press Enter to skip): " OPT_INPUT

  if [ -n "$OPT_INPUT" ]; then
    IFS=',' read -ra INDICES <<< "$OPT_INPUT"

    for idx in "${INDICES[@]}"; do
      idx="$(echo "$idx" | xargs)" # trim
      if [[ "$idx" =~ ^[0-9]+$ ]] && (( idx >= 1 && idx <= ${#OPTIONAL_ROLES[@]} )); then
        SELECTED_OPTIONAL_ROLES+=("${OPTIONAL_ROLES[$((idx-1))]}")
      else
        echo "Invalid optional role index: $idx"
        exit 1
      fi
    done
  fi
fi

# -------------------------
# Write role file
# -------------------------
ALL_ROLES=("$PRIMARY_ROLE" "${SELECTED_OPTIONAL_ROLES[@]}")

ROLE_STRING=$(IFS=','; echo "${ALL_ROLES[*]// /}")
echo "$ROLE_STRING" > "$ROLE_FILE"

echo
echo "Roles saved to $ROLE_FILE:"
cat "$ROLE_FILE"

# -------------------------
# Run role install scripts
# -------------------------
echo
for role in "${ALL_ROLES[@]}"; do
  INSTALL_SCRIPT="$ROLES_DIR/$role.install.sh"
  if [ -f "$INSTALL_SCRIPT" ]; then
    echo "Running install for role: $role"
    bash "$INSTALL_SCRIPT"
  fi
done

# -------------------------
# Editor defaults
# -------------------------
read -rp "Set default editor to vim? (y/n): " SET_EDITOR
if [[ "$SET_EDITOR" =~ ^[Yy]$ ]]; then
  if ! grep -q "EDITOR=" "$HOME/.profile" 2>/dev/null; then
    echo 'export EDITOR=vim' >> "$HOME/.profile"
    echo 'export VISUAL=vim' >> "$HOME/.profile"
  fi
fi

echo
echo "Bootstrap complete."
echo "Restart your shell or run: exec \$SHELL"
