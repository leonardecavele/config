#!/usr/bin/env bash

# strict with errors
set -euo pipefail

# variables
export SCRIPT_DIRECTORY="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
export JUNEST_REPOSITORY="$SCRIPT_DIRECTORY/junest"
export JUNEST="${JUNEST:-$JUNEST_REPOSITORY/bin/junest}"
export user="leona"




printf -v VAR '%q' "$SCRIPT_DIRECTORY"
if ! grep -qE '^export SCRIPT_DIRECTORY=' "$SCRIPT_DIRECTORY/config/.bashrc"; then
  sed -i "/^# variables$/a export SCRIPT_DIRECTORY=$VAR" "$SCRIPT_DIRECTORY/config/.bashrc"
fi
printf -v VAR '%q' "$JUNEST_REPOSITORY"
if ! grep -qE '^export JUNEST_REPOSITORY=' "$SCRIPT_DIRECTORY/config/.bashrc"; then
  sed -i "/^# variables$/a export JUNEST_REPOSITORY=$VAR" "$SCRIPT_DIRECTORY/config/.bashrc"
fi
printf -v VAR '%q' "$JUNEST"
if ! grep -qE '^export JUNEST=' "$SCRIPT_DIRECTORY/config/.bashrc"; then
  sed -i "/^# variables$/a export JUNEST=$VAR" "$SCRIPT_DIRECTORY/config/.bashrc"
fi



# get logger and utils
source "$SCRIPT_DIRECTORY/srcs/log.sh"
source "$SCRIPT_DIRECTORY/srcs/utils.sh"

# delete the config
if [ "${1-}" = "-d" ]; then
  if in_junest; then
    log_error "please leave junest first, by typing 'ej' and reopening your terminal"
    exit 1
  fi
  # erase repository and junest
  rm -rf -- "$JUNEST_REPOSITORY" "$HOME/.junest"
  # erase variables in .bashrc
  perl -0777 -i -pe 's/^# variables[ \t]*\R.*?(?=^#)/# variables\n\n/sm' \
	  "$SCRIPT_DIRECTORY/config/.bashrc"
  # erase symlinks
  rm -f $HOME/.config/macchina $HOME/.config/nvim $HOME/.bashrc
  log_info "junest successfully uninstalled"
  exit 0
elif [ "${1-}" != "-s" ]; then
  log_error "invalid argument, usage: ./main.sh -s [SET-UP] | -d [DELETE]"
  exit 1
fi

# if user have sudo and pacman
if sudo_pacman_available; then
  log_info "sudo + pacman available: installing on home"
  bash "$SCRIPT_DIRECTORY/srcs/config.sh"
else
  log_info "sudo and/or pacman not available: installing on junest"
  bash "$SCRIPT_DIRECTORY/srcs/junest.sh"
  bash "$SCRIPT_DIRECTORY/srcs/config.sh"
fi

log_info "if needed, run '$0' again to update pacman packages"
log_info "reloading shell"

if in_junest; then
  source $HOME/.bashrc
else
  exec bash -l
fi
