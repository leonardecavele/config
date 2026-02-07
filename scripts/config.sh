#!/usr/bin/env bash

# strict with errors
set -euo pipefail

# get logger
source "$SCRIPT_DIRECTORY/scripts/log.sh"

# pacman package list
pkgs=(
  neovim
  less
  base-devel
  macchina
  which
  tree
  tree-sitter-cli
  openssh
  nodejs
  npm
  curl
  git
  tar
  gzip
  wget
)

# npm package list
npms=(
  pyright
)

# detect mode to set runner
if /usr/bin/sudo -n true >/dev/null 2>&1 && command -v pacman >/dev/null 2>&1; then
  MODE="DIRECT"
  RUN=()
else
  MODE="JUNEST"
  if [ ! -x "$JUNEST" ]; then
    log_error "junest not found at: $JUNEST"
    exit 1
  fi
  RUN=("$JUNEST" -n)
fi

# update + install pkgs
log_info "(${MODE}) updating or installing pacman packages"
"${RUN[@]}" sudo pacman -Syu --noconfirm
"${RUN[@]}" sudo pacman -S --noconfirm --needed "${pkgs[@]}"
log_info "(${MODE}) done updating or installing pacman packages"

# update + install npms trying without sudo first
log_info "(${MODE}) updating or installing npm packages"
if ! "${RUN[@]}" npm i -g --no-fund --no-audit "${npms[@]}"; then
  "${RUN[@]}" sudo npm i -g --no-fund --no-audit "${npms[@]}"
fi
log_info "(${MODE}) done updating or installing npm packages"

# link config to home
mkdir -p "$HOME/.config"
ln -svf "$SCRIPT_DIRECTORY/config/kitty" "$HOME/.config/" || true
ln -svf "$SCRIPT_DIRECTORY/config/nvim" "$HOME/.config/" || true
ln -svf "$SCRIPT_DIRECTORY/config/macchina" "$HOME/.config/" || true
ln -svf "$SCRIPT_DIRECTORY/config/.bashrc" "$HOME/.bashrc" || true

# vim-plug to home
log_info "(${MODE}) installing vim plug"
data_home="${XDG_DATA_HOME:-$HOME/.local/share}"
plug_path="$data_home/nvim/site/autoload/plug.vim"
if [ ! -f "$plug_path" ]; then
  curl -sfLo "$plug_path" --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim >/dev/null
fi
log_info "(${MODE}) done installing vim plug: open neovim and run ':PlugInstall'"
