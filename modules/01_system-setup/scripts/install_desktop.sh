#!/bin/bash

install_desktop_environment() {
    step "Installing bspwm desktop environment"
    
    apt_update
    
    while read -r package; do
        [[ -z "$package" || "$package" == \#* ]] && continue
        
        install_package "$package"
    done < "${MODULE_DIR}/files/desktop_packages.txt"
    
    step "Configuring X11"
    if ! command_exists startx; then
        warning "startx command not found after installing xorg. You may need to manually configure X11."
    fi
    
    step "Configuring lightdm display manager"
    if command_exists lightdm; then
        sudo systemctl enable lightdm
        success "Lightdm enabled"
    else
        warning "Lightdm not found. Display manager not configured."
    fi
    
    success "Desktop environment installed successfully"
}