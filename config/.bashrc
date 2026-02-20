# variables

# stop if not interactive
case $- in
  *i*) ;;
  *) return ;;
esac
[ -t 0 ] || return

# WSLg: Wayland socket location
if [ -S /mnt/wslg/runtime-dir/wayland-0 ]; then
  export XDG_RUNTIME_DIR=/mnt/wslg/runtime-dir
  export WAYLAND_DISPLAY=wayland-0
fi

# get helper and options
source "$SCRIPT_DIRECTORY/srcs/helper.sh"
source "$SCRIPT_DIRECTORY/options.sh"

# delete reloaded terminal if asked
if [ "${EXIT_JUNEST:-1}" -eq 0 ]; then
  "$SCRIPT_DIRECTORY/main.sh" -r
  unset EXIT_JUNEST
  return 0 2>/dev/null || true
fi

# enter junest if not in junest
if ! in_arch && junest_installed; then
  "$JUNEST" -b "${bind[@]}" -n /usr/bin/bash -i
  return 0 2>/dev/null || true
fi

# aliases
alias ale='$SCRIPT_DIRECTORY/main.sh'
alias options='vim $SCRIPT_DIRECTORY/options.sh'
alias ra='rm a.out'
alias c='cc -Wall -Wextra -Werror'
alias n='norminette -R CheckForbiddenSourceHeader'
alias ll='ls -la'
alias vim='nvim'
alias p='python3'
alias func='grep -rE "[a-z_]+\([a-z_0-9,\* ]*\)"'

# clean old cat
unalias cat 2>/dev/null
unset -f cat 2>/dev/null

# cat -> pygmentize on each file argument
cat() {
  if [ "$#" -eq 0 ]; then
    command cat
    return
  fi

  local f
  for f in "$@"; do
	printf '%b%b|%s|%b\n' "$RESET" "$CYAN" "$f" "$RESET"
    pygmentize -g "$f"
  done
}

# prompt
shopt -s checkwinsize

PS1="[\$?] ${PROMPT_GREEN}\u@\h ${PROMPT_BLUE}\W${PROMPT_MAGENTA} \$(git_branch)\n${PROMPT_RESET}\$ "

# auto-tmux (only if real terminal)
if ! in_tmux && in_arch; then
  tmux has-session -t main 2>/dev/null && tmux kill-session -t main
  exec tmux new-session -s main
fi

# macchina
MACCHINA_SHOWN="/tmp/macchina.$$"
if in_arch && [ ! -e "$MACCHINA_SHOWN" ]; then
  : > "$MACCHINA_SHOWN"
  macchina --config ~/.config/macchina/macchina.toml
fi
