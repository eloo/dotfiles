#!/bin/sh

cd ~
# Update and upgrade distro
sudo apt-get update && sudo apt-get dist-upgrade -y

# Install some basic tools
sudo apt-get install git zsh python-software-properties	 -y
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

#
# Add additional PPA's
#

# IntelliJ IDEA
sudo add-apt-repository ppa:mmk2410/intellij-idea-community

# Sublime Text3
sudo add-apt-repository ppa:webupd8team/sublime-text-3

# Oracle java installer
sudo add-apt-repository ppa:webupd8team/java

sudo apt-get update