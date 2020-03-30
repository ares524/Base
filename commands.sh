# Source this file

# Add aliases for ..
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

cdd() { mkdir -p "$1" && cd "$1" && pwd; }

if [[ $(uname) == "Darwin" ]]; then
    alias dfh="df -lPh"
    alias p="ps aux | egrep -v '(^_|^root)'"
else
    alias dfh="df -Th --total | egrep -v '(^none|^udev|^tmpfs|^cgmfs)'"
    alias p="ps -eo user,pid,ppid,tty,cmd:200 | grep -v ' \['"
fi

# Use GNU find, sort, and xargs if on a Mac
if [[ $(uname) == "Darwin" ]]; then
    if type gfind &>/dev/null; then
        alias find=gfind
    fi
    if type gsort &>/dev/null; then
        alias sort=gsort
    fi
    if type gxargs &>/dev/null; then
        alias xargs=gxargs
    fi
fi

if [[ $(find . -maxdepth 1 -type f -executable &>/dev/null; echo $?) -eq 0 ]]; then
    find_executables=yes
fi

#################### bash/zsh setup ####################

if [[ -n "$BASH_VERSION" ]]; then
    # Enable tab-completion
    if [[ -f /etc/bash_completion ]]; then
        source /etc/bash_completion
    elif [[ -f /usr/local/etc/bash_completion ]]; then
        source /usr/local/etc/bash_completion
    else
        fname=$(brew --prefix 2>/dev/null)/etc/bash_completion
        [[ -f "$fname" ]] && source "$fname"
    fi

    # Tab-completion for SSH
    _complete_ssh_hosts ()
    {
        COMPREPLY=()
        cur="${COMP_WORDS[COMP_CWORD]}"
        comp_ssh_hosts=`cat ~/.ssh/known_hosts 2>/dev/null | \
            egrep -v '^(\||\[|#)' | \
            cut -f 1 -d ' ' | \
            cut -f 1 -d ',' | \
            grep -v ':' | \
            uniq ;
        cat ~/.ssh/config 2>/dev/null | \
            grep "^Host " | \
            awk '{print $2}'`
        COMPREPLY=( $(compgen -W "${comp_ssh_hosts}" -- $cur))
        return 0
    }
    complete -F _complete_ssh_hosts ssh

    # Use vi keybindings to navigate command line
    set -o vi

    # Append to history file instead of overwriting
    shopt -s histappend

    # Don't add duplicate lines, or lines starting with a space to the history file
    HISTCONTROL=ignoreboth

    # Set number of commands stored in memory and in the history file
    HISTSIZE=50000
    HISTFILESIZE=50000
    HISTFILE=$HOME/.history_bash

    # Update values of LINES and COLUMNS after window resize
    shopt -s checkwinsize

    # Use '**' in pathname expansions like in ZSH
    shopt -s globstar
elif [[ -n "$ZSH_VERSION" ]]; then
    # Set tab completion and matching options
    zstyle ':completion:*' completer _expand _complete _ignored _approximate
    zstyle ':completion:*' matcher-list '' 'm:{[:lower:]}={[:upper:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|[._-]=** r:|=**'
    zstyle ':completion:*' rehash true
    autoload -Uz compinit
    compinit -i

    # Set number of commands stored in memory and in the history file
    HISTSIZE=50000
    SAVEHIST=50000
    HISTFILE=$HOME/.history_zsh

    # Enable bash-style comments at command line and extended zsh globbing
    setopt interactivecomments extendedglob

    # Disable reporting an error when filename glob has no matches
    setopt null_glob

    # Use vi keybindings to navigate command line
    bindkey -v

    # Append to history file and save command's beginning timestamp/duration
    setopt appendhistory extendedhistory

    # Don't add duplicate lines, or lines starting with a space to the history file
    setopt histignoredups histignorespace

    # Search through command history with ^r like bash (in vi insert mode)
    bindkey -M viins '^R' history-incremental-search-backward
    bindkey -M viins '^S' history-incremental-search-forward

    # Search through command history with vi search keys (in vi command mode)
    bindkey -M vicmd '?' history-incremental-pattern-search-backward
    bindkey -M vicmd '/' history-incremental-pattern-search-forward
