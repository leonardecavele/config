# clone junest repository
if ! has_junest_repo; then
  git clone https://github.com/leonardecavele/junest.git "$JUNEST_REPOSITORY"
else
  log_info "junest already cloned in: ${JUNEST_REPOSITORY}"
fi

# check if junest is installed
if is_junest; then
  log_info "junest already installed"
  exit 0
fi

# install junest
log_info "installing junest"
"$JUNEST" setup
"$JUNEST" -f -- sudo pacman --noconfirm -Syy
"$JUNEST" -f -- sudo pacman --noconfirm -Sy archlinux-keyring
log_info "done installing junest"
