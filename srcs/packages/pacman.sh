SNAP_DIR="$SCRIPT_DIRECTORY/snapshot"
SNAP_BASE="$SNAP_DIR/pacman_base.snapshot"
SNAP_CUR="$SNAP_DIR/pacman_cur.snapshot"
SNAP_DIFF="$SNAP_DIR/pacman_diff.snapshot"

# detect junest
if is_junest; then
  RUN=()
else
  RUN=("$JUNEST" -n)
fi

if [ "${1-}" = "-i" ] ; then
  log_info "$0" "installing pacman packages"

  mkdir -p "$SNAP_DIR"

  "${RUN[@]}" pacman -Qqe | sort -u > "$SNAP_BASE"

  "${RUN[@]}" sudo pacman -Syu --noconfirm
  "${RUN[@]}" sudo pacman -S --noconfirm --needed "${pacman_pkgs[@]}"

  log_info "$0" "successfully installed pacman packages"

elif [ "${1-}" = "-u" ] ; then
  # update pacman packages
  log_info "$0" "updating pacman packages"

  "${RUN[@]}" sudo pacman -Syu --noconfirm </dev/null || true

  log_info "$0" "successfully updated pacman packages"

elif [ "${1-}" = "-d" ] ; then
  log_info "$0" "deleting pacman packages"

  if [ ! -f "$SNAP_BASE" ]; then
    log_error "$0" "snapshot missing: $SNAP_BASE"
    exit 1
  fi

  "${RUN[@]}" pacman -Qqe | sort -u > "$SNAP_CUR"
  comm -13 "$SNAP_BASE" "$SNAP_CUR" > "$SNAP_DIFF"

  if [ ! -s "$SNAP_DIFF" ]; then
    log_info "$0" "nothing to remove"
  else
    xargs -r -a "$SNAP_DIFF" "${RUN[@]}" sudo pacman -Rns --noconfirm
  fi

  "${RUN[@]}" sudo pacman -Scc --noconfirm </dev/null || true

  rm -f "$SNAP_BASE" "$SNAP_CUR" "$SNAP_DIFF"

  log_info "$0" "successfully deleted pacman packages"
fi