fi

#################### completions ####################

bash_completion_dir="$(brew --prefix 2>/dev/null)/etc/bash_completion.d"
bash_completion_file="$(dirname $bash_completion_dir)/bash_completion"
if [[ $(uname) != "Darwin" && -z "$(groups | grep sudo)" ]]; then
    bash_completion_dir="$HOME/.downloaded-completions"
    mkdir -p "$bash_completion_dir" 2>/dev/null
    bash_completion_file="$HOME/.bash_completion"
fi

_get_zsh_custom_fpath() {
    [[ -z "$ZSH_VERSION" ]] && return

    # Determine if there is a custom dir in $fpath already, or make $HOME/.zsh/completions
    custom_fpaths=()
    for some_path in "${fpath[@]}"; do
        if [[ "${some_path:0:11}" != "/usr/local/" && "${some_path:0:11}" != "/usr/share/" ]]; then
            custom_fpaths+=("$some_path")
        fi
    done
    if [[ -n "$custom_fpaths" ]]; then
        custom_fpath="${custom_fpaths[1]}"
    else
        custom_fpath="$HOME/.zsh/completion"
    fi
    if [[ ! -d "$custom_fpath" ]]; then
        echo -e "\n$ mkdir -pv $custom_fpath"
        mkdir -pv "$custom_fpath"
    fi
    echo "$custom_fpath"
}

