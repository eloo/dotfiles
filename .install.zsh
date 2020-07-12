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
    arch=$(dpkg --print-architecture)
    if [[ $arch == "amd64"]]; then 
        curl -sfL git.io/antibody | sudo sh -s - -b /usr/local/bin
        wget https://github.com/gsamokovarov/jump/releases/download/v0.30.1/jump_0.30.1_amd64.deb && sudo dpkg -i jump_0.30.1_amd64.deb && rm jump_0.30.1_amd64.deb
    fi
}