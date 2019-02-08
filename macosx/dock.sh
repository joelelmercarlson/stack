#!/usr/bin/env bash
#
# dock size and settings
#
defaults write com.apple.dock tilesize -int 48
defaults write com.apple.dock autohide -int 0
defaults write com.apple.dock launchanim -int 0
defaults write com.apple.dock mineffect -string scale
defaults write com.apple.dock "minimize-to-application" -int 0
defaults write com.apple.dock orientation -string bottom
defaults write com.apple.dock "show-process-indicators" -int 1
killall Dock
