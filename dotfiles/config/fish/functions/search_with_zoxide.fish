function search_with_zoxide
    if test -z "$argv[1]"
        # Use fd with fzf to select & open a file when no args are provided
        set file (fd --type f -I -H -E .git -E .git-crypt -E .cache -E .backup | fzf --height=70% --preview='bat -n --color=always --line-range :500 {}')
        if test -n "$file"
            nvim $file
        end
    else
        # Handle when an arg is provided
        set lines (zoxide query -l | xargs -I {} fd --type f -I -H -E .git -E .git-crypt -E .cache -E .backup -E .vscode $argv[1] {} | fzf --no-sort | string collect)
        set line_count (echo $lines | wc -l | string trim)

        if test -n "$lines" && test $line_count -eq 1
            # Exact match found
            set file $lines
            nvim $file
        else if test -n "$lines"
            # Multiple matches, refine with fzf
            set file (echo $lines | fzf --query="$argv[1]" --height=70% --preview='bat -n --color=always --line-range :500 {}')
            if test -n "$file"
                nvim $file
            end
        else
            echo "No matches found." >&2
        end
    end
end

# To use as a command, save in config.fish or create a function wrapper
# alias nzo='search_with_zoxdie'
