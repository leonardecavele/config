if [[ "${bash_source[1]}" == "${0}" ]]; then
  log_error "${bash_source[1]}" "this script is not meant to be sourced nor executed"
  exit 1
fi

SNAP_DIR="$SCRIPT_DIRECTORY/snapshots"
SNAP_BASE="$SNAP_DIR/pacman_before.snp"
SNAP_CUR="$SNAP_DIR/pacman_now.snp"
SNAP_DIFF="$SNAP_DIR/pacman_diff.snp"

# detect junest
if is_junest; then
  RUN=("$JUNEST" -n)
else
  RUN=()
fi

if [ "${1-}" = "-i" ] ; then
  log_info "$0" "installing pacman packages"

  mkdir -p "$SNAP_DIR"

  if ! is_junest; then
    "${RUN[@]}" pacman -Qqe | sort -u > "$SNAP_BASE"
  fi

  "${RUN[@]}" sudo pacman -Syu --noconfirm
  "${RUN[@]}" sudo pacman -S --noconfirm --needed "${pacman_pkgs[@]}"

  log_info "$0" "successfully installed pacman packages"

elif [ "${1-}" = "-u" ] ; then
  # update pacman packages
  log_info "$0" "updating pacman packages"

  "${RUN[@]}" sudo pacman -Syu --noconfirm </dev/null || true

  log_info "$0" "successfully updated pacman packages"

elif [ "${1-}" = "-d" ] && ! is_junest ; then
  log_info "$0" "deleting pacman packages"

  if [ ! -f "$SNAP_BASE" ]; then
    log_error "$0" "snapshots missing: $SNAP_BASE"
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
