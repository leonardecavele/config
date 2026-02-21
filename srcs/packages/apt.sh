SNAP_DIR="$SCRIPT_DIRECTORY/snapshot"
SNAP_BASE="$SNAP_DIR/apt_base.snapshot"
SNAP_CUR="$SNAP_DIR/apt_cur.snapshot"
SNAP_DIFF="$SNAP_DIR/apt_diff.snapshot"

export DEBIAN_FRONTEND=noninteractive
export DEBCONF_NONINTERACTIVE_SEEN=true

sudo -E debconf-set-selections <<'EOF'
console-setup  console-setup/charmap47  select  UTF-8
console-setup  console-setup/codeset47  select  Guess optimal character set
keyboard-configuration keyboard-configuration/layout select French
keyboard-configuration keyboard-configuration/model select Generic 105-key PC (intl.)
keyboard-configuration keyboard-configuration/variant select French
EOF

if [ "${1-}" = "-i" ] ; then
  # install apt packages
  log_info "$0" "installing apt packages"

  mkdir -p $SNAP_DIR
  apt-mark showmanual | sort -u > "$SNAP_BASE"

  sudo apt-get update -y -q </dev/null
  sudo apt-get upgrade -y -q </dev/null
  sudo apt-get install -y -q "${apt_pkgs[@]}" </dev/null

  log_info "$0" "successfully installed apt packages"

elif [ "${1-}" = "-u" ] ; then
  # update apt packages
  log_info "$0" "updating apt packages"

  sudo apt-get update -y -q </dev/null || true
  sudo apt-get upgrade -y -q </dev/null || true

  log_info "$0" "successfully updated apt packages"

elif [ "${1-}" = "-d" ] ; then
  # delete apt packages
  log_info "$0" "deleting apt packages"

  if [ ! -f "$SNAP_BASE" ]; then
    log_error "$0" "snapshot missing: $SNAP_BASE"
    exit 1
  fi

  apt-mark showmanual | sort -u > "$SNAP_CUR"
  comm -13 "$SNAP_BASE" "$SNAP_CUR" > "$SNAP_DIFF"

  if [ ! -s "$SNAP_DIFF" ]; then
    log_info "$0" "nothing to remove"
  else
    xargs -r -a "$SNAP_DIFF" sudo apt-get remove -y -q </dev/null
    sudo apt-get autoremove -y -q </dev/null
  fi

  sudo apt-get clean </dev/null || true
  rm -f "$SNAP_BASE" "$SNAP_CUR" "$SNAP_DIFF"

  log_info "$0" "successfully deleted apt packages"
fi
