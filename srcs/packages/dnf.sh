if [ "${1-}" = "-i" ] ; then
  # install dnf packages
  log_info "$0" "installing dnf packages"

  sudo dnf upgrade --refresh -y </dev/null
  sudo dnf install -y "${dnf_pkgs[@]}" </dev/null

  log_info "$0" "successfully installed dnf packages"

elif [ "${1-}" = "-u" ] ; then
  # update dnf packages
  log_info "$0" "updating dnf packages"

  sudo dnf upgrade --refresh -y </dev/null || true

  log_info "$0" "successfully updated dnf packages"

elif [ "${1-}" = "-d" ] ; then
  # delete dnf packages
  log_info "$0" "deleting dnf packages"

  for pkg in "${dnf_pkgs[@]}"; do
    if rpm -q "$pkg" >/dev/null 2>&1; then
	  if ! can_delete_dnf "$pkg"; then
        if ! sudo dnf remove -y "$pkg" </dev/null; then
          log_info "$0" "skipped (blocked by deps?): $pkg"
        fi
	  fi
    fi
  done
  sudo dnf clean all -y </dev/null || true

  log_info "$0" "successfully deleted dnf packages"
fi
