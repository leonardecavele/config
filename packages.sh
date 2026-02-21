# common package list
common_pkgs=(
  tmux
  less
  xclip
  wl-clipboard
  xsel
  vulkan-tools
  pciutils
  which
  tree
  nodejs
  npm
  curl
  git
  tar
  gzip
  wget
)

# pacman package list
pacman_pkgs=(
  flake8
  mypy
  openssh
  base-devel
  man-pages
  libxcb
  xcb-util-keysyms
  vulkan-icd-loader
  libbsd
  mesa
  rust
  vulkan-swrast
  neovim
  tree-sitter-cli
  python-pip
  pygmentize
  pyright
)
pacman_pkgs+=("${common_pkgs[@]}")

# dnf package list
dnf_pkgs=(
  python3-flake8
  python3-mypy
  @development-tools
  man-pages
  libxcb
  openssh-client
  openssh-server
  xcb-util-keysyms
  vulkan-loader
  libbsd
  rustc
  mesa-dri-drivers
  vulkan-swrast
  tree-sitter
  python3-pip
  python3-pygments
)
dnf_pkgs+=("${common_pkgs[@]}")

# apt package list
apt_pkgs=(
  flake8
  rustc
  mypy
  build-essential
  manpages
  libxcb1
  libxcb-keysyms1
  libvulkan1
  libbsd0
  mesa-utils
  tree-sitter-cli
  openssh-client
  python3-pip
  python3-pygments
  python3-venv
  python3-full
  openssh-client
  openssh-server
)
apt_pkgs+=("${common_pkgs[@]}")

# npm package list
npm_pkgs=(
  pyright
)

npm_directory=$HOME/.npm-global

# cargo package list
cargo_pkgs=(
  macchina
)

# binded directories
binded_dirs=(
  "--bind /mnt /mnt"
)
