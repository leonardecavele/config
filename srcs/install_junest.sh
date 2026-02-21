if [[ "${bash_source[1]}" == "${0}" ]]; then
  log_error "${bash_source[1]}" "this script is not meant to be sourced nor executed"
  exit 1
fi

# clone junest repository
if ! is_junest; then
  git clone https://github.com/leonardecavele/junest.git "$JUNEST_REPOSITORY"
else
  log_info "$0" "junest already cloned in: ${JUNEST_REPOSITORY}"
fi

# check if junest is installed
if [ -d "$HOME/.junest" ] ; then
  log_info "$0" "junest already installed"
  return 0
fi

if ! can_install_junest; then
  log_error "$0" "can't install junest"
  return 1
fi

# install junest
log_info "$0" "installing junest"
"$JUNEST" setup
"$JUNEST" -f -- sudo pacman --noconfirm -Syy
"$JUNEST" -f -- sudo pacman --noconfirm -Sy archlinux-keyring
log_info "$0" "done installing junest"
