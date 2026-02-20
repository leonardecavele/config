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

  for pkg in "${apt_pkgs[@]}"; do
    if dpkg -s "$pkg" >/dev/null 2>&1; then
      if ! sudo apt-get purge -y -q "$pkg" </dev/null; then
        log_info "$0" "skipped (blocked by deps?): $pkg"
      fi
    fi
  done
  sudo apt-get clean </dev/null || true

  log_info "$0" "successfully deleted apt packages"
fi
