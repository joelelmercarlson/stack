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

echo "dotfiles..."
# macOS 10.15 Catalina zsh
XS=".zshrc .zshenv .gitconfig .spacemacs"
for i in $XS
do
  cp $i $HOME/
done

echo "scripts...."
XS="dock.sh emacs brew.sh"
for i in $XS
do
  cp $i $HOME/.local/bin
done

echo "Software..."
#
# starship, pyenv and emacs are in .zshrc
#
# starship, pyenv, spacemacs
brew install starship
brew install pyenv
git clone --depth=1 https://github.com/syl20bnr/spacemacs $HOME/.emacs.d

echo "Fonts...."
# powerline fonts
cd /tmp
git clone --depth=1 https://github.com/powerline/fonts
cd fonts
./install.sh

cd $HOME
echo "all done"
