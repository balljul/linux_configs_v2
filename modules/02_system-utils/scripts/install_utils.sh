#!/bin/bash

install_system_utils() {
    step "Installing system utilities from package list"
    
    local package_list="${MODULE_DIR}/files/packages.txt"
    
    if [ ! -f "$package_list" ]; then
        error "Package list not found: $package_list"
        return 1
    fi
    
    apt_update
    
    while IFS= read -r package || [[ -n "$package" ]]; do
        if [[ -z "$package" || "$package" =~ ^[[:space:]]*# ]]; then
            continue
        fi
        
        install_package "$package"
    done < "$package_list"
    
    success "All system utilities installed successfully"
}