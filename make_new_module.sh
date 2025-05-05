#!/bin/bash

# Source project configuration and helpers
source "$(dirname "$0")/configs/paths.sh"
source "$(dirname "$0")/configs/settings.sh"
source "$(dirname "$0")/helpers/colours.sh"

# Function to find the next available module number
find_next_module_number() {
    local highest_number=0
    local modules

    # Find all existing modules and extract their numbers
    modules=$(find "${MODULES_DIR}" -maxdepth 1 -type d -name "[0-9][0-9]_*" 2>/dev/null)

    if [ -n "$modules" ]; then
        for module in $modules; do
            local module_name=$(basename "$module")
            local number=$(echo "$module_name" | sed 's/^\([0-9][0-9]\)_.*/\1/')
            if [ "$number" -gt "$highest_number" ]; then
                highest_number=$number
            fi
        done
    fi

    # Return the next available number
    echo $(printf "%02d" $((highest_number + 1)))
}

# Function to create a slug from module name
create_slug() {
    echo "$1" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/--*/-/g' | sed 's/^-//' | sed 's/-$//'
}

# Function to create the module
create_module() {
    local module_name="$1"
    local module_description="$2"
    local module_number=$(find_next_module_number)
    local module_slug=$(create_slug "$module_name")
    local module_directory="${MODULES_DIR}/${module_number}_${module_slug}"

    # Check if directory already exists
    if [ -d "$module_directory" ]; then
        echo -e "${COLOR_RED}Error: Module directory already exists: $module_directory${COLOR_RESET}"
        exit 1
    fi

    # Create the module directory
    mkdir -p "$module_directory"

    # Create the entrypoint file from template
    cat > "${module_directory}/${ENTRYPOINT_FILENAME}" <<EOF
#!/bin/bash
#===================================================================================
# Module: ${module_number}_${module_slug}
# Description: ${module_description}
# Author: $(whoami)
# Created: $(date '+%Y-%m-%d')
#===================================================================================

#===================================================================================
# MODULE SETUP
#===================================================================================
if [[ "\${BASH_SOURCE[0]}" != "\${0}" ]]; then
    echo "This script must be executed directly, not sourced."
    return 1
fi

set -euo pipefail

if [[ -z "\${PROJECT_ROOT:-}" ]]; then
    echo "This script should be run from the installer, not directly."
    exit 1
fi

MODULE_NAME=\$(basename "\$(dirname "\$0")")
MODULE_DIR=\$(dirname "\$(realpath "\$0")")
LOG_PREFIX="[\${MODULE_NAME}]"

# Source helper files
for helper in "\${HELPERS_DIR}"/*.sh; do
    if [ -f "\$helper" ]; then
        source "\$helper"
    fi
done

cleanup() {
    # Remove temporary files, restore backup configurations on failure, etc.
    verbose "Performing cleanup..."
    # Add your cleanup code here
}

trap cleanup EXIT

#===================================================================================
# MAIN EXECUTION
#===================================================================================
main() {
    step "Starting module: \${MODULE_NAME}"

    # Check prerequisites
    step "Checking prerequisites"
    if ! command_exists apt-get; then
        error "This script requires apt-get to be installed"
        return 1
    fi

    # Your module implementation goes here
    # Example: Install packages
    step "Installing required packages"
    # install_package "package-name"

    # Example: Configure system settings
    step "Configuring system settings"
    # create_symlink "\${MODULE_DIR}/configs/some-config" "\${HOME}/.config/some-config"

    # Example: Run a system command
    step "Applying system settings"
    # sudo systemctl enable some-service

    success "Module completed successfully: \${MODULE_NAME}"
    return 0
}

# Execute the main function
main "\$@"
exit \$?
EOF

    # Make the entrypoint executable
    chmod +x "${module_directory}/${ENTRYPOINT_FILENAME}"

    # Create module subdirectories if needed
    mkdir -p "${module_directory}/files"  # For module-specific files

    echo -e "${COLOR_GREEN}Successfully created module: ${COLOR_BOLD}${module_number}_${module_slug}${COLOR_RESET}"
    echo -e "${COLOR_CYAN}Location: ${module_directory}${COLOR_RESET}"
    echo -e "${COLOR_YELLOW}Edit ${module_directory}/${ENTRYPOINT_FILENAME} to implement your module.${COLOR_RESET}"
}

# Main script execution
echo -e "${COLOR_BOLD}${COLOR_BLUE}Create New Module${COLOR_RESET}"
echo "=============================="

# Check if arguments were provided
if [ $# -ge 2 ]; then
    # Use command line arguments
    module_name="$1"
    module_description="$2"
else
    # Interactive mode
    read -p "Enter module name (e.g., 'system-setup'): " module_name
    read -p "Enter module description: " module_description
fi

# Validate input
if [ -z "$module_name" ]; then
    echo -e "${COLOR_RED}Error: Module name cannot be empty.${COLOR_RESET}"
    exit 1
fi

if [ -z "$module_description" ]; then
    echo -e "${COLOR_RED}Error: Module description cannot be empty.${COLOR_RESET}"
    exit 1
fi

# Create the module
create_module "$module_name" "$module_description"

exit 0
