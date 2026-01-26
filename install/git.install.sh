#!/usr/bin/env bash
set -e

command -v git >/dev/null 2>&1 || {
  echo "git not installed, skipping git role install"
  return 0
}


# Function to add git aliases if missing
add_git_alias() {
    local name=$1
    local cmd=$2
    # Check if alias already exists
    if ! git config --global alias."$name" >/dev/null 2>&1; then
        git config --global alias."$name" "$cmd"
        echo "Added git alias: $name -> $cmd"
    fi
}

# Example aliases
add_git_alias a "add"
add_git_alias c "commit"
add_git_alias cm "commit -m"
add_git_alias st "status"
add_git_alias co "checkout"
add_git_alias cob "checkout -b"
add_git_alias lg "log --graph --oneline --decorate --all"
add_git_alias pl "pull"
add_git_alias p "push"
