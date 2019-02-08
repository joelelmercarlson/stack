# Interactive?
case $- in
  *i*) ;;
  *) return;;
esac

# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

# HISTORY
shopt -s histappend
HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000

# Window
shopt -s checkwinsize

# User specific aliases and functions
export PATH=$HOME/.local/bin:$HOME/.local/go/bin:$PATH
export GOPATH=$HOME/go
export EDITOR=emacs
export VISUAL=emacs
export PAGER='less'

alias ls='ls -FG'
alias more='less'
alias less='less -csM'
alias grep='grep --color=auto'
alias fgrep='grep --color=auto'
alias egrep='grep --color=auto'

set -o vi

# https://github.com/milkbikis/powerline-shell
function _update_ps1() {
  PS1="$($HOME/Library/Python/2.7/bin/powerline-shell $?)"
}

if [ "$TERM" != "linux" ]
then
  PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
else
  PS1="\[\033[01;36;44m\][\u@\h \w]\[\033[00m\]\$ "
fi
