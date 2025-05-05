# APT Helper Functions

# Update apt package list
apt_update() {
    step "Updating package lists"
    if [[ "${DRY_RUN}" == "true" ]]; then
        info "[DRY RUN] Would run: apt-get update"
    else
        apt-get update
    fi
    success "Package lists updated"
}

# Install a package using apt
install_package() {
    local package="$1"
    
    if ! package_installed "$package"; then
        step "Installing package: $package"
        if [[ "${DRY_RUN}" == "true" ]]; then
            info "[DRY RUN] Would run: apt-get install -y --no-install-recommends $package"
            success "[DRY RUN] Package would be installed: $package"
        else
            apt-get install -y --no-install-recommends "$package"
            if [ $? -eq 0 ]; then
                success "Package installed: $package"
            else
                error "Failed to install package: $package"
                return 1
            fi
        fi
    else
        verbose "Package already installed: $package"
    fi
    
    return 0
}

# Check if a package is installed
package_installed() {
    if [[ "${DRY_RUN}" == "true" ]]; then
        # In dry run mode, just say it's not installed so we can see what would be installed
        return 1
    else
        dpkg -l "$1" 2>/dev/null | grep -q ^ii
        return $?
    fi
}

# Add a repository to apt sources
add_apt_repository() {
    local repo="$1"
    
    step "Adding repository: $repo"
    if [[ "${DRY_RUN}" == "true" ]]; then
        info "[DRY RUN] Would run: apt-get update"
        info "[DRY RUN] Would run: apt-get install -y software-properties-common"
        info "[DRY RUN] Would run: add-apt-repository -y $repo"
        info "[DRY RUN] Would run: apt-get update"
        success "[DRY RUN] Repository would be added: $repo"
    else
        apt-get update
        apt-get install -y software-properties-common
        add-apt-repository -y "$repo"
        apt-get update
        success "Repository added: $repo"
    fi
}
