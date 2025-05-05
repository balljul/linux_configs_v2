#!/bin/bash
#===================================================================================
# Module: 02_system-utils
# Description: This module adds system utils like btop neofetch and their configs
# Author: julius
# Created: 2025-05-05
#===================================================================================

#===================================================================================
# MODULE SETUP
#===================================================================================
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

# Source helper files
for helper in "${HELPERS_DIR}"/*.sh; do
    if [ -f "$helper" ]; then
        source "$helper"
    fi
done

# Source all scripts in the module
for script in "${MODULE_DIR}/scripts"/*.sh; do
    if [ -f "$script" ]; then
        source "$script"
    fi
done

cleanup() {
    verbose "Performing cleanup..."
}

trap cleanup EXIT

#===================================================================================
# MAIN EXECUTION
#===================================================================================
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

    prepare_dotfiles
    import_old_configs
    install_system_utils
    setup_dotfiles

    success "Module completed successfully: ${MODULE_NAME}"
    return 0
}

# Execute the main function
main "$@"
exit $?