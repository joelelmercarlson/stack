#!/usr/bin/env bash
#
# Utilizes fonts from powerline and adobe
#   https://github.com/adobe-fonts/source-code-pro/archive/1.017R.zip
#source code pro
ADOBEFONT="/tmp/adobefont"
if [ -d $ADOBEFONT ]; then
    rm -fr $ADOBEFONT
fi

if [ ! -d $ADOBEFONT ]; then
    mkdir $ADOBEFONT
fi
cd $ADOBEFONT
cp $HOME/stack/adobefonts/1.017R.zip $ADOBEFONT
unzip 1.017R.zip

FONTS="$HOME/.local/share/fonts"
if [ ! -d $FONTS ]; then
    mkdir $FONTS
fi
cp source-code-pro-1.017R/OTF/*.otf $FONTS

# powerline fonts
cd /tmp
git clone --depth=1 https://github.com/powerline/fonts
cd fonts
./install.sh
