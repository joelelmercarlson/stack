# .zshrc
#
# HISTORY
setopt APPEND_HISTORY
setopt HIST_IGNORE_SPACE
setopt HIST_NO_STORE
setopt HIST_NO_FUNCTIONS
HISTFILE=${ZDOTDIR:-$HOME}/.zsh_history
HISTSIZE=2048
HISTFILESIZE=4096
SAVEHIST=$HITSIZE

alias ls='ls -FG'
alias more='less'
alias less='less -csM'
alias grep='grep --color=auto'
alias fgrep='grep --color=auto'
alias egrep='grep --color=auto'

set -o vi

# brew install starship
eval "$(starship init zsh)"
