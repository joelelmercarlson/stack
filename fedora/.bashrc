# stack/dotfiles/.bashrc

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
export PATH=$HOME/.local/bin:$HOME/.local/go/bin:$HOME/go/bin:$PATH
export GOPATH=$HOME/go
export EDITOR=emacs
export VISUAL=emacs
export PAGER='less'

alias more='less'
alias less='less -csM'
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='grep --color=auto'
alias egrep='grep --color=auto'

set -o vi

eval "$(starship init bash)"
