create_symlink() {
    local source="$1"
    local target="$2"

    if [[ ! -f "$source" ]]; then
        error "Source file does not exist: $source"
        return 1
    fi

    ensure_dir "$(dirname "$target")"

    if [[ -e "$target" ]]; then
        if [[ -L "$target" && "$(readlink "$target")" == "$source" ]]; then
            verbose "Symlink already correctly set: $target -> $source"
            return 0
        else
            local backup="${target}.backup.$(date +%Y%m%d_%H%M%S)"
            mv "$target" "$backup"
            warn "Backed up existing file: $target -> $backup"
        fi
    fi

    ln -sf "$source" "$target"
    success "Created symlink: $target -> $source"
}
