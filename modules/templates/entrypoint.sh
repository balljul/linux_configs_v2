#!/bin/bash
#===================================================================================
# Module: $(basename "$(dirname "$0")")
# Description: [Module description here]
# Author: [Your name]
# Created: $(date '+%Y-%m-%d')
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

for helper in "${HELPERS_DIR}"/*.sh; do
    if [ -f "$helper" ]; then
        source "$helper"
    fi
done

cleanup() {
    # Remove temporary files, restore backup configurations on failure, etc.
    verbose "Performing cleanup..."

    # Example:
    # if [[ -f /tmp/module-temp-file ]]; then
    #     rm /tmp/module-temp-file
    # fi
}

# Register the cleanup function to run on script exit
trap cleanup EXIT

#===================================================================================
# MAIN EXECUTION
#===================================================================================

main() {
    step "Starting module: ${MODULE_NAME}"

    # Check prerequisites
    step "Checking prerequisites"
    if ! command_exists apt-get; then
        error "This script requires apt-get to be installed"
        return 1
    fi

    # Example: Install packages
    step "Installing required packages"
    # install_package "package-name"

    # Example: Configure system settings
    step "Configuring system settings"
    # create_symlink "${MODULE_DIR}/configs/some-config" "${HOME}/.config/some-config"

    # Example: Run a system command
    step "Applying system settings"
    # sudo systemctl enable some-service

    # Add your module-specific tasks here...

    success "Module completed successfully: ${MODULE_NAME}"
    return 0
}

# Execute the main function
main "$@"
exit $?
