#!/usr/bin/env bash

. ~/org/scripts/magic.sh

clear

cd /tmp

if [ ! -d "demo" ]; then
    pe "mkdir demo"
fi

pe "cd demo"
pe "ls -altr"
pe "cal > cal"
pe "cat cal"
pe "echo all done"
p ""

