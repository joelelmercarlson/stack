#!/usr/bin/env bash

export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
export LANGUAGE="en_US.UTF-8"

xrdb -merge ~/.Xdefaults

xset m 3010 4
xset r rate 200 40
xset -b
xset s off
xset -dpms

xsetroot -solid orange

xscreensaver -no-splash &

VM=$(vmware-checkvm|grep -i good|wc -l)
if [ $VM -gt 0 ]
then
  vmtoolsd -n vmusr --blockFd=3&
fi

exec xmonad
