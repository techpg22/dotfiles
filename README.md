```
# Dotfiles

A modular dotfiles setup for managing shell enhancements, roles, and machine-specific configurations across multiple systems.

---

## Features

- Single-source shell enhancements (`shell_common.sh`) for bash/zsh
- Modular shell extras (`bash.sh`, `zsh.sh`)
- Role-based configuration:
  - Primary roles: `server`, `workstation`, `laptop`
  - Optional feature roles: `docker`, `git`, `monitoring`, etc.
- Safe symlinks — does not overwrite existing `.bashrc` or `.zshrc`
- Bootstrap script for quick setup on new machines
- Host-specific configuration support (stubbed via `hosts/<hostname>.sh`)

---

## Repository Structure

```
dotfiles/
├── bootstrap.sh         # Bootstrap script to setup dotfiles on a new machine
├── shell_common.sh      # Common shell enhancements and role loader
├── shells/
│   ├── bash.sh          # Bash-specific enhancements
│   └── zsh.sh           # Zsh-specific enhancements
├── roles/
│   ├── server.sh        # Server-specific aliases, env vars, etc.
│   ├── workstation.sh   # Workstation-specific settings
│   ├── laptop.sh        # Laptop-specific settings
│   ├── docker.sh        # Optional Docker role
│   └── git.sh           # Optional Git role (aliases + gitconfig)
├── hosts/               # Host-specific configuration stubs
└── README.md
```

---

## Bootstrap Setup

Run the bootstrap script on a fresh machine:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/<username>/dotfiles/main/bootstrap.sh)"
```

The script will:

1. Clone or pull the dotfiles repo into `~/dotfiles`
2. Create safe symlinks for:
   - `~/.shell_common`
   - `~/.bash_extras`
   - `~/.zsh_extras`
3. Prompt you to select:
   - **Primary role** (server/workstation/laptop)
   - **Optional feature roles** (docker, git, monitoring, etc.)
4. Write your role selections to `~/.dotfiles_roles`
5. (Optional) Set default editor: `EDITOR=vim`, `VISUAL=vim`

> The script is idempotent — safe to run multiple times.

---

## Shell Configuration

Ensure your shell config sources the enhancements:

**Bash (`~/.bashrc`):**

```bash
[ -f ~/.shell_common ] && . ~/.shell_common
[ -f ~/.bash_extras ] && . ~/.bash_extras
```

**Zsh (`~/.zshrc`):**

```bash
[ -f ~/.shell_common ] && source ~/.shell_common
[ -f ~/.zsh_extras ] && source ~/.zsh_extras
```

`shell_common.sh` will:

- Detect your shell (bash vs zsh)
- Load the shell extras
- Load all roles from `~/.dotfiles_roles`
- Optionally load host-specific configs from `hosts/<hostname>.sh`

---

## Roles

- **Primary roles:** machine type, required
- **Optional roles:** feature-based, selected by user at bootstrap
- Roles contain aliases, functions, and environment variables, e.g., git configuration, docker helpers

**Example `~/.dotfiles_roles` after bootstrap:**

```
server,docker,git
```

---

## Host-specific Configs (Optional)

You can create host-specific files in `hosts/`:

```
hosts/myserver.sh
```

- These files are sourced automatically by `shell_common.sh`
- Useful for machine-specific environment variables or overrides

---

## Git Role Example

- Sets global Git aliases and environment variables:

```bash
git config --global alias.st "status -sb"
git config --global alias.co "checkout"
git config --global alias.ci "commit"
git config --global alias.br "branch"
git config --global alias.lg "log --graph --oneline --decorate --all"
```

- Can also export `GIT_AUTHOR_NAME` and `GIT_AUTHOR_EMAIL`

---

## Extending

- Add new feature roles by creating `roles/<role>.sh`
- Optional roles automatically appear in bootstrap prompt
- Host-specific configs are automatically sourced if `hosts/<hostname>.sh` exists

---

## Notes

- Bootstrap script requires `git` to clone the repo
- Safe symlinks ensure existing shell configs are not overridden
- Roles and extras are shell-agnostic and portable
- The setup works on bash, zsh, or any POSIX-compliant shell
```
