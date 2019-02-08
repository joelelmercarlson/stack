#!/usr/bin/env bash
#
# setup fonts
#
# Requires: git
# Utilizes fonts from powerline and adobe
#   https://github.com/adobe-fonts/source-code-pro/archive/1.017R.zip
#
set -ex

# uname -v
UBUNTU=$(uname -a|grep -i "Ubuntu"|wc -l)
CENTOS=$(uname -a|grep -i "Centos"|wc -l)
DEBIAN=$(uname -a|grep -i "Debian"|wc -l)

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

cd $HOME

# font cache
fc-cache -f -v

# spacemacs
git clone https://github.com/syl20bnr/spacemacs $HOME/.emacs.d

echo "all done"
