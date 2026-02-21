#!/usr/bin/env bash

# strict with errors
set -euo pipefail

# sources
export SCRIPT_DIRECTORY="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
export JUNEST_REPOSITORY="$SCRIPT_DIRECTORY/junest"
export JUNEST="${JUNEST:-$JUNEST_REPOSITORY/bin/junest}"

source "$SCRIPT_DIRECTORY/packages.sh"
source "$SCRIPT_DIRECTORY/srcs/colors.sh"
source "$SCRIPT_DIRECTORY/srcs/utils.sh"

export_in_bashrc "SCRIPT_DIRECTORY" "$SCRIPT_DIRECTORY"
export_in_bashrc "JUNEST_REPOSITORY" "$JUNEST_REPOSITORY"
export_in_bashrc "JUNEST" "$JUNEST"

# check arguments validity
if [[ "${1-}" == "-h" || ( "${1-}" != "-i" && "${1-}" != "-u" && "${1-}" != "-d" ) ]]; then
  usage
  exit 1
fi

# delete
if [ "${1-}" = "-d" ]; then

  log_info "$0" "deleting config"

  # delete packages
  source "$SCRIPT_DIRECTORY/srcs/packages/delete_packages.sh"

  # deleting .config directories
  for src_dir in "$SCRIPT_DIRECTORY/config"/*/; do
    [ -d "$src_dir" ] || continue
    name="$(basename "$src_dir")"
    rm -rf -- "$HOME/.config/$name"
  done
  # deleting dotfiles
  for src_path in "$SCRIPT_DIRECTORY/config"/.[!.]* "$SCRIPT_DIRECTORY/config"/..?*; do
    [ -e "$src_path" ] || continue
    name="$(basename "$src_path")"
    rm -f -- "$HOME/$name"
  done

  # deleting config remaining files
  rm -rf "$HOME/.local/share/nvim"

  # deleting junest
  if is_junest; then
    rm -rf -- "$JUNEST_REPOSITORY" "$HOME/.junest"
  fi

  log_info "$0" "config successfully deleted"
  exit 0
fi

if [ "${1-}" = "-u" ]; then
	
	log_info "$0" "updating packages"

	source "$SCRIPT_DIRECTORY/srcs/packages/update_packages.sh" -u

	log_info "$0" "packages successfully updated"
fi

# install
if is_sudo && (is_pacman || is_dnf || is_apt); then
  log_info "$0" "installing packages on home"

  source "$SCRIPT_DIRECTORY/srcs/packages/install_packages.sh"

  log_info "$0" "packages successfully installed"
else
  log_info "$0" "installing packages on junest"

  source "$SCRIPT_DIRECTORY/srcs/install_junest.sh"
  source "$SCRIPT_DIRECTORY/srcs/packages/install_packages.sh"

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
exec bash -i
