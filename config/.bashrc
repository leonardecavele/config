# variables
export JUNEST=/home/leona/.archlinux-env/junest/bin/junest
export JUNEST_REPOSITORY=/home/leona/.archlinux-env/junest
export SCRIPT_DIRECTORY=/home/leona/.archlinux-env

# get logger and utils
source "$SCRIPT_DIRECTORY/srcs/log.sh"
source "$SCRIPT_DIRECTORY/srcs/helper.sh"

# get tmp directory
TTY_ID="$(tty 2>/dev/null || echo notty)"
TMP_DIRECTORY="${XDG_RUNTIME_DIR:-/tmp}"
MACCHINA_SHOWN="$TMP_DIRECTORY/macchina.$(echo "$TTY_ID" | tr '/:' '__')"

# delete reloaded terminal that asked for it
if [ "${EXIT_JUNEST:-1}" -eq 0 ]; then
  "$SCRIPT_DIRECTORY/main.sh" -d
  unset EXIT_JUNEST
  unset MACCHINA_SHOWN
fi

# enter junest if not in junest
if ! in_junest && junest_installed; then
  exec "$JUNEST" -n /usr/bin/bash -i
fi

# if not in junest, set-up junest alias
if junest_installed && ! in_junest; then
  alias junest='$JUNEST'
fi

# aliases
alias ra='rm a.out'
alias c='cc -Wall -Wextra -Werror'
alias n='norminette -R CheckForbiddenSourceHeader'
alias ll='ls -la'
alias vim='nvim'
alias p='python3'






# prompt
shopt -s checkwinsize
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

PROMPT_COMMAND='rc=$?; printf "[%d] " "$rc"'
PS1="${GREEN}\u@\h ${BLUE}\W${MAGENTA} \$(git_branch)\n${RESET}\$ "

unset color_prompt force_color_prompt
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

alias func='grep -rE "[a-z_]+\([a-z_0-9,\* ]*\)"'

# NVM https://github.com/nvm-sh/nvm.git
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"



# macchina
if [ ! -e "$MACCHINA_SHOWN" ]; then
  : > "$MACCHINA_SHOWN"
  macchina --config ~/.config/macchina/macchina.toml
fi

# go to home
cd ~/