# Make sure bash/zsh (tab) completions are enabled for git, docker, & docker-compose
get-completions() {
    custom_fpath="$(_get_zsh_custom_fpath)"
    [[ -z "$custom_fpath" ]] && custom_fpath="$HOME/.zsh/completion"

    if [[ "$1" == "clean" ]]; then
        if [[ ! "$bash_completion_dir" =~ ${HOME}.* ]]; then
            if [[ -n "$(groups | grep -E '(sudo|admin)')" ]]; then
                echo -e "\nDeleting from $bash_completion_dir: docker, docker-compose, git-completion.bash"
                sudo rm -f $bash_completion_dir/docker $bash_completion_dir/docker-compose $bash_completion_dir/git-completion.bash 2>/dev/null
            fi
        else
            echo -e "\nDeleting from $bash_completion_dir: docker, docker-compose, git-completion.bash"
            rm -f $bash_completion_dir/docker $bash_completion_dir/docker-compose $bash_completion_dir/git-completion.bash 2>/dev/null
        fi

        echo -e "\nDeleting from $custom_fpath: _docker, _docker-compose, git-completion.zsh"
        rm -f "$custom_fpath/_docker" "$custom_fpath/_docker-compose" "$custom_fpath/git-completion.zsh" 2>/dev/null
    fi

    git_version=$(git --version 2>/dev/null | perl -pe 's/^git version (\S+).*$/$1/')
    docker_version=$(docker --version 2>/dev/null | perl -pe 's/^Docker version (\S+),.*/$1/')
    docker_compose_version=$(docker-compose --version 2>/dev/null | perl -pe 's/^docker-compose version (\S+),.*/$1/')
    zsh_urls=()
    bash_urls=()
    if [[ -n "$git_version" ]]; then
        zsh_urls+=(https://raw.githubusercontent.com/git/git/v$git_version/contrib/completion/git-completion.zsh)
        bash_urls+=(https://raw.githubusercontent.com/git/git/v$git_version/contrib/completion/git-completion.bash)
    fi
    if [[ -n "$docker_version" ]]; then
        zsh_urls+=(https://raw.githubusercontent.com/docker/cli/v$docker_version/contrib/completion/zsh/_docker)
        bash_urls+=(https://raw.githubusercontent.com/docker/cli/v$docker_version/contrib/completion/bash/docker)
    fi
    if [[ -n "$docker_compose_version" ]]; then
        zsh_urls+=(https://raw.githubusercontent.com/docker/compose/$docker_compose_version/contrib/completion/zsh/_docker-compose)
        bash_urls+=(https://raw.githubusercontent.com/docker/compose/$docker_compose_version/contrib/completion/bash/docker-compose)
    fi
    if [[ -n "$ZSH_VERSION" ]]; then
        # Copy the completion files
        for url in "${zsh_urls[@]}"; do
            fname=$(basename "$url")
            if [[ ! -f ${custom_fpath}/$fname ]]; then
                echo -e "\n$ curl -L $url > ${custom_fpath}/$fname"
                curl -L "$url" > "${custom_fpath}/$fname" || return 1
            fi
        done
    elif [[ -n "$BASH_VERSION" ]]; then
        # Make sure bash-completion package is installed
        if [[ $(uname) == "Darwin" ]]; then
            if ! type brew &>/dev/null; then
                echo -e "\nHomebrew not found"
                return 1
            fi
            brew_completions=$(brew list bash-completion 2>/dev/null)
            if [[ -z "$brew_completions" ]]; then
                echo -e "\n$ brew install bash-completion"
                brew install bash-completion || return 1
            fi
        elif [[ -f /usr/bin/apt-get && -n "$(groups | grep sudo)" ]]; then
            echo -e "\n$ sudo apt-get install -y bash-completion"
            sudo apt-get install -y bash-completion
        fi
        # Copy the completion files
        if [[ "$bash_completion_dir" =~ ${HOME}.* ]]; then
            for url in "${bash_urls[@]}"; do
                fname=$(basename "$url")
                if [[ ! -f $bash_completion_dir/$fname ]]; then
                    echo -e "\n$ curl -L $url > \"$bash_completion_dir/$fname\""
                    curl -L $url > "$bash_completion_dir/$fname" || return 1
                fi
            done
            cat "$bash_completion_dir"/* > "$bash_completion_file"
        else
            for url in "${bash_urls[@]}"; do
                fname=$(basename "$url")
                if [[ ! -f $bash_completion_dir/$fname ]]; then
                    echo -e "\n$ sudo sh -c \"curl -L $url > $bash_completion_dir/$fname\""
                    sudo sh -c "curl -L $url > $bash_completion_dir/$fname" || return 1
                fi
            done
        fi
    fi
}

custom_fpath="$(_get_zsh_custom_fpath)"
if [[ -n "$BASH_VERSION" ]]; then
    [[ ! -f $bash_completion_dir/docker ]] && get-completions
    source "$bash_completion_file"
elif [[ -n "$ZSH_VERSION" ]]; then
    [[ ! -f "$custom_fpath/_docker" ]] && get-completions
    [[ -z "$(echo ${fpath[@]} | grep $custom_fpath)" ]] && fpath=($custom_fpath $fpath)
    compinit -i
fi

#################### compgen ####################

if type compgen &>/dev/null; then
    funcs-list() {
        compgen -A function | grep -v -E '(^_|nvm_)' | LL_COLLATE=c sort | less -FX
    }

    funcs-list-all() {
        compgen -A function | LL_COLLATE=c sort | less -FX
    }

    funcs-list-hidden() {
        compgen -A function | grep '^_' | LL_COLLATE=c sort | less -FX
    }
fi

#################### crontab ####################

crontab-active() {
    crontab -l | grep -vE '(^#|^$)'
}

#################### curl ####################

if type curl &>/dev/null; then
    weather-now() {
        location=$1
        # See https://github.com/chubin/wttr.in#one-line-output for output options
        curl "https://wttr.in/${location}?format='%c+%C+%t+%w+%p'"
    }

    weather-forecast() {
        location=$1
        curl "https://wttr.in/${location}"
    }
fi

#################### dig ####################

if type dig &>/dev/null; then
    dig-short() {
        dig $@ ANY +noall +answer
    }
fi

#################### /etc ####################

etc-group() {
    grep -vE '(^#|:$)' /etc/group
}

etc-passwd() {
    grep -vE '(^#|nologin$|false$)' /etc/passwd
}

#################### feh ####################

if type feh &>/dev/null; then
    alias feh="feh -x --scale-down"
    alias fehf="feh -F --zoom max"
fi

#################### git ####################

if type git &>/dev/null; then
    git-merge-in() {
        localbranch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
        if [[ -z "$localbranch" ]]; then
            echo "Not currently in a git repo."
            return 1
        fi

        branch="${1:-master}"
        [[ ! "$branch" =~ origin.* ]] && branch="origin/$branch"

        stashstatus=$(git stash)
        if [[ "$stashstatus" = "No local changes to save" ]]; then
            echo " - Repository is clean.. going to pull from $localbranch, then merge $branch'"
            git pull --rebase
            git merge $branch
        else
            echo " - Dirty repo.. going to stash local changes, pull from $localbranch, merge $branch, then re-apply local changes"
            echo "$stashstatus"
            git pull --rebase
            git merge $branch
            git stash pop
        fi

        conflicts=$(git status -s | grep '^UU')
        if [[ -n "$conflicts" ]]; then
            echo -e "\n\nThere are some merge conflicts!!\n$conflicts"
            if [[ "$stashstatus" != "No local changes to save" ]]; then
                echo -e "\nAfter fixing merge conflicts, run 'git stash pop' to re-apply your changes"
            fi
        fi
    }
fi

#################### grepit ####################

grepit() {
    [[ -z "$@" ]] && return 1
    grep -HnI --color -R --exclude=\*.{pyc,swp,min.js,svg,png,jpg,jpeg,ttf,pdf,doc,xlsx,otf,mp3} --exclude-dir=.git --exclude-dir=venv --exclude-dir=env --exclude-dir=node_modules --exclude-dir=dist --exclude-dir=build --exclude-dir=.cache --exclude-dir=.eggs --exclude-dir=\*.egg-info --exclude-dir=__pycache__ --exclude-dir=.pytest_cache "$@" \.
}

grepit-count() {
    grepit -c "$@" | grep -v '0$' | sort -nr -k2,2 -t ':' | less -FX
}

grepit-py() {
    [[ -z "$@" ]] && return 1
    grep -HnI --color -R --include=\*.py --exclude-dir=venv --exclude-dir=env --exclude-dir=node_modules --exclude-dir=dist --exclude-dir=build --exclude-dir=.cache --exclude-dir=.eggs --exclude-dir=\*.egg-info --exclude-dir=__pycache__ --exclude-dir=.pytest_cache "$@" \.
}

grepit-py-no-tests() {
    [[ -z "$@" ]] && return 1
    grep -HnI --color -R --include=\*.py --exclude-dir=venv --exclude-dir=env --exclude-dir=node_modules --exclude-dir=dist --exclude-dir=build --exclude-dir=.cache --exclude-dir=.eggs --exclude-dir=\*.egg-info --exclude-dir=__pycache__ --exclude-dir=.pytest_cache --exclude-dir=test\* "$@" \.
}

grepit-py-imports() {
    grepit-py -E "(from.*import|import)"
}

grepit-py-imports-no-tests() {
    grepit-py-no-tests -E "(from.*import|import)"
}

grepit-no-docs() {
    grepit --exclude=\*.{txt,md,rst,log} --exclude-dir=\*.dist-info "$@"
}

grepit-exact() {
    pattern=$1
    [[ -z "$pattern" ]] && return 1
    shift
    grepit "\b$pattern\b" "$@"
}

grep-object-info() {
    object="$1"
    [[ -z "$object" ]] && return 1
    grepit-no-docs "\b$object\b" | egrep -o "($object\(|$object(\.\w+)+\(?)" |
    sort | uniq -c | sort -nr | egrep -v '.(js|py)$'
}

grep-history() {
    grep -Hn --color "$@" ~/.*history*
}

grep-history-exact() {
    pattern=$1
    [[ -z "$pattern" ]] && return 1
    shift
    grep-history "\b$pattern\b" "$@"
}

grep-history-comments() {
    grep-history "^#"
}

#################### helpme ####################

commands-functions-aliases() {
    out="$HOME/commands-functions-aliases.txt"
    alias > "$out"
    typeset -f >> "$out"
    echo $PATH | tr ':' '\0' |
         xargs -0 -I {} bash -c 'echo -e "\n"; ls -lhdF {}/* 2>/dev/null' >> "$out"
    less -FX "$out"
}

helpme() {
    cmd=$1
    [[ -z "$cmd" ]] && cmd="helpme"

    outfile="/tmp/helpme-$cmd.txt"
    rm $outfile 2>/dev/null
    touch $outfile

    # Print some help text about how this function should be invoked
    if [[ "$cmd" == "helpme" ]]; then
        echo "Usage: helpme command" >> $outfile
        echo "Use 'k' and 'j' to scroll up and down" >> $outfile
        echo -e "Use 'q' to exit.\n\n" >> $outfile
    fi

    # The `command -v` output is the same for bash and zsh
    cv=$(command -v $cmd)

    if [[ ! $cv =~ \/.* ]]; then
        echo -e "'$cv' is a shell function or builtin\n" >> $outfile
        echo -e "\n--------------------" >> $outfile
        if [[ -n "$BASH_VERSION" ]]; then
            echo -e "type -a $cmd\n" >> $outfile
            type -a $cmd >> $outfile
        elif [[ -n "$ZSH_VERSION" ]]; then
            echo -e "which $cmd\n" >> $outfile
            which $cmd >> $outfile
        fi
    elif [[ $cv =~ $HOME ]]; then
        echo -e "'$cv' path is in $HOME\n" >> $outfile
        cat $cv >> $outfile
    elif [[ $cv =~ alias.* ]]; then
        cat $cv >> $outfile
    else
        echo -e "${cv}\nFor more info, try 'man $cmd'"
        return 0
    fi

    less -FX $outfile
}

#################### man ####################

man-f() {
    man -f "$@" 2> /dev/null
}

#################### scrot ####################

if type scrot &>/dev/null; then
    screenshot() {
        scrot -s '%Y_%m%d--%H%M_%S--'$(hostname)'--$wx$h.png'
    }

    scrot-loop() {
        message="<ENTER> take screenshot (select area with mouse), <CTRL>+<C> to stop loop "
        while true; do
            if [[ -n "$BASH_VERSION" ]]; then
                read -p "$message" yn
            elif [[ -n "$ZSH_VERSION" ]]; then
                vared -p "$message" -c yn
            fi
            scrot -s '%Y_%m%d--%H%M_%S--'$(hostname)'--$wx$h.png'
        done
    }
fi

#################### ssh ####################

if [[ -d ~/.ssh ]]; then
    if type ssh-agent &>/dev/null; then
        sshlazy() {
            if [[ ! $(ssh-add -l 2>/dev/null) =~ [0-9]+ ]]; then
                eval $(ssh-agent -s)
                find "$HOME/.ssh" -type f -name "*rsa" -print0 | xargs -0 -n1 ssh-add
            fi
        }
    fi

    ssh-fix-permissions() {
        chmod 700 ~/.ssh
        find ~/.ssh -type f -print0 | xargs -0 chmod 600
    }
fi

#################### sudo ####################

if [[ -n "$(groups | grep -E '(sudo|admin)')" ]]; then
    alias lsof-ports-ipv4="sudo lsof -Pn -i4"

    if [[ -s /etc/shadow ]]; then
        etc-shadow() {
            sudo cat /etc/shadow | grep -vE '(^[^:]+:\*|^$)'
        }
    fi

    if type nmap &>/dev/null; then
        alias nmap-local-machines10="sudo nmap -sS -p22,7777 10.0.0.0/24"
        alias nmap-local-machines192="sudo nmap -sS -p22,7777 192.168.1.0/24"
    fi

    if type lshw &>/dev/null; then
        alias hardware="sudo lshw -short"
    fi

    if type getent &>/dev/null; then
        alias sudo-users="getent group sudo"
    fi

    if [[ $(uname) != "Darwin" ]]; then
        alias shutdown="sudo shutdown -h +0"
        alias reboot="sudo reboot"
        alias hibernate="systemctl hibernate"

        newuser() {
            username=$1
            if [[ -z "$username" ]]; then
                echo "Expected a username as first argument" >&2
                return 1
            fi
            shell_path="$(which zsh 2>/dev/null)"
            [[ -z "$shell_path" ]] && shell_path="$(which bash)"

            # Create the user
            echo -e "\nsudo useradd -m -s $shell_path $username" >&2
            sudo useradd -m -s $shell_path $username || return 1

            # Set permissions for the user's home directory
            sudo chmod 700 /home/$username

            # Add the user to groups
            if [[ "$2" == sudo ]]; then
                sudo usermod -aG sudo,docker,audio,video,plugdev,netdev $username
            else
                sudo usermod -aG docker,audio,video,plugdev,netdev $username
            fi

            # Add an empty zshrc file so zsh doesn't bug you on first login
            [[ "$shell_path" =~ .*zsh.* ]] && sudo touch /home/$username/.zshrc

            # Make empty ~/.ssh/authorized_keys file
            sudo mkdir /home/$username/.ssh
            sudo chmod 700 /home/$username/.ssh
            sudo touch /home/$username/.ssh/authorized_keys
            sudo chmod 600 /home/$username/.ssh/authorized_keys
            sudo chown -R $username:$username /home/$username

            # Set a password for the user
            echo -e "\nsudo passwd $username" >&2
            sudo passwd $username

            # Clone base repo
            if type git &>/dev/null; then
                echo -e "\n$ sudo su - $username -c 'git clone https://github.com/kenjyco/base ~/repos/base'"
                sudo su - $username -c 'git clone https://github.com/kenjyco/base ~/repos/base'
                echo -e "\n$ sudo su - $username -c 'cd ~/repos/base; source ./install'"
                sudo su - $username -c 'cd ~/repos/base; source ./install.sh'
                echo -e "\n$ sudo su - $username -c 'ls -ltrhA ~'"
                sudo su - $username -c 'ls -ltrhA ~'
            fi
        }

        newusergit() {
            username=$1
            [[ -z "$username" ]] && username="git"
            sudo useradd -m -s $(which git-shell) $username || return 1
            sudo chmod 700 /home/$username
            sudo mkdir /home/$username/.ssh
            sudo chmod 700 /home/$username/.ssh
            sudo touch /home/$username/.ssh/authorized_keys
            sudo chmod 600 /home/$username/.ssh/authorized_keys
            sudo chown -R $username:$username /home/$username
            if type tree &>/dev/null; then
                sudo tree /home/$username
            fi
            echo -e "\nAdd the '$username' user to the AllowUsers line of '/etc/ssh/sshd_config'"
        }

        purgeuser() {
            username=$1
            [[ -z "$username" ]] && return 1

            # Find out if the user is sure
            if [[ -n "$BASH_VERSION" ]]; then
                read -p "are you sure? [y/n] " yn
            elif [[ -n "$ZSH_VERSION" ]]; then
                vared -p "are you sure? [y/n] " -c yn
            fi

            [[ ! "$yn" =~ [yY].* ]] && return 1

            # Actually remove the user and their home directory
            echo -e "\nsudo deluser --remove-home $username" >&2
            sudo deluser --remove-home $username

            echo -e "\nCurrent directories in /home"
            ls -ltr /home
        }
    fi

    if [[ -f /usr/bin/apt-get ]]; then
        alias uninstall-hard="sudo apt-get purge --auto-remove -y"
        APT_SECURITY_ONLY="/etc/apt/sources.security.only.list"

        make-security-only-list() {
            sudo sh -c "grep ^deb /etc/apt/sources.list | grep security > $APT_SECURITY_ONLY"
        }

        do-security-upgrades() {
            [[ ! -f $APT_SECURITY_ONLY ]] && make-security-only-list
            sudo apt-get update
            apt-get -s dist-upgrade -o Dir::Etc::SourceList=$APT_SECURITY_ONLY -o Dir::Etc::SourceParts=/dev/null |
            grep '^Inst' |
            cut -d' ' -f2 |
            sudo xargs apt-get install -y -o Dir::Etc::SourceList=$APT_SECURITY_ONLY
        }
    fi

    if type ntp &>/dev/null; then
        ntp-sync-now() {
            sudo service ntp stop && sudo ntpd -gq && sudo service ntp start
        }
    fi

    if type hostnamectl &>/dev/null; then
        set-hostname() {
            newhostname=$1
            if [[ -z "$newhostname" ]]; then
                echo "Expected the new hostname as first argument" >&2
                return 1
            fi
            sudo hostnamectl set-hostname $newhostname || return 1

            # Modify/append line of /etc/hosts to set `127.0.1.1 $newhostname`
            matched=$(grep 127.0.1.1 /etc/hosts)
            if [[ -z "$matched" ]]; then
                sudo sh -c "echo 127.0.1.1    $newhostname >> /etc/hosts"
            else
                sudo sh -c "sed -i \"/127.0.1.1/c\127.0.1.1    $newhostname\" /etc/hosts" 2>/dev/null
            fi

            echo -e "results of 'hostname' command:"
            hostname
            echo -e "\ncontents of '/etc/hostname' file:"
            cat /etc/hostname
            echo -e "\ngrep of '127.0.1.1' in '/etc/hosts' file:"
            grep 127.0.1.1 /etc/hosts
        }
    fi
fi

#################### tmux ####################

if type tmux &>/dev/null; then
    Tmux() {
        session_name="${1-0}"
        tmux -2 attach-session -t $session_name -d 2>/dev/null || tmux -2 new-session -s $session_name
    }
fi

#################### urxvt ####################

if type urxvt &>/dev/null; then
    fontsize() {
        printf '\33]50;%s' "xft:Inconsolata:size=$1"
    }

    big() { fontsize 16; }

    windowsize() {
        size=$1
        [[ ! "$size" =~ [0-9]+ ]] && size=11
        urxvt -title "size-$size" -geometry 90x25 -fn "xft:Inconsolata:size=$size" -e zsh &
        [[ $? -eq 0 ]] && disown && exit
    }

    big-window() { windowsize 16; }

    newwin(){
        title=$1
        geom=$2
        cmd='urxvt'
        if [[ -z "$title" ]]; then
            cmd="${cmd} -title \"$(basename $(pwd)) .::. $(date +'%b-%d at %I:%M%p')\""
        else
            cmd="${cmd} -title \"$title .::. $(date +'%b-%d at %I:%M%p')\""
        fi
        if [[ -n "$geom" ]]; then
            cmd="${cmd} -geometry $geom"
        fi
        echo "$cmd"
        eval "$cmd" &
        [[ $? -eq 0 ]] && disown && exit
    }
fi

#################### venv ####################

venv-site-packages() {
    env_name=$1
    [[ -z "$env_name" ]] && env_name="venv"
    [[ ! -d $env_name ]] && echo "Can't find '$env_name'" && return 1
    if [[ -d "$env_name/lib/python3.5/site-packages" ]]; then
        cd "$env_name/lib/python3.5/site-packages"
    elif [[ -d "$env_name/lib/python3.6/site-packages" ]]; then
        cd "$env_name/lib/python3.6/site-packages"
    elif [[ -d "$env_name/lib/python3.7/site-packages" ]]; then
        cd "$env_name/lib/python3.7/site-packages"
    elif [[ -d "$env_name/lib/python3.8/site-packages" ]]; then
        cd "$env_name/lib/python3.8/site-packages"
    elif [[ -d "$env_name/Lib/site-packages" ]]; then
        cd "$env_name/Lib/site-packages"
    fi
}

#################### vlc ####################

if [[ -s "/Applications/VLC.app/Contents/MacOS/VLC" ]]; then
    alias vlc='/Applications/VLC.app/Contents/MacOS/VLC'
fi

if type vlc &>/dev/null; then
    vlcf() {
        vlc --fullscreen "$@" &>/dev/null &
    }
fi

#################### xrandr ####################

if type xrandr &>/dev/null; then
    xrandr-connected-displays() {
        xrandr -q | grep -e '\bconnected\b' | perl -pe 's/^([\S]+).* (\d+x\d+).*/$1:$2/'
    }

    xrandr-fix-monitors() {
        position=${1:-above}
        allowed=(above below left-of right-of same-as)
        ok=
        for pos in "${allowed[@]}"; do
            [[ "$pos" == "$position" ]] && ok=yes && break
        done
        [[ -z "$ok" ]] && echo "Must pass in one of (${allowed[@]}) not \"$position\"" && return

        cmds=()
        names=()
        cmd=
        IFS=$'\n'; for line in $(xrandr -q | grep -A 1 -e '\bconnected\b'); do
            word=$(echo "$line" | awk '{print $1}')
            if [[ "$word" =~ ^[A-Z] || "$word" =~ ^[a-z] ]]; then
                cmd="xrandr --output $word --mode "
                names+=($word)
            elif [[ "$word" =~ ^[0-9] ]]; then
                cmd+="$word "
                if [[ -z "${cmds[@]}" ]]; then
                    cmd+="--primary"
                else
                    cmd+="--$position ${names[-2]}"
                fi
                cmds+=($cmd)
            fi
        done; unset IFS
        echo -e "\nCurrent:\n$(connected-displays)\n\nExecuting:"
        for cmd in "${cmds[@]}"; do
            echo " -> $cmd"
            eval "$cmd"
        done
    }
fi

#################### Environment managers ####################

nvm-install() {
    if [[ "$clean" == "clean" && -d ~/.nvm ]]; then
        echo -e "\nDeleting ~/.nvm and ~/.npm"
        rm -rf ~/.nvm ~/.npm 2>/dev/null
        unset NVM_DIR
    fi

    if [[ ! -d ~/.nvm ]]; then
        echo -e "\nInstalling nvm and latest 'long term support' version of node..."
        unset NVM_DIR
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.2/install.sh | bash
        export NVM_DIR="$HOME/.nvm"
        source "$NVM_DIR/nvm.sh"
        source "$NVM_DIR/bash_completion"
        nvm install --lts
    fi
}

# Enable nvm (node version manager)
if [[ -d $HOME/.nvm && -z "$NVM_DIR" ]]; then
    export NVM_DIR="$HOME/.nvm"
    source "$NVM_DIR/nvm.sh"
    source "$NVM_DIR/bash_completion"
fi

pyenv-install() {
    if [[ "$clean" == "clean" && $(uname) != "Darwin" && -d ~/.pyenv ]]; then
        echo -e "\nDeleting ~/.pyenv"
        rm -rf ~/.pyenv
    fi

    if [[ ! -d ~/.pyenv ]]; then
        echo -e "\nInstalling pyenv..."
        git clone https://github.com/pyenv/pyenv.git ~/.pyenv
        export PYENV_ROOT="$HOME/.pyenv"
        export PATH="$PYENV_ROOT/bin:$PATH"
        eval "$(pyenv init -)"
        echo -e "\nInstalling Python 3.8.2..."
        pyenv install 3.8.2
    fi
}

# Enable pyenv (on linux)
if [[ $(uname) != "Darwin" && -d $HOME/.pyenv && -z "$PYENV_ROOT" ]]; then
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    if type pyenv &>/dev/null; then
        eval "$(pyenv init -)"
    fi
fi

#################### PATH ####################

if [[ -d "$HOME/bin-base" && -z "$(echo $PATH | grep bin-base)" ]]; then
    PATH="$HOME/bin-base:$PATH"
fi
