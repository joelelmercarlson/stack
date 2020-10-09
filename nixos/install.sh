#!/usr/bin/env bash
#
# setup environment
#
# Requires: git
set -ex

echo "dotfiles..."
# ~/.local/bin
mkdir -p $HOME/.local/bin

# dotfiles
XS=".zshrc .zshenv .gitconfig"
for i in $XS; do
    cp $i $HOME/
done

echo "software..."
# stack for nix
mkdir $HOME/.stack
cp config.yaml $HOME/.stack

# haskell
$HOME/stack/nixos/haskell.sh

# python3
sudo nix-env -iA nixos.python3

# vim
sudo nix-env -iA nixos.vim

# starship.rs
sudo nix-env -iA nixos.starship

# zsh
sudo nix-env -iA nixos.zsh

echo "all done"
