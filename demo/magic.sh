#!/usr/bin/env bash
#
# magic typewriter

set -euo pipefail

# environmentj
TYPE_SPEED=20
PROMPT_TIMEOUT=0
SHOW_CMD_NUMS=true
NO_WAIT=false
C_NUM=0

DEMO_PROMPT="\[\033[01;36;44m\][\u@\h \w]\[\033[00m\]\$ "

# color reference
BLACK="\033[0;30m"
BLUE="\033[0;34m"
GREEN="\033[0;32m"
CYAN="\033[0;36m"
RED="\033[0;31m"
PURPLE="\033[0;35m"
BROWN="\033[0;33m"
WHITE="\033[1;37m"
COLOR_RESET="\033[0m"

function wait() {
    if [[ "$PROMPT_TIMEOUT" = "0" ]]; then
        read -rs
    else
        read -rst "$PROMPT_TIMEOUT"
    fi
}

# print cmdline
function p() {
    cmd=$1

    x=$(PS1="$DEMO_PROMPT" "$BASH" --norc -i </dev/null 2>&1 | sed -n '${s/^\(.*\)exit$/\1/p;}')

    if $SHOW_CMD_NUMS; then
        printf "[$((++C_NUM))] $x"
    else
        printf "$x"
    fi

    if !($NO_WAIT); then
        wait
    fi

    t=$(echo -en "\033[0m$cmd")
    typewriter "$t" .1

    if !($NO_WAIT); then
        wait
    fi
    echo ""
}

# emulate how a typerwriter works
function typewriter
{
    text="$1"
    delay="$2"

    for ((i = 0; i < ${#text}; i++)); do
        echo -n "${text:$i:1}"
        sleep ${delay}
    done
}

# print and eval cmdline
function pe() {
    p "$@"

    eval "$@"
}
