#!/usr/bin/env bash
#
# setup environment
#
# Requires: git
# Utilizes fonts from powerline and adobe
#   https://github.com/adobe-fonts/source-code-pro/archive/1.017R.zip
#
set -ex

cd $HOME

# ~/.local/bin
mkdir -p $HOME/.local/bin

# dotfiles
DOTFILES=".bash_profile .gitconfig .powerline-shell.json"
for i in $DOTFILES
do
  echo $i
  cp $i $HOME/
done

# spacemacs
git clone https://github.com/syl20bnr/spacemacs $HOME/.emacs.d

# TBD install emacs

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

# TBD install fonts in finder

cd $HOME
git clone https://github.com/milkbikis/powerline-shell
cd powerline-shell
python setup.py install --user

cd $HOME
echo "all done"
