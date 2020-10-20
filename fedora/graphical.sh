#!/usr/bin/env bash
#
# enable GUI
#
set -ex

sudo dnf -y groupinstall "Server with GUI"
sudo systemctl set-default graphical
