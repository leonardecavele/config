# detect junest
if is_junest; then
  RUN=("$JUNEST" -n)
else
  RUN=()
fi

# detect package manager
if ! is_sudo || is_pacman; then
  source "$SCRIPT_DIRECTORY/srcs/packages/pacman.sh" -i
elif is_dnf; then
  source "$SCRIPT_DIRECTORY/srcs/packages/dnf.sh" -i
elif is_apt; then
  source "$SCRIPT_DIRECTORY/srcs/packages/apt.sh" -i
fi

# install npm packages
log_info "$0" "installing npm packages"

missing_npms=()
for pkg in "${npm_pkgs[@]}"; do
  if ! "${RUN[@]}" npm -g ls "$pkg" --depth=0 >/dev/null 2>&1; then
    missing_npms+=("$pkg")
  fi
done
  
if [ "${#missing_npms[@]}" -eq 0 ]; then
  echo "nothing to do"
else
  mkdir -p ~/.npm-global
  "${RUN[@]}" npm config set prefix "$npm_directory"
  "${RUN[@]}" npm i -g --no-fund --no-audit "${missing_npms[@]}"
fi

log_info "$0" "successfully installed npm packages"

# install cargo packages
log_info "$0" "installing cargo packages"

missing_cargos=()
for pkg in "${cargo_pkgs[@]}"; do
  if ! "${RUN[@]}" command -v "$pkg" >/dev/null 2>&1; then
    missing_cargos+=("$pkg")
  fi
done
if [ "${#missing_cargos[@]}" -eq 0 ]; then
  echo "nothing to do"
else
  "${RUN[@]}" cargo install "${missing_cargos[@]}" --locked
fi

log_info "$0" "successfully installed cargo packages"

# nvim
log_info "$0" "installing nvim"

if ! is_nvim; then
  curl -Lo "$SCRIPT_DIRECTORY/nvim.appimage" https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage
  chmod u+x nvim.appimage
  
  mkdir -p ~/.local/bin
  mv nvim.appimage "$HOME/.local/bin/nvim"
fi

log_info "$0" "nvim successfully installed"

# vim-plug
log_info "$0" "installing vim plug"

data_home="${XDG_DATA_HOME:-$HOME/.local/share}"
plug_path="$data_home/nvim/site/autoload/plug.vim"
if [ ! -f "$plug_path" ]; then
  curl -sfLo "$plug_path" --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim >/dev/null
fi
"$HOME/.local/bin/nvim" --headless +'PlugInstall --sync' +qa >/dev/null 2>&1
"$HOME/.local/bin/nvim" --headless +'PlugUpdate --sync' +qa >/dev/null 2>&1

log_info "$0" "vim plug succesfully installed"
