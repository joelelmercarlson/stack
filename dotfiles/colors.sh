#!/usr/bin/env bash

for attr in {0..1}
do
  for fg in {30..37}
  do
    for bg in {40..47}
    do
      printf "\033[$attr;${bg};${fg}m$attr;$fg;$bg\033[m "
    done
    echo
  done
done
