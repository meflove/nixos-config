set -x ATUIN_NOBIND true
atuin init fish | source

bind ctrl-r _atuin_search
bind up _atuin_bind_up
bind \eOA _atuin_bind_up
bind \e\[A _atuin_bind_up

if bind -M insert >/dev/null 2>&1
    bind -M insert ctrl-r _atuin_search
    bind -M insert up _atuin_bind_up
    bind -M insert \eOA _atuin_bind_up
    bind -M insert \e\[A _atuin_bind_up
end
