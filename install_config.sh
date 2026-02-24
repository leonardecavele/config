#!/usr/bin/env bash

# sources
export SCRIPT_DIRECTORY="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
export JUNEST_REPOSITORY="$HOME/.local/share/junest"
export JUNEST="${JUNEST:-$JUNEST_REPOSITORY/bin/junest}"

source "$SCRIPT_DIRECTORY/packages.sh"
source "$SCRIPT_DIRECTORY/srcs/colors.sh"
source "$SCRIPT_DIRECTORY/srcs/utils.sh"

export_in_bashrc "SCRIPT_DIRECTORY" "$SCRIPT_DIRECTORY"
export_in_bashrc "JUNEST_REPOSITORY" "$JUNEST_REPOSITORY"
export_in_bashrc "JUNEST" "$JUNEST"

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  log_error "$0" "this script must be sourced not executed"
  exit 1
fi

# check arguments validity
if [[ "${1-}" == "-h" || ( "${1-}" != "-i" && "${1-}" != "-u" && "${1-}" != "-d" ) ]]; then
  usage
  return
fi

# delete
if [ "${1-}" = "-d" ]; then

  log_info "$0" "deleting config"

  # remove exports of bashrc
  clean_bashrc_exports

  # delete fonts
  source "$SCRIPT_DIRECTORY/srcs/fonts/delete_fonts.sh"

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

  # delete fonts
  source "$SCRIPT_DIRECTORY/srcs/fonts/delete_fonts.sh"

  log_info "$0" "config successfully deleted"

  reload_shell
fi

# update
if [ "${1-}" = "-u" ]; then
	
	log_info "$0" "updating packages"

	source "$SCRIPT_DIRECTORY/srcs/packages/update_packages.sh" -u

	log_info "$0" "packages successfully updated"

	source "$SCRIPT_DIRECTORY/srcs/fonts/install_fonts.sh"

	reload_shell
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

# install
if is_sudo && (is_pacman || is_dnf || is_apt); then
  log_info "$0" "installing packages on home"

  source "$SCRIPT_DIRECTORY/srcs/packages/install_packages.sh"

  log_info "$0" "packages successfully installed"
else
  log_info "$0" "installing packages on junest"

  source "$SCRIPT_DIRECTORY/srcs/install_junest.sh"
  if [ "$?" -eq 1 ]; then
    log_error "$0" "cannot install config"
    return
  fi
  source "$SCRIPT_DIRECTORY/srcs/packages/install_packages.sh"

  log_info "$0" "packages successfully installed on junest"
fi

source "$SCRIPT_DIRECTORY/srcs/fonts/install_fonts.sh"

reload_shell
