#!/bin/zsh

if [[ ${DEBUG_ZSH} ]]; then
    echo "[$(date +%H:%M:%S.%3N)] Loading install dotfile configuration..."
fi

function install_plugins(){

    # Get OS name
    CURRENT_OS=`uname`

    install_eget
    
    eget gsamokovarov/jump
    eget junegunn/fzf

    # OS specific plugins
    if [[ $CURRENT_OS == 'Darwin' ]]; then
        install_macos

    elif [[ $CURRENT_OS == 'Linux' ]]; then
        DISTRO=$(bash -c 'cat /etc/*-release | grep -a ^ID=')
        if [[ $DISTRO == *'ubuntu'* || $DISTRO == *'debian'* || $DISTRO == *'raspbian'* ]]; then
            install_debian
        fi
        if [[ $DISTRO == *'arch'* || $DISTRO == *'manjaro'* ]]; then
            install_arch
        fi
    fi

    if [[ -d "${ZDOTDIR:-$HOME}/.antidote" ]]; then
        echo "Antidote is already installed."
    else
        git clone --depth=1 https://github.com/mattmc3/antidote.git ${ZDOTDIR:-~}/.antidote
    fi

    install-release config --path ~/.local/bin

    # ZSH= sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

    if grep -Fxq "source ~/dotfiles/.dotfile" ~/.zshrc
    then
        # code if found
    else
        echo "source ~/dotfiles/.dotfile" >> ~/.zshrc
    fi
}

function install_eget(){
    mkdir -p ~/.local/bin
    curl https://zyedidia.github.io/eget.sh | sh
    mv eget ~/.local/bin/eget
}

function install_macos(){
    brew install pipx python-setuptools
    pipx install install-release
}

function install_debian(){
    sudo apt install -y curl python3-pip pipx
    sudo apt update
    pipx ensurepath
    sudo pipx ensurepath --global # optional to allow pipx actions with --global argument
    eget Rishang/install-release
}

function install_arch(){
    sudo pacman -S python-pipx
    pipx ensurepath
    sudo pipx ensurepath --global # optional to allow pipx actions with --global argument
    eget Rishang/install-release
}

