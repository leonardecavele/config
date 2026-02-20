# exports

# stop if not interactive
case $- in
  *i*) ;;
  *) return ;;
esac
[ -t 0 ] || return

# get helpers and options
source "$SCRIPT_DIRECTORY/packages.sh"
source "$SCRIPT_DIRECTORY/srcs/helper.sh"
source "$SCRIPT_DIRECTORY/srcs/custom_commands.sh"

# junest
export PATH="$HOME/.local/share/junest/bin:$PATH"
export PATH="$HOME/.junest/usr/bin_wrappers:$PATH"
export JUNEST_ARGS="$binded_dirs"

# aliases
alias user_env='$SCRIPT_DIRECTORY/install_config.sh'
alias ra='rm a.out'
alias c='cc -Wall -Wextra -Werror'
alias n='norminette -R CheckForbiddenSourceHeader'
alias ll='ls -la'
alias vim='nvim'
alias p='python3'
alias grep_fn='grep -rE "[a-z_]+\([a-z_0-9,\* ]*\)"'

# prompt
shopt -s checkwinsize

PS1="[\$?] ${PROMPT_GREEN}\u@\h ${PROMPT_BLUE}\W${PROMPT_MAGENTA} \$(git_branch)\n${PROMPT_RESET}\$ "

# auto-tmux (only if real terminal)
if ! in_tmux; then
  tmux has-session -t main 2>/dev/null && tmux kill-session -t main
  exec tmux new-session -s main
fi

# macchina
macchina --config ~/.config/macchina/macchina.toml
