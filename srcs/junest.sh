#!/usr/bin/env bash

# strict with errors
set -euo pipefail

# get logger
source "$SCRIPT_DIRECTORY/scripts/log.sh"
source "$SCRIPT_DIRECTORY/scripts/utils.sh"

# clone junest repository
if ! junest_installed; then
  git clone https://github.com/leonardecavele/junest.git "$JUNEST_REPOSITORY"
else
  log_info "junest already installed: ${JUNEST_REPOSITORY}"
  exit 0
fi

# setup junest
log_info "installing junest"
"$JUNEST" setup
"$JUNEST" -f -- sudo pacman --noconfirm -Syy
"$JUNEST" -f -- sudo pacman --noconfirm -Sy archlinux-keyring
uid="$(id -u)"
mkdir -p "$HOME/.junest/etc"
touch "$HOME/.junest/etc/passwd"
grep -qE "^[^:]+:x:${uid}:" "$HOME/.junest/etc/passwd" || \
echo "${user}:x:${uid}:${uid}:${user}:/home/${user}:/bin/bash" >> "$HOME/.junest/etc/passwd"
log_info "done installing junest"
