is_junest() {
  if command -v junest >/dev/null 2>&1 \
  && junest --version >/dev/null 2>&1
}

is_pacman() {
  command -v pacman >/dev/null 2>&1
}

is_dnf() {
  command -v dnf >/dev/null 2>&1
}

is_apt() {
  command -v apt >/dev/null 2>&1
}

is_sudo() {
  /usr/bin/sudo -n true >/dev/null 2>&1
}

has_junest_repository() {
  [ -d "$JUNEST_REPOSITORY" ]
}

export_in_bashrc() {
  [ -n "$1" ] && [ -n "$2" ] || return 1

  printf -v VAR '%q' "$2"
  if ! grep -qE "^export ${1}=" "$SCRIPT_DIRECTORY/config/.bashrc"; then
    sed -i "/^# exports$/a export ${1}=${VAR}" "$SCRIPT_DIRECTORY/config/.bashrc"
  fi
}

clean_bashrc_exports() {
  perl -0777 -i -pe 's/^# exports[ \t]*\R.*?(?=^#)/# exports\n\n/sm'
}

log_info() {
  printf '%b[%s]: (info)%b %s\n' "$YELLOW" "$1" "$RESET" "$2";
}

log_error()  {
  printf '%b[%s]: (error)%b %s\n' "$RED" "$1" "$RESET" "$2";
}

usage() { # to do
  cat <<'EOF'
Usage: main.sh [OPTION]

Options:
  -s    Set up JuNest (if needed) and install/update packages
  -u    Uninstall downloaded packages
  -r    Remove JuNest and its packages
  -h    Show this help and exit

Examples:
  main.sh -s
  main.sh -u
  main.sh -r
EOF
}

git_branch() {
  branch=$(git symbolic-ref --short HEAD 2>/dev/null)
  if [ -n "$branch" ]; then
    echo "$branch"
  fi
}

in_tmux() {
  [ -n "${TMUX:-}" ] || [ "${TERM:-}" = "screen" ] || [ "${TERM:-}" = "screen-256color" ] \
    || [ "${TERM:-}" = "tmux" ] || [ "${TERM:-}" = "tmux-256color" ]
}
