#!/bin/zsh

function install_plugins(){

    # Get OS name
    CURRENT_OS=`uname`

    # OS specific plugins
    if [[ $CURRENT_OS == 'Darwin' ]]; then
        install_macos

    elif [[ $CURRENT_OS == 'Linux' ]]; then
        DISTRO=`cat /etc/*-release | grep ^ID=`
        if [[ $DISTRO == *'ubuntu'* || $DISTRO == *'debian'* || $DISTRO == *'raspbian'* ]]; then
            install_debian
        fi
    fi

}

function install_macos(){
    curl -sfL git.io/antibody | sh -s - -b /usr/local/bin
    brew install jump
}

function install_debian(){
    sudo apt install curl
    curl -sfL git.io/antibody | sudo sh -s - -b /usr/local/bin
    
    arch=$(dpkg --print-architecture)
    if [[ $arch == 'amd64' ]]; then     
        wget https://github.com/gsamokovarov/jump/releases/download/v0.40.0/jump_0.40.0_amd64.deb && sudo dpkg -i jump_0.40.0_amd64.deb && rm jump_0.40.0_amd64.deb
    fi
    if [[ $arch == 'armhf' ]]; then 
        wget https://github.com/gsamokovarov/jump/releases/download/v0.40.0/jump_linux_arm_binary && sudo mv jump_linux_arm_binary /usr/bin/jump && chmod +x /usr/bin/jump
    fi
}
