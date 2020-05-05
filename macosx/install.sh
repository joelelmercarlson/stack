#!/usr/bin/env bash
#
# setup environment
#
# Requires: git
# Utilizes fonts from powerline and adobe
#   https://github.com/adobe-fonts/source-code-pro/archive/1.017R.zip
#
set -ex

# ~/.local/bin
mkdir -p $HOME/.local/bin

# dotfiles
XS=".bash_profile .gitconfig .powerline-shell.json"
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
git clone --depth 1 https://github.com/syl20bnr/spacemacs $HOME/.emacs.d

# TBD install emacs in ~/Applications/

# source code pro fonts
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

# TBD install fonts in ~/Library/Fonts/

cd $HOME
git clone --depth 1 https://github.com/milkbikis/powerline-shell

cd powerline-shell
python setup.py install --user

cd $HOME
echo "all done"
