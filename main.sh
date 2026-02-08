#!/usr/bin/env bash

# strict with errors
set -euo pipefail

# variables
export SCRIPT_DIRECTORY="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
export JUNEST_REPOSITORY="$SCRIPT_DIRECTORY/junest"
export JUNEST="${JUNEST:-$JUNEST_REPOSITORY/bin/junest}"

# get logger and utils
source "$SCRIPT_DIRECTORY/srcs/helper.sh"
source "$SCRIPT_DIRECTORY/options.sh"

# handle arguments
if [[ "${1-}" == "-h" || ( "${1-}" != "-s" && "${1-}" != "-u" && "${1-}" != "-r" ) ]]; then
  usage
  exit 0
fi

if [ "${1-}" = "-r" ] || [ "${1-}" = "-u" ]; then
  if [ "${1-}" = "-r" ] && in_arch && junest_installed; then
	exit_junest
    log_info "please restart your terminal"
    exit 1
  fi
  perl -0777 -i -pe 's/^# variables[ \t]*\R.*?(?=^#)/# variables\n\n/sm' \
	  "$SCRIPT_DIRECTORY/config/.bashrc"
  rm -f $HOME/.config/macchina $HOME/.config/nvim $HOME/.bashrc
  log_info "config successfully uninstalled"
  if [ "${1-}" = "-r" ]; then
    rm -rf -- "$JUNEST_REPOSITORY" "$HOME/.junest"
    log_info "junest successfully uninstalled"
    exit 0
  fi
fi
if [ "${1-}" = "-u" ]; then
  source "$SCRIPT_DIRECTORY/srcs/packages.sh" -u
  log_info "packages successfully uninstalled"
  exit 0
fi

export_in_bashrc "SCRIPT_DIRECTORY" "$SCRIPT_DIRECTORY"

# install depending on environment
if sudo_pacman_available; then
  log_info "sudo + pacman available: installing on home"
  source "$SCRIPT_DIRECTORY/srcs/packages.sh" -i
else
  log_info "sudo and/or pacman not available: installing on junest"
  source "$SCRIPT_DIRECTORY/srcs/junest.sh"
  source "$SCRIPT_DIRECTORY/srcs/packages.sh" -i
  export_in_bashrc "JUNEST_REPOSITORY" "$JUNEST_REPOSITORY"
  export_in_bashrc "JUNEST" "$JUNEST"
fi

# link config to home
mkdir -p "$HOME/.config"
for dir in "$SCRIPT_DIRECTORY/config"/*/; do
  [ -r "$dir" ] || continue
  ln -svf "$dir" "$HOME/.config/" || true
done
ln -svf "$SCRIPT_DIRECTORY/config/.bashrc" "$HOME/.bashrc" || true

# vim-plug to home
log_info "[${MODE}] installing vim plug"
data_home="${XDG_DATA_HOME:-$HOME/.local/share}"
plug_path="$data_home/nvim/site/autoload/plug.vim"
if [ ! -f "$plug_path" ]; then
  curl -sfLo "$plug_path" --create-rirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim >/dev/null
fi
log_info "[${MODE}] done installing vim plug: open neovim and run ':PlugInstall'"

log_info "reloading shell"

if in_arch; then
  source $HOME/.bashrc
else
  exec bash -l
fi
