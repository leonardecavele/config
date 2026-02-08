RED=$'\e[0;31m'
YELLOW=$'\e[0;33m'
RESET=$'\e[0m'
BLUE='\[\033[01;34m\]'
GREEN='\[\033[01;32m\]'
MAGENTA='\[\033[01;91m\]'

junest_installed() {
  if [ -d "$JUNEST_REPOSITORY" ]; then
    return 0
  fi
  return 1
}

in_junest() {
  if [ -f /etc/arch-release ] && command -v pacman >/dev/null 2>&1; then
    return 0
  fi
  return 1
}

sudo_pacman_available() {
  if /usr/bin/sudo -n true >/dev/null 2>&1 && command -v pacman >/dev/null 2>&1; then
    return 0
  fi
  return 1
}

exit_junest() {
  printf -v VAR '%q' 0
  if ! grep -qE '^EXIT_JUNEST=' "$SCRIPT_DIRECTORY/config/.bashrc"; then
    sed -i "/^# variables$/a EXIT_JUNEST=$VAR" "$SCRIPT_DIRECTORY/config/.bashrc"
  fi
}

git_branch() {
  branch=$(git symbolic-ref --short HEAD 2>/dev/null)
  if [ -n "$branch" ]; then
    echo "$branch"
  fi
}

export_in_bashrc() {
  [ -n "$1" ] && [ -n "$2" ] || return 1

  printf -v VAR '%q' "$2"
  if ! grep -qE "^export ${1}=" "$SCRIPT_DIRECTORY/config/.bashrc"; then
    sed -i "/^# variables$/a export ${1}=${VAR}" "$SCRIPT_DIRECTORY/config/.bashrc"
  fi
}

log_info() {
  printf '%b|INFO%b %s %b]%b\n' "$YELLOW" "$RESET" "$1" "$YELLOW" "$RESET";
}

log_error()  {
  printf '%b|ERROR%b %s %b]%b\n' "$RED" "$RESET" "$1" "$RED" "$RESET" >&2;
}
