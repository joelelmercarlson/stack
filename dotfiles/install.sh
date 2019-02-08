#!/usr/bin/env bash
#
# setup environment
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

# ~/.local/bin
mkdir -p $HOME/.local/bin

# dotfiles
DOTFILES=".bashrc .twmrc .xsession .Xdefaults .gitconfig .powerline-shell.json"
for i in $DOTFILES
do
  echo $i
  cp $i $HOME/
done
chmod a+x $HOME/.xsession

# xmonad
XMONAD="$HOME/.xmonad"
if [ ! -d $XMONAD ]
then
  mkdir $XMONAD
fi

cp $HOME/stack/dotfiles/xmonad/xmonad.hs         $XMONAD
cp $HOME/stack/dotfiles/xmonad/xmonad-session-rc $XMONAD

# spacemacs
git clone https://github.com/syl20bnr/spacemacs $HOME/.emacs.d

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

# powerline
cd $HOME
git clone https://github.com/Lokaltog/powerline-fonts
cd $HOME/powerline-fonts
./install.sh

cd $HOME
git clone https://github.com/milkbikis/powerline-shell
cd powerline-shell
#sudo yum install python-pip
#sudo pip install setuptools
sudo python setup.py install

cd $HOME
echo "all done"
