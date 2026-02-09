### OVERVIEW

This project provides a portable Arch Linux user environment. The script installs packages with pacman
and sets up a full user environment (dotfiles, editors, tools) inside `$HOME/.config`. If either pacman or sudo are
not available on the host system, the environment is automatically replaced by a JuNest-based Arch environment
overriding the host system.

### USAGE
If you already set-up the environment, you can access this script at any time, by simply using ``ale``. For example: 
``ale -s`` updates your packages whatever is your pwd.
```text
Usage: main.sh [OPTION]

Options:
  -s    Set up JuNest (if needed) and install/update packages
  -u    Uninstall downloaded packages
  -r    Remove JuNest and its packages
  -h    Show this help and exit

Examples:
  main.sh -s
  main.sh -u
  main.sh -r
```

### STRUCTURE
The ``options.sh`` file is meant to be modified if you want to customize your install. You might broke the scvript
if you edit any other file.
```
.
├── config              # User configuration installed into ~/.config
│   ├── macchina
│   └── nvim
├── junest              # JuNest sources (installed automatically if needed)
├── main.sh             # Entry point
├── options.sh          # User options
└── srcs
    ├── helper.sh       # Environment detection and helpers
    ├── junest.sh       # JuNest management logic
    └── packages.sh     # Package installation logic
```
