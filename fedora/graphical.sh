#!/usr/bin/env bash
#
# enable GUI
#
set -ex

sudo dnf -y groupinstall "Server with GUI"
sudo dnf -y install tigervnc-viewer
sudo systemctl set-default graphical
