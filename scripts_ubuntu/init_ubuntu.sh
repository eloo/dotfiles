#!/bin/sh

cd ~
# Update and upgrade distro
sudo apt-get update && sudo apt-get dist-upgrade

# Install git and zsh
sudo apt-get install git zsh
chsh -s /bin/zsh

# Download, install and delete powerline fonts
git clone https://github.com/powerline/fonts.git
fonts/install.sh
rm -rf fonts

# Download dotfiles
git clone https://github.com/Eloo/dotfiles.git
echo "source ~/dotfiles/.dotfile" > .zshrc

# Let zsh init itself and update
zsh
antigen-selfupdate
antigen-update
antigen
exit