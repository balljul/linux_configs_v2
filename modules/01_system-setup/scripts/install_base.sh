#!/bin/bash

install_base_packages() {
    step "Installing base system packages"
    
    apt_update
    
    while read -r package; do
        [[ -z "$package" || "$package" == \#* ]] && continue
        
        install_package "$package"
    done < "${MODULE_DIR}/files/base_packages.txt"
    
    success "Base packages installed successfully"
}