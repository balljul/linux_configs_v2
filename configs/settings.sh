#!/bin/bash

# Module execution settings
export ENTRYPOINT_FILENAME="entrypoint.sh"    # Name of the entrypoint file in each module
export MODULE_PREFIX_PATTERN="[0-9][0-9]_*"   # Pattern to match module directories (e.g., 01_system-setup)
export CONTINUE_ON_ERROR=false                # Whether to continue if a module fails
export LOG_LEVEL=1                            # 0=quiet, 1=normal, 2=verbose, 3=debug
export EXECUTION_TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
export LOG_FILE="${LOGS_DIR}/install_${EXECUTION_TIMESTAMP}.log"

# Base colors
export COLOR_RED='\033[0;31m'          # Error messages
export COLOR_LIGHT_RED='\033[1;31m'    # Critical errors
export COLOR_GREEN='\033[0;32m'        # Success messages
export COLOR_LIGHT_GREEN='\033[1;32m'  # Important success
export COLOR_YELLOW='\033[0;33m'       # Warnings
export COLOR_LIGHT_YELLOW='\033[1;33m' # Important warnings
export COLOR_BLUE='\033[0;34m'         # Information
export COLOR_LIGHT_BLUE='\033[1;34m'   # Section headers
export COLOR_PURPLE='\033[0;35m'       # Status updates
export COLOR_LIGHT_PURPLE='\033[1;35m' # Important status
export COLOR_CYAN='\033[0;36m'         # Progress indicators
export COLOR_LIGHT_CYAN='\033[1;36m'   # Highlights
export COLOR_GRAY='\033[0;37m'         # Subtle information
export COLOR_WHITE='\033[1;37m'        # Emphasized text
export COLOR_BLACK='\033[0;30m'        # For use with backgrounds

# Background colors
export COLOR_BG_RED='\033[0;41m'       # Error background
export COLOR_BG_GREEN='\033[0;42m'     # Success background
export COLOR_BG_YELLOW='\033[0;43m'    # Warning background
export COLOR_BG_BLUE='\033[0;44m'      # Info background

# Text styles
export COLOR_BOLD='\033[1m'            # Bold text
export COLOR_UNDERLINE='\033[4m'       # Underlined text
export COLOR_REVERSE='\033[7m'         # Reversed text/background
export COLOR_RESET='\033[0m'           # Reset to default

# Symbols for status indicators
export SYMBOL_SUCCESS="✓"
export SYMBOL_ERROR="✗"
export SYMBOL_WARNING="⚠"
export SYMBOL_INFO="ℹ"
export SYMBOL_PROGRESS="→"
export SYMBOL_LOADING="⟳"
