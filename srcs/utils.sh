#!/usr/bin/env bash

junest_installed() {
  if [ -d "$JUNEST_REPOSITORY" ]; then
    return 0
  fi
  return 1
}

in_junest() {
  if [ -f /etc/arch-release ] && command -v pacman >/dev/null 2>&1; then
    return 0
  fi
  return 1
}

sudo_pacman_available() {
  if /usr/bin/sudo -n true >/dev/null 2>&1 && command -v pacman >/dev/null 2>&1; then
    return 0
  fi
  return 1
}
