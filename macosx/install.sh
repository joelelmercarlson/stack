#!/usr/bin/env bash
#
# setup environment
#
# Requires: git
#
# Starship: https://starship.rs
# Fonts:    https://github.com/powerline/fonts
#
set -ex

# ~/.local/bin
mkdir -p $HOME/.local/bin

# dotfiles
XS=".bash_profile .gitconfig .spacemacs"
for i in $XS
do
  cp $i $HOME/
done

# utilities
XS="dock.sh emacs haskell.sh brew.sh"
for i in $XS
do
  cp $i $HOME/.local/bin
done

# starship
brew install starship

# spacemacs
# TBD install emacs in ~/Applications/
git clone --depth=1 https://github.com/syl20bnr/spacemacs $HOME/.emacs.d

# powerline fonts for FiraCode mono
cd $HOME
git clone --depth=1 https://github.com/powerline/fonts
cd fonts
./install.sh

cd $HOME
echo "all done"
