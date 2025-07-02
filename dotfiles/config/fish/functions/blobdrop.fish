function b
    if test -z "$argv[1]"
        # Use fd with fzf to select & open a file when no args are provided
        set file (fd --type f -I -H -E .git -E .git-crypt -E .cache -E .backup | fzf --height=70% --preview='bat -n --color=always --line-range :500 {}')
        if test -n "$file"
            command blobdrop "$file"
        end
    else
        # Handle when an arg is provided
        set count (count $argv)

        if test $count -eq 1; and test -e "$argv[1]"
            set file $argv[1]
            if test -e "$file"; and test -f "$file"
                command blobdrop "$file"
            else if test -e "$file"; and test -d "$file"
                set file (fd --type f -I -H -E .git -E .git-crypt -E .cache -E .backup | fzf --height=70% --preview='bat -n --color=always --line-range :500 {}')
                if test -n "$file"
                    command blobdrop "$file"
                end
            else
                echo "No matches found." >&2
            end
        else
            command blobdrop $argv[1]
        end
    end
end
