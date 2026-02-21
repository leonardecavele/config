# detect junest
if is_junest; then
  RUN=("$JUNEST" -n)
else
  RUN=()
fi

# detect package manager
if ! is_sudo || is_pacman; then
  source "$SCRIPT_DIRECTORY/srcs/packages/pacman.sh" -u
elif is_dnf; then
  source "$SCRIPT_DIRECTORY/srcs/packages/dnf.sh" -u
elif is_apt; then
  source "$SCRIPT_DIRECTORY/srcs/packages/apt.sh" -u
fi

# update cargo packages
log_info "$0" "updating cargo packages"

if is_cargo; then
  for pkg in "${cargo_pkgs[@]}"; do
    "${RUN[@]}" cargo install-update -a >/dev/null 2>&1 || true
    break
  done
  log_info "$0" "successfully updated cargo packages"
else
  log_info "$0" "can't find cargo"
fi

# update npm packages
log_info "$0" "updating npm packages"

if is_npm; then
  npm config set prefix "$npm_directory"
  "${RUN[@]}" sudo npm update -g "${npm_pkgs[@]}" >/dev/null 2>&1 || true
  log_info "$0" "successfully updated npm packages"
else
  log_info "$0" "can't find npm"
fi

# update vim plug-ins
"$HOME/.local/bin/nvim" --headless +'PlugInstall --sync' +qa >/dev/null 2>&1
"$HOME/.local/bin/nvim" --headless +'PlugUpdate --sync' +qa >/dev/null 2>&1
