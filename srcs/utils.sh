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
