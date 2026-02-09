#!/usr/bin/env bash

# strict with errors
set -euo pipefail

# variables
export SCRIPT_DIRECTORY="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
export JUNEST_REPOSITORY="$SCRIPT_DIRECTORY/junest"
export JUNEST="${JUNEST:-$JUNEST_REPOSITORY/bin/junest}"

# get helper and user options 
source "$SCRIPT_DIRECTORY/srcs/helper.sh"
source "$SCRIPT_DIRECTORY/options.sh"

# handle arguments
if [[ "${1-}" == "-h" || ( "${1-}" != "-s" && "${1-}" != "-u" && "${1-}" != "-r" ) ]]; then
  usage
  exit 0
fi

if [ "${1-}" = "-r" ] || [ "${1-}" = "-u" ]; then
  if [ "${1-}" = "-r" ] && in_arch && junest_installed; then
	  export_in_bashrc "EXIT_JUNEST" "0"
    log_info "please restart your terminal"
    exit 0
  fi
  perl -0777 -i -pe 's/^# variables[ \t]*\R.*?(?=^#)/# variables\n\n/sm' \
	  "$SCRIPT_DIRECTORY/config/.bashrc"
  rm -f $HOME/.config/macchina $HOME/.config/nvim $HOME/.bashrc $HOME/.tmux.conf
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
export_in_bashrc "JUNEST_REPOSITORY" "$JUNEST_REPOSITORY"
export_in_bashrc "JUNEST" "$JUNEST"

# populate locale for perl
if sudo_pacman_available; then
  log_info "populating locale"
  sudo locale-gen
  sudo sed -i \
    's/^[[:space:]]*#[[:space:]]*\(en_US\.UTF-8[[:space:]]\+UTF-8\)/\1/' \
    /etc/locale.gen
  echo 'LANG=en_US.UTF-8' | sudo tee /etc/locale.conf >/dev/null
  log_info "done populating locale"
fi

# install
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
for path in "$SCRIPT_DIRECTORY/config"/.[!.]* "$SCRIPT_DIRECTORY/config"/..?*; do
  [ -e "$path" ] || continue
  ln -svf "$path" "$HOME/" || true
done

# vim-plug
log_info "[${MODE}] installing vim plug"
data_home="${XDG_DATA_HOME:-$HOME/.local/share}"
plug_path="$data_home/nvim/site/autoload/plug.vim"
if [ ! -f "$plug_path" ]; then
  curl -sfLo "$plug_path" --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim >/dev/null
fi
log_info "[${MODE}] done installing vim plug: open neovim and run ':PlugInstall'"

log_info "reloading shell"

if in_arch; then
  source $HOME/.bashrc
else
  exec bash -l
fi
