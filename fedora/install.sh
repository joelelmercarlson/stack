#!/usr/bin/env bash
#
# setup environment
#
# Requires: git
# Utilizes fonts from powerline and adobe
#   https://github.com/adobe-fonts/source-code-pro/archive/1.017R.zip
#
set -ex

# SPACE
SPACE=$(df /home |awk '/\//{print $4}')

# ~/.local/bin
mkdir -p $HOME/.local/bin

# dotfiles
XS=".zshrc .zshenv .gitconfig"
for i in $XS; do
    cp $i $HOME/
done

# spacemacs
if [ $SPACE -gt 1000000 ]; then
    EMACS="$HOME/.emacs.d"
    if [ ! -d $EMACS ]; then
        git clone https://github.com/syl20bnr/spacemacs $EMACS
    fi
fi

# starship.rs
cd $HOME
curl -fsSL https://starship.rs/install.sh | bash

# pyenv
git clone --depth=1 https://github.com/pyenv/pyenv.git ~/.pyenv

cd $HOME
echo "all done"
