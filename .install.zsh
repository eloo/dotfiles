#!/bin/zsh

function install_plugins(){

    # Get OS name
    CURRENT_OS=`uname`

    # OS specific plugins
    if [[ $CURRENT_OS == 'Darwin' ]]; then
        install_macos

    elif [[ $CURRENT_OS == 'Linux' ]]; then
        DISTRO=$(bash -c 'cat /etc/*-release | grep ^ID=')
        if [[ $DISTRO == *'ubuntu'* || $DISTRO == *'debian'* || $DISTRO == *'raspbian'* ]]; then
            install_debian
        fi
    fi

    git clone --depth=1 https://github.com/mattmc3/antidote.git ${ZDOTDIR:-~}/.antidote

    python -m ensurepip --upgrade

    pip3 install install-release
    install-release config --path ~/.local/bin
    install-release get https://github.com/gsamokovarov/jump -y

    curl https://zyedidia.github.io/eget.sh | sh
    mv eget ~/.local/bin
    eget gsamokovarov/jump


    ZSH= sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

    if grep -Fxq "source ~/dotfiles/.dotfile" ~/.zshrc
    then
        # code if found
    else
       echo "source ~/dotfiles/.dotfile" >> ~/.zshrc
    fi

}

function install_macos(){
    git clone --depth=1 https://github.com/mattmc3/antidote.git ${ZDOTDIR:-~}/.antidote
}

function install_debian(){
    sudo apt install curl python3-pip
    git clone --depth=1 https://github.com/mattmc3/antidote.git ${ZDOTDIR:-~}/.antidote
}

