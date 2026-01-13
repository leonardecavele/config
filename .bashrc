# colors
RESET="\[\033[00m\]"
BLUE="\[\033[01;34m\]"
GREEN="\[\033[01;32m\]"
MAGENTA="\[\033[01;91m\]"

# func
git_branch() {
  branch=$(git symbolic-ref --short HEAD 2>/dev/null)
  if [ -n "$branch" ]; then
    echo "$branch"
  fi
}

# prompt
PROMPT_COMMAND='rc=$?; printf "[%d] " "$rc"'

# francinette
alias paco=/home/ldecavel/francinette/tester.sh
alias francinette=/home/ldecavel/francinette/tester.sh
alias py='python3'
alias p='python3'

# perso
alias ra='rm a.out'
alias c='cc -Wall -Wextra -Werror'
alias n='norminette -R CheckForbiddenSourceHeader'
alias ll='ls -la'
alias vim='nvim'
alias glow='/sgoinfre/elagouch/Packages/glow/2.1.0/glow'

# bashrc
shopt -s checkwinsize
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	color_prompt=yes
    else
	color_prompt=
    fi
fi

PS1="${GREEN}\u@\h ${BLUE}\W${MAGENTA} \$(git_branch)\n${RESET}\$ "

unset color_prompt force_color_prompt
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

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

export PATH="$HOME/.cargo/bin:$HOME/.local/bin:$PATH"
macchina --config ~/.config/macchina/macchina.toml
