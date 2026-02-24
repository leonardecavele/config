# clone junest repository
if ! is_junest; then
  git clone https://github.com/leonardecavele/junest.git "$JUNEST_REPOSITORY"
else
  log_info "$0" "junest already cloned in: ${JUNEST_REPOSITORY}"
fi

# check if junest is installed
if [ -d "$HOME/.junest" ] ; then
  log_info "$0" "junest already installed"
  return
fi

if ! can_install_junest; then
  log_error "$0" "can't install junest"
  return
fi

# install junest
log_info "$0" "installing junest"
junest setup
junest -- sudo pacman --noconfirm -Syy
junest -- sudo pacman --noconfirm -Sy archlinux-keyring
log_info "$0" "done installing junest"
