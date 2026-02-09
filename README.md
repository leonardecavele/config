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
if you edit any other file. You might want to edit ``.gitconfig`` as well.
```
.
├── config              # User directories installed into ~/.config and dotfiles into ~/
│   ├── macchina
│   └── nvim
│   └── .bashrc
│   └── .tmux.conf
│   └── .gitconfig
├── junest              # JuNest sources (installed automatically if needed)
├── main.sh             # Entry point
├── options.sh          # User options
└── srcs
    ├── helper.sh       # Environment detection and helpers
    ├── junest.sh       # JuNest management logic
    └── packages.sh     # Package installation logic
```

### BINDINGS

#### Neovim (Telescope)

- `Space ff`  Find files in the project  
- `Space fg`  Live grep across the whole project  
- `Space fb`  List opened buffers  
- `Space fh`  Search Neovim help tags  

#### Neovim (Goto preview)

- `C-f`  Open preview window of the definition
- `A-f`  Close all opened preview windows

#### Neovim (Nvim Mini)

- `\tc`  Toggle completion

#### Tmux

- `C-Space h`  Move to left pane  
- `C-Space j`  Move to bottom pane  
- `C-Space k`  Move to top pane  
- `C-Space l`  Move to right pane  
- `C-Space p`  Switch to previous pane  
- `C-Space Space`  Change pane layout
- `C-Space R`  Reload tmux
- `C-Space z`  Single pane focus
