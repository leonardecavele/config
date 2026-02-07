#!/usr/bin/env bash

# strict with errors
set -euo pipefail

# variables
export SCRIPT_DIRECTORY="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
export JUNEST_REPOSITORY="$SCRIPT_DIRECTORY/junest"
export JUNEST="${JUNEST:-$JUNEST_REPOSITORY/bin/junest}"
export user="leona"

# get logger
source "$SCRIPT_DIRECTORY/scripts/log.sh"

# if user have sudo and pacman
if /usr/bin/sudo -n true >/dev/null 2>&1 && command -v pacman >/dev/null 2>&1; then
  log_info "sudo + pacman available: installing on home"
  bash "$SCRIPT_DIRECTORY/scripts/config.sh"
else
  log_info "sudo and/or pacman not available: installing on junest"
  bash "$SCRIPT_DIRECTORY/scripts/junest.sh"
  bash "$SCRIPT_DIRECTORY/scripts/config.sh"
fi

log_info "reloading shell"
exec bash -l
