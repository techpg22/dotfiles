# Ensure ~/.gitconfig exists
GITCONFIG="$HOME/.gitconfig"
if [ ! -f "$GITCONFIG" ]; then
    touch "$GITCONFIG"
fi

# Function to add git aliases if missing
add_git_alias() {
    local name=$1
    local cmd=$2
    # Check if alias already exists
    if ! git config --global alias."$name" >/dev/null; then
        git config --global alias."$name" "$cmd"
        echo "Added git alias: $name -> $cmd"
    fi
}

# Example aliases
add_git_alias st "status"
add_git_alias co "checkout"
add_git_alias cob "checkout -b"
add_git_alias c "commit -m"
add_git_alias lg "log --graph --oneline --decorate --all"
