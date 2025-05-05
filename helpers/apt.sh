install_apt_package() {
    if ! package_installed "$1"; then
        step "Installing package: $1"
        apt-get install -y "$1"
        success "Package installed: $1"
    else
        verbose "Package already installed: $1"
    fi
}
