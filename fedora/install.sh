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
XS=".bashrc .gitconfig"
for i in $XS
do
    cp $i $HOME/
done

if [ $SPACE -gt 1000000 ]
then
    # spacemacs
    EMACS="$HOME/.emacs.d"
    if [ ! -d $EMACS ]
    then
        git clone https://github.com/syl20bnr/spacemacs $EMACS
    fi

    # source code pro fonts
    ADOBEFONT="/tmp/adobefont"
    if [ -d $ADOBEFONT ]
    then
        rm -fr $ADOBEFONT
    fi

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

    # font cache
    fc-cache -f -v
fi

# starship.rs
cd $HOME
curl -fsSL https://starship.rs/install.sh | bash

# powerline fonts
cd /tmp
git clone --depth=1 https://github.com/powerline/fonts
cd fonts
./install.sh

cd $HOME
echo "all done"
