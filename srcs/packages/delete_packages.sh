if [[ "${bash_source[1]}" == "${0}" ]]; then
  log_error "${bash_source[1]}" "this script is not meant to be sourced nor executed"
  exit 1
fi

# detect junest
if is_junest; then
  RUN=("$JUNEST" -n)
else
  RUN=()
fi

# delete cargo packages
log_info "$0" "deleting cargo packages"

if is_cargo "${RUN[@]}"; then
  for pkg in "${cargo_pkgs[@]}"; do
    "${RUN[@]}" cargo uninstall "$pkg" >/dev/null 2>&1 || true
  done
  log_info "$0" "successfully deleted cargo packages"
else
  log_info "$0" "can't find cargo"
fi

# delete npm packages
log_info "$0" "deleting npm packages"

if is_npm "${RUN[@]}"; then
  "${RUN[@]}" npm config set prefix "$npm_directory"
  "${RUN[@]}" sudo npm uninstall -g "${npm_pkgs[@]}"
  log_info "$0" "successfully deleted npm packages"
else
  log_info "$0" "can't find npm"
fi

# delete nvim
if is_nvim; then
  rm -f "$HOME/.local/bin/nvim"
fi

# delete vimplug
rm -f "${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site/autoload/plug.vim"
rm -rf "${XDG_DATA_HOME:-$HOME/.local/share}/nvim/plugged"

# detect package manager
if ! is_sudo || is_pacman; then
  source "$SCRIPT_DIRECTORY/srcs/packages/pacman.sh" -d
elif is_dnf; then
  source "$SCRIPT_DIRECTORY/srcs/packages/dnf.sh" -d
elif is_apt; then
  source "$SCRIPT_DIRECTORY/srcs/packages/apt.sh" -d
fi
