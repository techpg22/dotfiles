# Dotfiles – Portable Shell Enhancements

This repository contains non-invasive shell enhancements designed to layer on top of existing system and user shell configurations without overriding them.

The goal is:
- Portability across servers, laptops, and workstations
- Zero replacement of .bashrc, .bash_profile, or .zshrc
- Explicit opt-in loading
- Git-tracked, symlink-friendly configuration

---

## Philosophy

- Core shell files remain local
- Enhancements live in git
- Enhancements are sourced conditionally
- Nothing is auto-loaded unless explicitly enabled

This mirrors how Linux distributions structure shell configuration.

---

## Repository Structure

dotfiles/
├── shell_common.sh     # Shared enhancements (bash + zsh)
├── bash_extras.sh      # Bash-specific behavior
├── zsh_extras.sh       # Zsh-specific behavior
├── hosts/              # Host-specific overrides
│   └── example.sh
└── README.md

---

## What Each File Does

shell_common.sh
- Loaded by all shells
- Contains:
  - Shared aliases
  - Functions
  - PATH updates
  - Tooling helpers
- POSIX-compatible
- Guarded against multiple loads

bash_extras.sh
- Loaded only in bash
- Contains:
  - shopt settings
  - Bash-only behavior
  - Bash-specific helpers

zsh_extras.sh
- Loaded only in zsh
- Contains:
  - setopt options
  - Zsh-specific behavior
  - Zsh-only helpers

hosts/<hostname>.sh
- Optional per-host overrides
- Automatically loaded if present
- Keeps host-specific logic out of shared files

---

## Installation (Safe & Non-Invasive)

1. Clone the repository

git clone git@github.com:<your-username>/dotfiles.git ~/dotfiles

2. Create symlinks to enhancement files

ln -s ~/dotfiles/shell_common.sh ~/.shell_common
ln -s ~/dotfiles/bash_extras.sh ~/.bash_extras
ln -s ~/dotfiles/zsh_extras.sh ~/.zsh_extras

These files are inert unless sourced.

---

## Enabling Enhancements

Bash

Add the following to ~/.bashrc:

[ -f ~/.shell_common ] && . ~/.shell_common
[ -f ~/.bash_extras ] && . ~/.bash_extras

Zsh

Add the following to ~/.zshrc:

[ -f ~/.shell_common ] && source ~/.shell_common
[ -f ~/.zsh_extras ] && source ~/.zsh_extras

---

## Host-Specific Configuration

Create a file named after the host:

~/dotfiles/hosts/$(hostname -s).sh

Example:

alias disks='lsblk -o NAME,SIZE,MOUNTPOINT'

This file will be loaded automatically if it exists.

---

## Turning Enhancements Off

Simply comment out or remove the source lines in .bashrc or .zshrc.

No files need to be deleted.

---

## Compatibility

- Works with SSH
- Works with VS Code Remote SSH
- Works with login and non-login shells
- Compatible with future dotfile managers (e.g. chezmoi)
