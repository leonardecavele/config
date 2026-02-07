#!/usr/bin/env bash

# strict with errors
set -euo pipefail

# variables
export SCRIPT_DIRECTORY="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
export JUNEST_REPOSITORY="$SCRIPT_DIRECTORY/junest"
export JUNEST="${JUNEST:-$JUNEST_REPOSITORY/bin/junest}"
export user="leona"

# get logger and utils
source "$SCRIPT_DIRECTORY/srcs/log.sh"
source "$SCRIPT_DIRECTORY/srcs/utils.sh"

# arguments
if [ "${1-}" = "-d" ] || [ "${1-}" = "-ds" ]; then
  if in_junest; then
    log_error "please type 'exit' to quit junest first"
	exit 1
  fi
  rm -rf -- "$JUNEST_REPOSITORY" "$HOME/.junest"
  log_info "junest successfully uninstalled"
  [ "${1-}" = "-ds" ] && exit 0
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
