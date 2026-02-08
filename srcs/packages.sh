#!/usr/bin/env bash

# detect mode to set runner
if in_junest; then
  MODE="DIRECT"
  RUN=()
else
  if ! junest_installed; then
    log_error "junest not found at: $JUNEST"
    exit 1
  fi
  MODE="HOST TO JUNEST"
  RUN=("$JUNEST" -n)
fi

if [ "${1-}" != "-i" ] && [ "${1-}" != "-u" ] ; then
  log_error "invalid argument. usage:"
  log_error "./config.sh -i [INSTALL] | -u [UNINSTALL]"
  exit 1
fi

if [ "${1-}" = "-i" ] ; then
  log_info "[${MODE}] updating or installing pacman packages"
  "${RUN[@]}" sudo pacman -Syu --noconfirm
  "${RUN[@]}" sudo pacman -S --noconfirm --needed "${pkgs[@]}"
  log_info "[${MODE}] done updating or installing pacman packages"
  
  log_info "[${MODE}] updating or installing npm packages"
  if ! "${run[@]}" npm i -g --no-fund --no-audit "${npms[@]}"; then
    "${run[@]}" sudo npm i -g --no-fund --no-audit "${npms[@]}"
  fi
  log_info "[${MODE}] done updating or installing npm packages"
else
  log_info "[${MODE}] uninstalling npm packages"
  if ! "${run[@]}" npm -g uninstall "${npms[@]}"; then
    "${run[@]}" sudo npm -g uninstall "${npms[@]}"
  fi
  log_info "[${MODE}] done uninstalling npm packages"

  log_info "[${MODE}] uninstalling pacman packages"
  "${RUN[@]}" sudo pacman -Rns --noconfirm "${pkgs[@]}"
  log_info "[${MODE}] done uninstalling pacman packages"
fi
