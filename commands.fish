# Source this file

# Add aliases for ..
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

function cdd; mkdir -p "$argv" && cd "$argv" && pwd; end

# Use GNU find, grep, sort, and xargs if on a Mac
if test (uname) = "Darwin"
    if type gfind &>/dev/null
        alias find=gfind
    end
    if type ggrep &>/dev/null
        alias grep=ggrep
    end
    if type gsort &>/dev/null
        alias sort=gsort
    end
    if type gxargs &>/dev/null
        alias xargs=gxargs
    end
end

# Use vi keybindings to navigate command line
fish_vi_key_bindings

if find . -maxdepth 1 -type f -executable &>/dev/null
    set find_executables yes
end

if echo | grep -P '' &>/dev/null
    set grep_perl yes
end

if test (uname) = "Darwin"
    alias dfh="df -lPh"
    alias p="ps -eo user,pid,ppid,tty,%cpu,%mem,command | grep -vE '(^_|^root)' | less -FX"
    alias pa="ps -eo user,pid,ppid,tty,%cpu,%mem,command | less -FX"
    function psome
        p | grep -vE '(/Applications/.*\.app/|/Library/.*\.app/|/System/Library|/usr/libexec|/usr/sbin|com\.docker\.|ssh-agent|bash$|zsh$|fish$)' | less -FX
    end
    if test -n "$grep_perl"
        alias papps="p | grep -oP '/(Applications|Library)/.*?\.app/' | sort | uniq -c | sort -k1,1nr -k2 | less -FX"
    end
    if type pstree &>/dev/null
        alias pst="pstree -u $USER | less -FX"
    end
else
    alias dfh="df -Th --total | grep -vE '(^none|^udev|^tmpfs|^cgmfs)'"
    alias p="ps -eo user,pid,ppid,tty,cmd:200 | grep -v ' \[' | less -FX"
    alias pa="ps -eo user,pid,ppid,tty,cmd:200 | less -FX"
    function psome
        p | grep -vE '(chromium|firefox| \/usr\/| \/lib\/| \/sbin\/|dbus-launch|nm-applet|cinnamon|blueberry|avahi-daemon|ssh-agent|sshd:|bash$|zsh$|fish$)' | less -FX
    end
    alias pst="pstree -np | less -FX"
end

#################### PATH ####################

if test -d "$HOME/bin-base" && test -z "(echo $PATH | grep bin-base)"
    set -gx PATH "$HOME/bin-base" $PATH
end
