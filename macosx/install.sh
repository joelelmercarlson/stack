#!/usr/bin/env bash
#
# setup environment
#
# Requires: git
#
# Starship: https://starship.rs
# Fonts:    https://github.com/adobe-fonts/source-code-pro/archive/1.017R.zip
#
set -ex

# ~/.local/bin
mkdir -p $HOME/.local/bin

# dotfiles
XS=".bash_profile .gitconfig"
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

# spacemacs
# TBD install emacs in ~/Applications/
git clone --depth 1 https://github.com/syl20bnr/spacemacs $HOME/.emacs.d


# source code pro fonts
# TBD install fonts in ~/Library/Fonts/
ADOBEFONT="/tmp/adobefont"
if [ ! -d $ADOBEFONT ]
then
  mkdir $ADOBEFONT
fi
cd $ADOBEFONT

cp $HOME/stack/adobefonts/1.017R.zip $ADOBEFONT
unzip 1.017R.zip

FONTS="$HOME/.fonts"
if [ ! -d $FONTS ]
then
  mkdir $FONTS
fi
cp source-code-pro-1.017R/OTF/*.otf ~/.fonts/

cd $HOME
echo "all done"
