# .zshrc
#
# HISTORY
setopt APPEND_HISTORY
setopt HIST_IGNORE_SPACE
setopt HIST_NO_STORE
setopt HIST_NO_FUNCTIONS
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=2048
export HISTFILESIZE=4096
export SAVEHIST="$HISTSIZE"

alias ls="ls -FG"
alias more="less"
alias less="less -csM"
alias grep="grep --color=auto"
alias fgrep="grep --color=auto"
alias egrep="grep --color=auto"
alias make='gmake'

set -o vi

# homebrew code
PATH="$HOME/.local/bin:$PATH"
export PATH

# brew install pyenv
if command -v pyenv 1>/dev/null 2>&1; then
    eval "$(pyenv init -)"
fi

# brew install starship
eval "$(starship init zsh)"
