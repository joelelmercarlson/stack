#!/usr/bin/env bash
#
# setup environment
#
# Requires: git
#
# Starship: https://starship.rs
# Pyenv:    https://github.com/pyenv/pyenv
# Fonts:    https://github.com/powerline/fonts
#
set -ex

# ~/.local/bin
mkdir -p $HOME/.local/bin

# dotfiles
#
# macOS 10.15 Catalina zsh
XS=".zshrc .zshenv .gitconfig .spacemacs"
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

# pyenv
brew install pyenv

# spacemacs
git clone --depth=1 https://github.com/syl20bnr/spacemacs $HOME/.emacs.d

# powerline fonts
cd /tmp
git clone --depth=1 https://github.com/powerline/fonts
cd fonts
./install.sh

cd $HOME
echo "all done"
