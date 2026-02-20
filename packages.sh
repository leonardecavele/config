# common package list
common_pkgs=(
  neovim
  tmux
  less
  rust
  xclip
  wl-clipboard
  xsel
  vulkan-tools
  pciutils
  macchina
  which
  tree
  openssh
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
  base-devel
  man-pages
  libxcb
  xcb-util-keysyms
  vulkan-icd-loader
  libbsd
  mesa
  vulkan-swrast
  tree-sitter-cli
  python-pip
  pygmentize
  pyright
)

# dnf package list
dnf_pkgs=(
  python3-flake8
  python3-mypy
  @development-tools
  man-pages
  libxcb
  xcb-util-keysyms
  vulkan-loader
  libbsd
  mesa-dri-drivers
  vulkan-swrast
  tree-sitter
  python3-pip
  python3-pygments
)

# apt package list
apt_pkgs=(
  flake8
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
)

# npm package list
npm_pkgs=(
  pyright
)

# cargo package list
cargo_pkgs=(
)

# binded directories
binded_dirs=(
  "--bind /mnt /mnt"
)
