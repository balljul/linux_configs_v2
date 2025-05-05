#!/bin/bash

import_old_configs() {
    step "Importing configurations from old linux-configs repository"
    
    local old_configs_dir="../linux-configs/config"
    
    if [ ! -d "$old_configs_dir" ]; then
        warn "Old config directory not found: $old_configs_dir"
        return 0
    fi
    
    if [ -f "${old_configs_dir}/neofetch/config.conf" ]; then
        info "Found old neofetch configuration"
        mkdir -p "${SYSTEM_DIR}/dotfiles/neofetch"
        cp "${old_configs_dir}/neofetch/config.conf" "${SYSTEM_DIR}/dotfiles/neofetch/"
        success "Imported neofetch configuration"
    fi
    
    if [ -f "${HOME}/.config/btop/btop.conf" ] && [ ! -f "${SYSTEM_DIR}/dotfiles/btop/btop.conf" ]; then
        info "Found existing btop configuration"
        mkdir -p "${SYSTEM_DIR}/dotfiles/btop"
        cp "${HOME}/.config/btop/btop.conf" "${SYSTEM_DIR}/dotfiles/btop/"
        success "Imported btop configuration"
    fi
    
    if [ -f "${HOME}/.tmux.conf" ] && [ ! -f "${SYSTEM_DIR}/dotfiles/.tmux.conf" ]; then
        info "Found existing tmux configuration"
        cp "${HOME}/.tmux.conf" "${SYSTEM_DIR}/dotfiles/"
        success "Imported tmux configuration"
    fi
    
    success "Import process complete"
}