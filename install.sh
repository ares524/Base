# Source this script with optional args "clean", "extras" and/or "gui"

# Create symbolic link to commands.sh and bin/
[[ -L "$HOME/commands.sh" ]] && rm "$HOME/commands.sh"
[[ -L "$HOME/commands.fish" ]] && rm "$HOME/commands.fish"
[[ -L "$HOME/bin-base" ]] && rm "$HOME/bin-base"
[[ -f ./commands.sh ]] && ln -s "$(pwd)/commands.sh" "$HOME/commands.sh"
[[ -f ./commands.fish ]] && ln -s "$(pwd)/commands.fish" "$HOME/commands.fish"
[[ -d ./bin ]] && ln -s "$(pwd)/bin" "$HOME/bin-base"

# Set clean, extras, and gui vars
[[ "$1" == "clean" || "$2" == "clean" || "$3" == "clean" ]] && clean=clean
[[ "$1" == "extras" || "$2" == "extras" || "$3" == "extras" ]] && extras=yes
[[ "$1" == "gui" || "$2" == "gui" || "$3" == "gui" ]] && gui=yes

# Determine if using Windows Subsystem for Linux
[[ -n "$(echo $PATH | grep -E '(WINDOWS|Program Files)')" ]] && wsl=yes

do_install() {
    if [[ -f /usr/bin/apt-get && -n "$(groups | grep -E '(sudo|root)')" ]]; then
        echo -e "\nUpdating apt-get package listing"
        sudo apt-get update || return 1

        echo -e "\nInstalling/upgrading packages needed for pyenv..."
        sudo apt-get install -y make build-essential git wget curl llvm xz-utils libssl-dev zlib1g-dev libbz2-dev
        sudo apt-get install -y libreadline-dev libsqlite3-dev libncurses5-dev libncursesw5-dev libffi-dev liblzma-dev python-openssl

        if [[ -n "$extras" ]]; then
            echo -e "\nInstalling/upgrading other useful CLI packages..."
            sudo apt-get install -y vim zsh zsh-syntax-highlighting fish tmux htop glances pmount acpi dkms openssh-server colordiff tree ncdu ranger nnn w3m w3m-img nmap mtr sqlite3 imagemagick
        fi

        echo -e "\nInstalling ntp..."
        sudo apt-get install -y ntp

        echo -e "\nRefreshing Ubuntu keys..."
        sudo apt-key adv --refresh-keys --keyserver keyserver.ubuntu.com

        if [[ -z "$wsl" ]]; then
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
        fi

        # echo -e "\nInstalling/upgrading yarn..."
        # if [[ -z "$(grep yarn -R /etc/apt/sources.list.d)" ]]; then
        #     curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
        #     echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
        #     sudo apt-get update
        # fi
        # sudo apt-get install -y yarn

        if [[ -n "$gui" ]]; then
            if [[ -z "$wsl" ]]; then
                echo -e "\nInstalling Xorg..."
                sudo apt-get install -y xserver-xorg-core xserver-xorg-video-intel xserver-xorg-input-kbd xserver-xorg-input-libinput
            fi
            echo -e "\nInstalling GUI packages..."
            sudo apt-get install -y xinit xclip xbindkeys awesome rxvt-unicode-256color feh scrot fonts-inconsolata
        fi
    elif [[ $(uname) == "Darwin" ]]; then
        if [[ ! -f /usr/local/bin/brew ]]; then
            echo -e "\nInstalling homebrew..."
            /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" || return 1
        elif [[ ! -w /usr/local/Cellar ]]; then
            echo -e "\nNot attempting to install/upgrade packages with brew..."
            return
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
        brew update || return 1

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
            _brew_install_or_upgrade coreutils findutils grep wget watch vim zsh-syntax-highlighting fish htop glances pstree openssh colordiff tree ncdu ranger nnn w3m nmap mtr sqlite3 imagemagick
        fi

        if [[ -n "$gui" ]]; then
            if [[ ! -d /Applications/iTerm.app/ ]]; then
                echo -e "\nInstalling iterm2"
                brew cask install iterm2
            fi

            if [[ ! -d /Applications/VLC.app/ ]]; then
                echo -e "\nInstalling vlc"
                brew cask install vlc
            fi
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
}

do_install
parent_pid=$(ps -o ppid= $$)
if ps | grep "^$parent_pid" | grep 'fish$'; then
    # Parent PID is fish shell
    [[ -s "$HOME/commands.fish" ]] && echo -e "Install complete! Be sure to run the following...\n\n    source $HOME/commands.fish"
else
    # The install.sh was sourced by bash or zsh
    [[ -s "$HOME/commands.sh" ]] && source "$HOME/commands.sh" || return
    [[ "$clean" == "clean" ]] && get-completions clean
fi
