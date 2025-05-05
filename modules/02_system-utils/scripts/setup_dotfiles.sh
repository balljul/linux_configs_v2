#!/bin/bash

setup_dotfiles() {
    step "Setting up dotfiles for system utilities"
    
    ensure_dir "${HOME}/.config/btop"
    ensure_dir "${HOME}/.config/neofetch"
    
    if [ -f ~/.config/btop/btop.conf ]; then
        info "Copying existing btop configuration to system dotfiles"
        mkdir -p "${SYSTEM_DIR}/dotfiles/btop"
        cp ~/.config/btop/btop.conf "${SYSTEM_DIR}/dotfiles/btop/"
        success "Saved btop configuration"
    elif [ -f "${SYSTEM_DIR}/dotfiles/btop/btop.conf" ]; then
        info "Using stored btop configuration"
        create_symlink "${SYSTEM_DIR}/dotfiles/btop/btop.conf" "${HOME}/.config/btop/btop.conf"
    else
        warn "No btop configuration found. Will use defaults."
    fi
    
    if [ -f ~/.config/neofetch/config.conf ]; then
        info "Copying existing neofetch configuration to system dotfiles"
        mkdir -p "${SYSTEM_DIR}/dotfiles/neofetch"
        cp ~/.config/neofetch/config.conf "${SYSTEM_DIR}/dotfiles/neofetch/"
        success "Saved neofetch configuration"
    elif [ -f "${SYSTEM_DIR}/dotfiles/neofetch/config.conf" ]; then
        info "Using stored neofetch configuration"
        create_symlink "${SYSTEM_DIR}/dotfiles/neofetch/config.conf" "${HOME}/.config/neofetch/config.conf"
    else
        warn "No neofetch configuration found. Will use defaults."
    fi
    
    if [ -f ~/.tmux.conf ]; then
        info "Copying existing tmux configuration to system dotfiles"
        cp ~/.tmux.conf "${SYSTEM_DIR}/dotfiles/"
        success "Saved tmux configuration"
    elif [ -f "${SYSTEM_DIR}/dotfiles/.tmux.conf" ]; then
        info "Using stored tmux configuration"
        create_symlink "${SYSTEM_DIR}/dotfiles/.tmux.conf" "${HOME}/.tmux.conf"
    fi
    
    success "Dotfiles setup completed"
}