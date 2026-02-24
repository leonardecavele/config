# exports

# get helpers and options
source "$SCRIPT_DIRECTORY/packages.sh"
source "$SCRIPT_DIRECTORY/srcs/utils.sh"
source "$SCRIPT_DIRECTORY/srcs/user_commands.sh"
source "$SCRIPT_DIRECTORY/srcs/colors.sh"

# junest
if is_junest; then
  export PATH="$HOME/.local/share/junest/bin:$PATH"
  export PATH="$PATH:$HOME/.junest/usr/bin_wrappers"
  export JUNEST_ARGS="$binded_dirs"
fi

# cargo
export PATH="$HOME/.cargo/bin:$PATH"

# nvim
export PATH="$HOME/.local/bin:$PATH"

# npm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"

# stop if not interactive
case $- in
  *i*) ;;
  *) return ;;
esac
[ -t 0 ] || return

# aliases
alias ue='$SCRIPT_DIRECTORY/install_config.sh'
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

# tmux
#if ! in_tmux; then
#  exec tmux new-session -A -s main
#fi

# macchina
macchina --config ~/.config/macchina/macchina.toml
