#!/bin/bash

# Base project paths
export PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export CONFIG_DIR="${PROJECT_ROOT}/configs"
export MODULES_DIR="${PROJECT_ROOT}/modules"
export HELPERS_DIR="${PROJECT_ROOT}/helpers"
export LOGS_DIR="${PROJECT_ROOT}/logs"
export SYSTEM_DIR="${PROJECT_ROOT}/system"
export DOTFILES_DIR="${SYSTEM_DIR}/dotfiles"
export SCRIPTS_DIR="${SYSTEM_DIR}/scripts"

# Module configuration
export MODULE_PREFIX_PATTERN="*_*"
export ENTRYPOINT_FILENAME="entrypoint.sh"

# System paths - Where files will actually be deployed
export HOME_DIRECTORY="${HOME}/"
export SYSTEM_CONFIG_DIRECTORY="${HOME}/.config/"
export SYSTEM_FONTS_DIRECTORY="/usr/local/share/fonts/"
export SYSTEM_BIN_DIRECTORY="/usr/local/bin/"

# Create required directories
mkdir -p "${LOGS_DIR}"
mkdir -p "${SYSTEM_CONFIG_DIRECTORY}"
