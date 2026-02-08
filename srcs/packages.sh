#!/usr/bin/env bash

# detect mode to set RUNner
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
  if ! "${RUN[@]}" npm i -g --no-fund --no-audit "${npms[@]}"; then
    "${RUN[@]}" sudo npm i -g --no-fund --no-audit "${npms[@]}"
  fi
  log_info "[${MODE}] done updating or installing npm packages"
else
  log_info "[${MODE}] uninstalling npm packages"
  if ! "${RUN[@]}" npm uninstall -g "${npms[@]}"; then
    "${RUN[@]}" sudo npm uninstall -g "${npms[@]}"
  fi
  log_info "[${MODE}] done uninstalling npm packages"

  log_info "[${MODE}] uninstalling pacman packages"
  for p in "${pkgs[@]}"; do
    if "${RUN[@]}" pacman -Qq "$p" >/dev/null 2>&1; then
      if ! "${RUN[@]}" sudo pacman -Rns --noconfirm "$p" </dev/null; then
        log_info "[${MODE}] skipped (blocked by deps?): $p"
      fi
    fi
  done
  "${RUN[@]}" sudo pacman -Scc --noconfirm </dev/null || true
  log_info "[${MODE}] done uninstalling pacman packages"
fi
