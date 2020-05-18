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
XS=".bashrc .gitconfig .powerline-shell.json"
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

    # powerline
    cd $HOME
    if [ ! -d powerline-fonts ]
    then
        git clone https://github.com/Lokaltog/powerline-fonts
    fi
    cd powerline-fonts
    ./install.sh
fi

cd $HOME
if [ ! -d powerline-shell ]
then
    git clone https://github.com/milkbikis/powerline-shell
fi
cd powerline-shell

VERSION=$(python3 --version|awk '{print $2}'|awk -F. '{print $1 "." $2}')
SITE="/usr/local/lib/python${VERSION}/site-packages"
if [ ! -d $SITE ]
then
  sudo mkdir -p $SITE
fi
sudo python3 setup.py install

cd $HOME
echo "all done"
