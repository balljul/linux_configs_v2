#!/bin/bash

# Base paths
export PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export CONFIG_DIR="${PROJECT_ROOT}/configs"
export MODULES_DIR="${PROJECT_ROOT}/modules"
export HELPERS_DIR="${PROJECT_ROOT}/helpers"
export LOGS_DIR="${PROJECT_ROOT}/logs"
export SYSTEM_DIR="${PROJECT_ROOT}/system"
export DOTFILES_DIR="${SYSTEM_DIR}/dotfiles"
export SCRIPTS_DIR="${SYSTEM_DIR}/scripts"

# Create required directories
mkdir -p "${LOGS_DIR}"
