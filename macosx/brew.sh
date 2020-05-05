#!/usr/bin/env bash

# .local
mkdir -p ~/.local
cd ~/.local

## brew
mkdir homebrew
curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C homebrew

## warn
echo "ctrl-c if you don't want brew to start installs..."

## do something
brew update

## languages and tools
brew install python3
brew install git

## install emacs https://github.com/railwaycat/homebrew-emacsmacport
brew tap railwaycat/emacsmacport
brew install emacs-mac

echo "all done"
