function usync
    set --local current_path (pwd)

    venv
    uv sync
end
