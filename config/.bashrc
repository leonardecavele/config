# variables

# get helper and options
source "$SCRIPT_DIRECTORY/srcs/helper.sh"
source "$SCRIPT_DIRECTORY/options.sh"

# delete reloaded terminal if asked
if [ "${EXIT_JUNEST:-1}" -eq 0 ]; then
  "$SCRIPT_DIRECTORY/main.sh" -r
  unset EXIT_JUNEST
fi

# enter junest if not in junest
if ! in_arch && junest_installed; then
  exec "$JUNEST" -b "${bind[@]}" -n /usr/bin/bash -i
fi

# aliases
alias jun='$SCRIPT_DIRECTORY/main.sh'
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

# macchina
TMP_DIRECTORY="${XDG_RUNTIME_DIR:-/tmp}"
MACCHINA_SHOWN="$TMP_DIRECTORY/macchina.$$"
if in_arch && [ ! -e "$MACCHINA_SHOWN" ]; then
  : > "$MACCHINA_SHOWN"
  macchina --config ~/.config/macchina/macchina.toml
fi

# auto-tmux (interactive only)
if [ -z "${TMUX:-}" ] && [ -z "${SSH_TTY:-}" ]; then
  exec tmux new-session -A -s main
fi
