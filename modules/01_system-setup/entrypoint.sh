#!/bin/bash

if [[ "${BASH_SOURCE[0]}" != "${0}" ]]; then
    echo "This script must be executed directly, not sourced."
    return 1
fi

set -euo pipefail

if [[ -z "${PROJECT_ROOT:-}" ]]; then
    echo "This script should be run from the installer, not directly."
    exit 1
fi

MODULE_NAME=$(basename "$(dirname "$0")")
MODULE_DIR=$(dirname "$(realpath "$0")")
LOG_PREFIX="[${MODULE_NAME}]"

for helper in "${HELPERS_DIR}"/*.sh; do
    if [ -f "$helper" ]; then
        source "$helper"
    fi
done

for script in "${MODULE_DIR}/scripts"/*.sh; do
    if [ -f "$script" ]; then
        source "$script"
    fi
done

cleanup() {
    verbose "Performing cleanup..."
}

trap cleanup EXIT

main() {
    step "Starting module: ${MODULE_NAME}"

    step "Checking prerequisites"
    if ! command_exists apt-get; then
        error "This script requires apt-get to be installed"
        return 1
    fi
    
    if [[ $EUID -ne 0 ]]; then
        error "This script must be run as root or with sudo"
        return 1
    fi

    install_base_packages
    
    configure_system_settings
    
    if ask_question "Do you want to install the bspwm desktop environment?"; then
        install_desktop_environment
    else
        info "Skipping desktop environment installation"
    fi

    success "Module completed successfully: ${MODULE_NAME}"
    return 0
}

main "$@"
exit $?