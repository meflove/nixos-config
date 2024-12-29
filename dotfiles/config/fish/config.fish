# Hyprland at login
if status is-login
    if test -z "$DISPLAY" -a "$XDG_VTNR" = 1
        mkdir -p ~/.cache
        exec Hyprland >~/.cache/hyprland.log
    end
end

status is-interactive; and begin
    set fish_greeting
    set fish_tmux_default_session_name meflove
    set fish_tmux_autostart_once false
    set fish_tmux_autostart true
end

fish_default_key_bindings

starship init fish | source
# if test -f ~/.cache/ags/user/generated/terminal/sequences.txt
#     cat ~/.cache/ags/user/generated/terminal/sequences.txt
# end

alias visudo='EDITOR="nvim -u NONE" command sudo visudo'
alias se=sudoedit
alias pamcan=pacman
alias m=micro
alias n=nvim
alias py=python
alias g=git
alias p=paru
alias cls="clear && fastfetch"
alias venv="python -m venv venv && source venv/bin/activate.fish"
alias ls='eza --icons=always --color=always -a1 --level 1'
alias ll='eza --icons=always --color=always -alh --git'
alias du=dust
alias df=duf
alias ip='ip -color=auto'
alias grep='grep --color=auto'
alias cat=bat
alias icat="kitten icat"
alias diff="kitty +kitten diff"
alias clip="kitty +kitten clipboard"
# alias ssh="kitty +kitten ssh"
alias ytdlp="cd /home/meflove/Yt-DLP/ && yt-dlp -f 'bestvideo[height<=1080][ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best' -S vcodec:h264"
alias ipv4="ip addr show | grep 'inet ' | grep -v '127.0.0.1' | cut -d' ' -f6 | cut -d/ -f1"
alias ipv6="ip addr show | grep 'inet6 ' | cut -d ' ' -f6 | sed -n '2p'"
alias hmmm='paru -Sy &> /dev/null && paru -Qu'
alias brn='curl wttr.in/barnaul | head -n -1'
alias err='journalctl -b -p err'
alias pkglist='pacman -Qs --color=always | less -R'
alias pacman-fzf-local="pacman -Qq | fzf --preview 'pacman -Qil {}' --layout=reverse --bind 'enter:execute(pacman -Qil {} | less)'"
alias pacman-fzf-remote="pacman -Slq | fzf --preview 'pacman -Si {}' --layout=reverse"
alias PublicIP='curl ifconfig.me && echo ""'
alias Holes='sudo netstat -tupln'

abbr mkdir 'mkdir -p'
abbr rm 'rm -r'

source ~/.config/fish/themes/tokyo-night-moon.fish

# Created by `pipx` on 2024-06-20 14:14:50
set PATH $PATH /home/user/.local/bin
zoxide init fish | source

# pnpm
set -gx PNPM_HOME "/home/user/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
    set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end
fzf_configure_bindings --variables=
fish_add_path /home/user/.spicetify

export LIBVIRT_DEFAULT_URI=\"qemu:///system\"
set -xU MANPAGER 'less -R --use-color -Dd+r -Du+b'
set -xU MANROFFOPT '-P -c'

export EDITOR=nvim
