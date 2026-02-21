if [[ "${bash_source[1]}" == "${0}" ]]; then
  log_error "${bash_source[1]}" "this script is not meant to be sourced nor executed"
  exit 1
fi

SNAP_DIR="$SCRIPT_DIRECTORY/snapshots"
SNAP_BASE="$SNAP_DIR/dnf_before.snp"
SNAP_CUR="$SNAP_DIR/dnf_now.snp"
SNAP_DIFF="$SNAP_DIR/dnf_diff.snp"

if [ "${1-}" = "-i" ] ; then
  log_info "$0" "installing dnf packages"

  mkdir -p "$SNAP_DIR"
  dnf repoquery --userinstalled | sort -u > "$SNAP_BASE"

  sudo dnf upgrade --refresh -y </dev/null
  sudo dnf install -y "${dnf_pkgs[@]}" </dev/null

  log_info "$0" "successfully installed dnf packages"

elif [ "${1-}" = "-u" ] ; then
  # update dnf packages
  log_info "$0" "updating dnf packages"

  sudo dnf upgrade --refresh -y </dev/null || true

  log_info "$0" "successfully updated dnf packages"

elif [ "${1-}" = "-d" ] ; then
  log_info "$0" "deleting dnf packages"

  if [ ! -f "$SNAP_BASE" ]; then
    log_error "$0" "snapshots missing: $SNAP_BASE"
    exit 1
  fi

  dnf repoquery --userinstalled | sort -u > "$SNAP_CUR"
  comm -13 "$SNAP_BASE" "$SNAP_CUR" > "$SNAP_DIFF"

  if [ ! -s "$SNAP_DIFF" ]; then
    log_info "$0" "nothing to remove"
  else
    xargs -r -a "$SNAP_DIFF" sudo dnf remove -y </dev/null
  fi

  sudo dnf autoremove -y </dev/null || true
  sudo dnf clean all -y </dev/null || true

  rm -f "$SNAP_BASE" "$SNAP_CUR" "$SNAP_DIFF"

  log_info "$0" "successfully deleted dnf packages"
fi
