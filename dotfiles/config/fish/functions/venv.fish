function venv
    set --local current_path (pwd)
    set --local git_root (git rev-parse --show-toplevel 2>/dev/null)

    if not test -n "$git_root"
        echo "Not in a Git repository"
        return 1
    end

    set --local target_venv "$git_root/.venv"

    if test -n "$VIRTUAL_ENV"
        if test "$VIRTUAL_ENV" = "$target_venv"
            printf "venv already active in "
            printf '%s%s%s' (set_color $fish_color_cwd) (prompt_pwd) (set_color normal) \n
            return
        else
            set --local previous_venv $VIRTUAL_ENV
            deactivate

            # Create and activate new venv
            cd $git_root
            if not command uv venv &>/dev/null
                cd $current_path
                return 1
            end
            source .venv/bin/activate.fish

            # Show transition messages
            printf "Switched from "
            printf '%s%s%s' (set_color $fish_color_cwd) (prompt_pwd (dirname $previous_venv)) (set_color normal)
            printf " to "
            printf '%s%s%s\n' (set_color $fish_color_cwd) (prompt_pwd) (set_color normal)
        end
    else
        # Activate new venv
        cd $git_root
        if not command uv venv &>/dev/null
            cd $current_path
            return 1
        end
        source .venv/bin/activate.fish
        printf "venv successfully activated in "
        printf '%s%s%s\n' (set_color $fish_color_cwd) (prompt_pwd) (set_color normal)
    end

    cd $current_path
end
