#!/usr/bin/env bash
#
# setup environment
#
# Requires: git
#
set -ex

# ~/.local/bin
mkdir -p $HOME/.local/bin

# dotfiles
XS=".zshrc .zshenv .gitconfig"
for i in $XS; do
    cp $i $HOME/
done

EMACS="$HOME/.emacs.d"
if [ ! -d $EMACS ]; then
    git clone https://github.com/syl20bnr/spacemacs $EMACS
fi

# starship.rs
cd $HOME
curl -fsSL https://starship.rs/install.sh | bash

cd $HOME
echo "all done"
