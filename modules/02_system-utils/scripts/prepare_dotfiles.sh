#!/bin/bash

prepare_dotfiles() {
    step "Preparing dotfiles directories"
    
    ensure_dir "${SYSTEM_DIR}/dotfiles/btop"
    ensure_dir "${SYSTEM_DIR}/dotfiles/neofetch"
    
    if [ -f "../linux-configs/config/neofetch/config.conf" ]; then
        cp "../linux-configs/config/neofetch/config.conf" "${SYSTEM_DIR}/dotfiles/neofetch/"
        success "Copied neofetch config from old repository"
    fi
    
    if [ -f "${HOME}/.config/btop/btop.conf" ]; then
        cp "${HOME}/.config/btop/btop.conf" "${SYSTEM_DIR}/dotfiles/btop/"
        success "Copied existing btop config to dotfiles"
    fi
    
    success "Dotfiles directories prepared"
}