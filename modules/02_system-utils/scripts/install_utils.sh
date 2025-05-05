#!/bin/bash

install_system_utils() {
    step "Installing system utilities from package list"
    
    local package_list="${MODULE_DIR}/files/packages.txt"
    
    if [ ! -f "$package_list" ]; then
        error "Package list not found: $package_list"
        return 1
    fi
    
    # Update the package list first
    apt_update
    
    while IFS= read -r package || [[ -n "$package" ]]; do
        # Skip empty lines and comments
        if [[ -z "$package" || "$package" =~ ^[[:space:]]*# ]]; then
            continue
        fi
        
        # Install the package
        install_package "$package"
    done < "$package_list"
    
    success "All system utilities installed successfully"
}