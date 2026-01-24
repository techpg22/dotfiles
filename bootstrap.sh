#!/usr/bin/env bash
# bootstrap.sh – sets up dotfiles for a fresh machine
set -e

# --- Configuration ---
DOTFILES_DIR="$HOME/dotfiles"
REPO_URL="git@github.com:techpg22/dotfiles.git"

SHELL_COMMON="$HOME/.shell_common"
BASH_EXTRAS="$HOME/.bash_extras"
ZSH_EXTRAS="$HOME/.zsh_extras"
ROLES_FILE="$HOME/.dotfiles_roles"

PRIMARY_ROLES=("server" "laptop")

# --- Clone or update repository ---
if [ ! -d "$DOTFILES_DIR/.git" ]; then
    echo "Cloning dotfiles into $DOTFILES_DIR..."
    git clone "$REPO_URL" "$DOTFILES_DIR"
else
    echo "Dotfiles repo exists, pulling latest..."
    git -C "$DOTFILES_DIR" pull
fi

# --- Create safe symlinks ---
ln -sf "$DOTFILES_DIR/shell_common.sh" "$SHELL_COMMON"
ln -sf "$DOTFILES_DIR/shells/bash.sh" "$BASH_EXTRAS"
ln -sf "$DOTFILES_DIR/shells/zsh.sh" "$ZSH_EXTRAS"
echo "Symlinks created/updated."

# --- Set default editor if not set ---
if [ -z "$EDITOR" ]; then
    export EDITOR=vim
    echo "Setting default EDITOR to vim"
fi
if [ -z "$VISUAL" ]; then
    export VISUAL="$EDITOR"
    echo "Setting default VISUAL to $EDITOR"
fi

# --- Helper function for selecting a single role by number ---
select_primary_role() {
    while true; do
        echo "Primary machine type roles:"
        for i in "${!PRIMARY_ROLES[@]}"; do
            printf "%d) %s\n" $((i+1)) "${PRIMARY_ROLES[$i]}"
        done
        read -rp "Enter number for primary role [default 1]: " choice
        choice=${choice:-1}
        if [[ "$choice" =~ ^[0-9]+$ ]] && (( choice >= 1 && choice <= ${#PRIMARY_ROLES[@]} )); then
            PRIMARY_ROLE="${PRIMARY_ROLES[$((choice-1))]}"
            echo "Selected primary role: $PRIMARY_ROLE"
            break
        else
            echo "Invalid selection. Try again."
        fi
    done
}

# --- Helper function for selecting multiple optional roles by number ---
select_optional_roles() {
    # Build optional roles list
    ALL_ROLES=($(ls "$DOTFILES_DIR/roles"))
    OPTIONAL_ROLES=()
    for r in "${ALL_ROLES[@]}"; do
        skip=false
        for pr in "${PRIMARY_ROLES[@]}"; do
            [ "$r" == "$pr" ] && skip=true
        done
        [ "$skip" = false ] && OPTIONAL_ROLES+=("$r")
    done

    FEATURE_ROLES=""
    if [ "${#OPTIONAL_ROLES[@]}" -eq 0 ]; then
        return
    fi

    while true; do
        echo "Available optional roles (comma-separated numbers to select multiple):"
        for i in "${!OPTIONAL_ROLES[@]}"; do
            printf "%d) %s\n" $((i+1)) "${OPTIONAL_ROLES[$i]}"
        done
        read -rp "Enter numbers for optional roles, or leave blank: " choices
        # allow empty input
        [ -z "$choices" ] && break

        # Split input by comma and validate
        valid=true
        IFS=',' read -ra indexes <<< "$choices"
        SELECTED_ROLES=()
        for idx in "${indexes[@]}"; do
            if [[ "$idx" =~ ^[0-9]+$ ]] && (( idx >= 1 && idx <= ${#OPTIONAL_ROLES[@]} )); then
                SELECTED_ROLES+=("${OPTIONAL_ROLES[$((idx-1))]}")
            else
                valid=false
                break
            fi
        done

        if [ "$valid" = true ]; then
            FEATURE_ROLES=$(IFS=, ; echo "${SELECTED_ROLES[*]}")
            echo "Selected optional roles: $FEATURE_ROLES"
            break
        else
            echo "Invalid input. Please enter valid numbers separated by commas."
        fi
    done
}

# --- Prompt for roles ---
select_primary_role
select_optional_roles

# --- Compose final roles list ---
if [ -n "$FEATURE_ROLES" ]; then
    ROLES="$PRIMARY_ROLE,$FEATURE_ROLES"
else
    ROLES="$PRIMARY_ROLE"
fi

# Write roles file
echo "$ROLES" > "$ROLES_FILE"
echo "Roles set: $ROLES"

# --- Check shell config lines ---
echo
echo "Ensure your shell sources the enhancements:"
echo "Bash: [ -f ~/.shell_common ] && . ~/.shell_common"
echo "      [ -f ~/.bash_extras ] && . ~/.bash_extras"
echo "Zsh:  [ -f ~/.shell_common ] && source ~/.shell_common"
echo "      [ -f ~/.zsh_extras ] && source ~/.zsh_extras"

echo
echo "Bootstrap complete! Open a new terminal or source your shell config to apply."
