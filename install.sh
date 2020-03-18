#!/usr/bin/env bash
#
# Call this script with optional args "clean" and/or "extras"

# Get the directory where this script lives
DIR="$(cd "$(dirname "$0")" && pwd)"

# Create symbolic link to commands.sh
[[ -L "$HOME/commands.sh" ]] && rm "$HOME/commands.sh"
ln -s "$DIR/commands.sh" "$HOME/commands.sh"

# Set extras var
[[ "$1" == "extras" || "$2" == "extras" ]] && extras=yes

# Remove some directories in $HOME if doing a "clean" install
if [[ "$1" == "clean" || "$2" == "clean" ]]; then
    echo -e "\nDeleting ~/.nvm and ~/.npm"
    rm -rf ~/.nvm ~/.npm 2>/dev/null
    unset NVM_DIR
    if [[ $(uname) != "Darwin" && -d ~/.pyenv ]]; then
        echo -e "\nDeleting ~/.pyenv"
        rm -rf ~/.pyenv
    fi
fi

if [[ -f /usr/bin/apt-get && -n "$(groups | grep sudo)" ]]; then
    echo -e "\nUpdating apt-get package listing"
    sudo apt-get update || exit 1

    echo -e "\nInstalling/upgrading packages needed for pyenv..."
    sudo apt-get install -y make build-essential git wget curl llvm xz-utils libssl-dev zlib1g-dev libbz2-dev
    sudo apt-get install -y libreadline-dev libsqlite3-dev libncurses5-dev libncursesw5-dev libffi-dev liblzma-dev python-openssl

    if [[ -n "$extras" ]]; then
        echo -e "\nInstalling/upgrading other useful CLI packages..."
        sudo apt-get install -y vim zsh tmux htop pmount acpi openssh-server colordiff tree ncdu ranger nmap sqlite3 imagemagick
    fi

    echo -e "\nInstalling ntp and syncing time with server..."
    sudo apt-get install -y ntp
    sudo service ntp stop && sudo ntpd -gq && sudo service ntp start

    echo -e "\nRefreshing Ubuntu keys..."
    sudo apt-key adv --refresh-keys --keyserver keyserver.ubuntu.com

    echo -e "\nInstalling/upgrading docker and docker-compose..."
    sudo apt-get install -y software-properties-common apt-transport-https ca-certificates
    if [[ -z "$(grep docker /etc/apt/sources.list)" ]]; then
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
        sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
        sudo apt-get update
    fi
    sudo apt-get install -y docker-ce
    sudo usermod -aG docker ${USER}
    sudo su -c 'curl -L https://github.com/docker/compose/releases/download/1.25.4/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose'
    sudo chmod +x /usr/local/bin/docker-compose

    # echo -e "\nInstalling/upgrading yarn..."
    # if [[ -z "$(grep yarn -R /etc/apt/sources.list.d)" ]]; then
    #     curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
    #     echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
    #     sudo apt-get update
    # fi
    # sudo apt-get install -y yarn

    if [[ ! -d ~/.pyenv ]]; then
        echo -e "\nInstalling pyenv..."
        git clone https://github.com/pyenv/pyenv.git ~/.pyenv
        export PYENV_ROOT="$HOME/.pyenv"
        export PATH="$PYENV_ROOT/bin:$PATH"
        eval "$(pyenv init -)"
        echo -e "\nInstalling Python 3.8..."
        pyenv install 3.8.0
    fi

    if [[ ! -d ~/.nvm ]]; then
        echo -e "\nInstalling nvm and latest 'long term support' version of node..."
        unset NVM_DIR
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.2/install.sh | bash
        export NVM_DIR="$HOME/.nvm"
        source "$NVM_DIR/nvm.sh"
        nvm install --lts
    fi

    if [[ -n "$extras" ]]; then
        echo -e "\nInstalling Xorg and GUI packages"
        sudo apt-get install -y xserver-xorg-core xserver-xorg-video-intel xserver-xorg-input-kbd xserver-xorg-input-libinput
        sudo apt-get install -y xinit xclip xbindkeys dkms awesome rxvt-unicode-256color feh scrot w3m w3m-img fonts-inconsolata
    fi
elif [[ $(uname) == "Darwin" ]]; then
    if [[ ! -f /usr/local/bin/brew ]]; then
        echo -e "\nInstalling homebrew..."
        /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" || exit 1
    fi

    echo -e "\nGetting the list of packages already installed with brew..."
    _installed=$(brew list -1)
    _brew_install_or_upgrade() {
        for x in "$@"; do
            echo "checking $x"
            if [[ -z "$(echo -e "$_installed" | grep "$x")" ]]; then
                brew install $x
            else
                brew upgrade $x 2>/dev/null
            fi
        done
    }

    echo -e "\nUpdating brew..."
    brew update

    echo -e "\nInstalling/upgrading packages needed for pyenv..."
    _brew_install_or_upgrade readline xz pyenv

    if [[ -n "$extras" ]]; then
        echo -e "\nInstalling/upgrading packages needed for tmux..."
        _brew_install_or_upgrade reattach-to-user-namespace tmux
    fi

    echo -e "\nInstalling/upgrading packages needed for modern bash..."
    _brew_install_or_upgrade bash bash-completion

    # echo -e "\nInstalling/upgrading packages needed for yarn..."
    # _brew_install_or_upgrade yarn

    if [[ -n "$extras" ]]; then
        echo -e "\nInstalling/upgrading other useful CLI packages ..."
        _brew_install_or_upgrade coreutils findutils wget colordiff tree ncdu ranger nmap watch sqlite3
    fi

    if [[ ! -d /Applications/iTerm.app/ ]]; then
        echo -e "\nInstalling iterm2"
        brew cask install iterm2
    fi

    if [[ ! -d /Applications/Docker.app/ ]]; then
        echo -e "\nInstalling docker..."
        brew cask install docker
    fi

    if [[ -z $(grep "/usr/local/bin/bash" /etc/shells) ]]; then
        echo -e "\nAdding new version of bash to /etc/shells"
        sudo sh -c "echo '/usr/local/bin/bash' >> /etc/shells"
    fi
fi
