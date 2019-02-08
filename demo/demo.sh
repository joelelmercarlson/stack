#!/usr/bin/env bash

. ~/stack/demo/magic.sh

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

