#!/bin/sh

cd ~
# Update and upgrade distro
sudo apt-get update && sudo apt-get dist-upgrade -y

# Install some basic tools
sudo apt-get install git zsh software-properties-common	-y
chsh -s /bin/zsh

# Download, install and delete powerline fonts
#git clone https://github.com/powerline/fonts.git
#fonts/install.sh
#rm -rf fonts

# Download dotfiles
git clone https://github.com/Eloo/dotfiles.git
echo "source ~/dotfiles/.dotfile" > .zshrc
chmod u+x ~/dotfiles/helpers/install_awesomefonts.sh
~/dotfiles/helpers/install_awesomefonts.sh

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

# Golang PPA
sudo add-apt-repository ppa:gophers/archive

# Atom PPA
sudo add-apt-repository ppa:webupd8team/atom

# Sublime Text3
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list

# Oracle java installer
sudo add-apt-repository ppa:webupd8team/java

sudo apt-get update
