function uadd
    set --local current_path (pwd)

    venv \n
    uv add "$argv"
end
