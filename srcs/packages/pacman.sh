# detect junest
if is_junest; then
  RUN=()
else
  RUN=("$JUNEST" -n)
fi

if [ "${1-}" = "-i" ] ; then
  # install pacman packages
  log_info "$0" "installing pacman packages"

  "${RUN[@]}" sudo pacman -Syu --noconfirm
  "${RUN[@]}" sudo pacman -S --noconfirm --needed "${pacman_pkgs[@]}"

  log_info "$0" "successfully installed pacman packages"

elif [ "${1-}" = "-u" ] ; then
  # update pacman packages
  log_info "$0" "updating pacman packages"

  "${RUN[@]}" sudo pacman -Syu --noconfirm </dev/null || true

  log_info "$0" "successfully updated pacman packages"

elif [ "${1-}" = "-d" ] ; then
  # delete pacman packages
  log_info "$0" "deleting pacman packages"

  for pkg in "${pacman_pkgs[@]}"; do
    if "${RUN[@]}" pacman -Qq "$pkg" >/dev/null 2>&1; then
      if ! "${RUN[@]}" sudo pacman -R --noconfirm "$pkg" </dev/null; then
        log_info "$0" "skipped (blocked by deps?): $pkg"
      fi
    fi
  done
  "${RUN[@]}" sudo pacman -Scc --noconfirm </dev/null || true

  log_info "$0" "successfully deleted pacman packages"
fi
