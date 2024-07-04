# Aliases
alias c='cargo'
alias cr='cargo run'
alias cc='cargo check'
alias cls='clear'
alias lg='lazygit'
alias loff='libreoffice'
alias ffox='firefox'
alias yget='yay -S'
alias remove='sudo pacman -R'
alias lsals='bat ~/.zshals'
alias l='lsd -ll'
alias la='lsd -a'
alias ls='lsd'
alias cat='bat'
alias d='zoxide'
alias wttr='curl wttr.in/Kathmandu'
alias msqlr='sudo mariadb -u root -p'
alias msql='mariadb'
alias nvals='nvim ~/.config/fish/custom/als.fish'
alias tns='tmux new -s'
alias tls='tmux ls'
alias tat='tmux attach -t'
alias tals='tldr tmux'
alias tks='tmux kill-session -t'
alias tds='tmux detach'
alias trn='tmux rename-session -t'
alias nano='nvim'
alias start='python /home/j/cds/p/start/start.py'
alias sourcep1='.$HOME/penv/learn_python/bin/activate'
alias nv='nvim'
alias supsql='sudo -i -u postgres'
alias ccpd_restart='/etc/init.d/ccpd restart'
alias msql='/opt/lampp/htdocs/'
alias jamsjz='python /home/j/scripts/emacs.py'
alias gcd='git config --global credential.helper store'
alias md='mkdir -p'
alias reload='source ~/.config/fish/config.fish'
alias pbcopy='xsel --input --clipboard'
alias pbpaste='xsel --output --clipboard'
alias cmoi='chezmoi'
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
alias ff='fastfetch'

# Command Not Found Handler
function command_not_found_handler
    set purple (set_color -b magenta)
    set bright (set_color -o normal)
    set green (set_color -b green)
    set reset (set_color normal)
    printf 'fish: Unknown command '%s'\n' $argv[1]
    set entries (string split \n (pacman -F --machinereadable -- "/usr/bin/"$argv[1]))
    if test (count $entries) -gt 0
        printf "%s$argv[1]%s may be found in the following packages:\n" $bright $reset
        set pkg ''
        for entry in $entries
            set fields (string split ' ' $entry)
            if test "$pkg" != "$fields[2]"
                printf "%s/%s %s%s%s\n" $purple $bright $fields[2] $green $reset
            end
            printf '    /%s\n' $fields[4]
            set pkg $fields[2]
        end
    end
    return 127
end

# AUR Wrapper Detection
if pacman -Qi yay &>/dev/null
    set aurhelper yay
else if pacman -Qi paru &>/dev/null
    set aurhelper paru
end

# Package Installer Function
function ins
    set -l inPkg $argv
    set -l arch
    set -l aur

    for pkg in $inPkg
        if pacman -Si $pkg &>/dev/null
            set arch $arch $pkg
        else
            set aur $aur $pkg
        end
    end

    if count $arch >0
        sudo pacman -S $arch
    end

    if count $aur >0
        $aurhelper -S $aur
    end
end

# Handy shortcuts for changing directories
alias ..='cd ..'
alias ...='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'

# Always mkdir a path (this doesn't inhibit functionality to make a single dir)
alias mkdir='mkdir -p'

# Fixes "Error opening terminal: xterm-kitty" when using the default kitty term to open some programs through ssh
alias ssh='kitten ssh'


alias nv.p='NVIM_APPNAME=nvim-primeagen nvim'
alias rmpy='export PATH=/usr/bin:/usr/local/bin:$PATH'
