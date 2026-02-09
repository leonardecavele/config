# detect mode and set appropriate runner
if in_arch; then
  MODE="DIRECT"
  RUN=()
else
  MODE="HOST TO JUNEST"
  RUN=("$JUNEST" -n)
fi

# handle arguments
if [ "${1-}" != "-i" ] && [ "${1-}" != "-u" ] ; then
  log_error "invalid argument. usage:"
  log_error "./config.sh -i [INSTALL] | -u [UNINSTALL]"
  exit 1
fi

if [ "${1-}" = "-i" ] ; then
  # install
  log_info "[${MODE}] updating or installing pacman packages"
  "${RUN[@]}" sudo pacman -Syu --noconfirm
  "${RUN[@]}" sudo pacman -S --noconfirm --needed "${pkgs[@]}"
  log_info "[${MODE}] done updating or installing pacman packages"
  
  log_info "[${MODE}] updating or installing npm packages"
  missing_npms=()
  for pkg in "${npms[@]}"; do
    if ! "${RUN[@]}" npm -g ls "$pkg" --depth=0 >/dev/null 2>&1; then
      missing_npms+=("$pkg")
    fi
  done
  
  if [ "${#missing_npms[@]}" -eq 0 ]; then
    echo " there is nothing to do"
  else
    if ! "${RUN[@]}" npm i -g --no-fund --no-audit "${missing_npms[@]}"; then
      "${RUN[@]}" sudo npm i -g --no-fund --no-audit "${missing_npms[@]}"
    fi
  fi
  log_info "[${MODE}] done updating or installing npm packages"
else
  # uninstall
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
