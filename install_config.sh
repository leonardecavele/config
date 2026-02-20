#!/usr/bin/env bash

# strict with errors
set -euo pipefail

export SCRIPT_DIRECTORY="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
export_in_bashrc "SCRIPT_DIRECTORY" "$SCRIPT_DIRECTORY"

# sources
source "$SCRIPT_DIRECTORY/srcs/utils.sh"

# check arguments validity
if [[ "${1-}" == "-h" || ( "${1-}" != "-i" && "${1-}" != "-u" && "${1-}" != "-d" ) ]]; then
  usage
  exit 1
fi

# delete
if [ "${1-}" = "-r" ]; then

  log_info "$0" "deleting config"

  # delete packages
  source "$SCRIPT_DIRECTORY/srcs/install_packages.sh" -d

  # deleting .config directories
  for dir in "$SCRIPT_DIRECTORY/config"/*/; do
    rm -rf "$dir"
  done
  # deleting dotfiles
  for path in "$SCRIPT_DIRECTORY/config"/.[!.]* "$SCRIPT_DIRECTORY/config"/..?*; do
	rm -f "$path"
  done

  # deleting config remaining files
  rm -rf $HOME/.local/share/nvim

  # deleting junest
  if is_junest; then
    rm -rf -- "$JUNEST_REPOSITORY" "$HOME/.junest"
  fi

  log_info "$0" "config successfully deleted"
  exit 0
fi

if [ "${1-}" = "-u" ]; then
	
	log_info "$0" "updating packages"

	source "$SCRIPT_DIRECTORY/srcs/install_packages.sh" -u

	log_info "$0" "packages successfully updated"
fi

# install
if is_sudo && (is_pacman || is_dnf || is_apt); then
  log_info "$0" "installing packages on home"

  source "$SCRIPT_DIRECTORY/srcs/install_packages.sh" -i

  log_info "$0" "packages successfully installed"
else
  log_info "$0" "installing packages on junest"

  source "$SCRIPT_DIRECTORY/srcs/install_junest.sh"
  source "$SCRIPT_DIRECTORY/srcs/install_packages.sh" -i

  export JUNEST_REPOSITORY="$SCRIPT_DIRECTORY/junest"
  export_in_bashrc "JUNEST_REPOSITORY" "$JUNEST_REPOSITORY"
  
  export JUNEST="${JUNEST:-$JUNEST_REPOSITORY/bin/junest}"
  export_in_bashrc "JUNEST" "$JUNEST"

  log_info "$0" "packages successfully installed on junest"
fi


# link .config directories
mkdir -p "$HOME/.config"
for dir in "$SCRIPT_DIRECTORY/config"/*/; do
  [ -r "$dir" ] || continue
  ln -svf "$dir" "$HOME/.config/" || true
done

# link dotfiles
for path in "$SCRIPT_DIRECTORY/config"/.[!.]* "$SCRIPT_DIRECTORY/config"/..?*; do
  [ -e "$path" ] || continue
  ln -svf "$path" "$HOME/" || true
done

# vim-plug
log_info "$0" "installing vim plug"

data_home="${XDG_DATA_HOME:-$HOME/.local/share}"
plug_path="$data_home/nvim/site/autoload/plug.vim"
if [ ! -f "$plug_path" ]; then
  curl -sfLo "$plug_path" --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim >/dev/null
fi

log_info "$0" "vim plug installed: please run ':PlugInstall'"

# shell reload
log_info "$0" "reloading shell"
source $HOME/.bashrc
