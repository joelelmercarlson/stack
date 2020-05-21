#!/usr/bin/env bash

# .local for homebrew
cd $HOME
mkdir -p $HOME/.local

## brew
curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip=1 -C .local

## warn
echo "ctrl-c if you don't want brew to start installs..."

## do something
brew update

## languages and tools
brew install starship
brew install python3
brew install pyenv
brew install git

## install emacs https://github.com/railwaycat/homebrew-emacsmacport
brew tap railwaycat/emacsmacport
brew install emacs-mac

echo "all done"
