#!/bin/bash

# Source configuration files
source "$(dirname "$0")/configs/paths.sh"
source "$(dirname "$0")/configs/settings.sh"

# Load all helper files
for helper in "${HELPERS_DIR}"/*.sh; do
    if [ -f "$helper" ]; then
        source "$helper"
    fi
done

# Create log file
echo "=== Installation started at $(date) ===" > "${LOG_FILE}"

# Define log function if not already defined in log.sh
if ! type -t log >/dev/null; then
    log() {
        local level=$1
        local message=$2
        local color=${3:-""}
        
        # Log to file without color codes
        echo "[$(date +"%Y-%m-%d %H:%M:%S")] [$level] $message" | sed 's/\x1B\[[0-9;]*[mGK]//g' >> "${LOG_FILE}"
        
        # Display to console with color if appropriate level
        if [ ${LOG_LEVEL} -ge $level ]; then
            if [ -n "$color" ]; then
                printf "%b%s%b\n" "$color" "$message" "$COLOR_RESET"
            else
                printf "%s\n" "$message"
            fi
        fi
    }
fi

# Display header
log 1 "═══════════════════════════════════════════════"
log 1 "${COLOR_BOLD_BLUE}        LINUX SETUP CONFIGURATION SCRIPT${COLOR_RESET}"
log 1 "═══════════════════════════════════════════════"
log 1 "${COLOR_CYAN}${SYMBOL_INFO} Starting installation at $(date)${COLOR_RESET}"
log 1 "${COLOR_WHITE}${SYMBOL_INFO} Log file: ${LOG_FILE}${COLOR_RESET}"
log 1 ""

# Find modules
log 2 "${COLOR_MAGENTA}${SYMBOL_ARROW} Scanning for modules in ${MODULES_DIR}${COLOR_RESET}"
log 2 "${COLOR_WHITE}  Pattern: ${MODULE_PREFIX_PATTERN}${COLOR_RESET}"
log 2 "${COLOR_WHITE}  Entrypoint: ${ENTRYPOINT_FILENAME}${COLOR_RESET}"

modules=($(find "${MODULES_DIR}" -maxdepth 1 -type d -name "${MODULE_PREFIX_PATTERN}" | sort))

if [ ${#modules[@]} -eq 0 ]; then
    log 1 "${COLOR_BG_RED}${COLOR_BOLD_WHITE} ERROR ${COLOR_RESET} ${COLOR_BOLD_RED}No modules found in ${MODULES_DIR}${COLOR_RESET}"
    exit 1
fi

log 1 "${COLOR_BOLD_GREEN}${SYMBOL_SUCCESS} Found ${#modules[@]} modules to execute${COLOR_RESET}"

# Process each module
for module in "${modules[@]}"; do
    module_name=$(basename "${module}")
    entrypoint="${module}/${ENTRYPOINT_FILENAME}"

    if [ ! -f "${entrypoint}" ]; then
        log 1 "${COLOR_BOLD_YELLOW}${SYMBOL_WARNING} Module ${module_name}: No entrypoint found${COLOR_RESET}"
        continue
    fi

    log 1 ""
    log 1 "┌──────────────────────────────────────────────"
    log 1 "│ ${COLOR_BOLD_BLUE}EXECUTING MODULE: ${COLOR_BOLD_CYAN}${module_name}${COLOR_RESET}"
    log 1 "└──────────────────────────────────────────────"

    chmod +x "${entrypoint}"
    log 2 "${COLOR_MAGENTA}${SYMBOL_ARROW} Running: ${entrypoint}${COLOR_RESET}"

    start_time=$(date +%s)
    "${entrypoint}" 2>&1 | tee -a "${LOG_FILE}"
    exit_code=${PIPESTATUS[0]}
    end_time=$(date +%s)
    execution_time=$((end_time - start_time))

    if [ ${exit_code} -eq 0 ]; then
        log 1 "${COLOR_BG_GREEN}${COLOR_BOLD_WHITE} SUCCESS ${COLOR_RESET} ${COLOR_GREEN}Module ${COLOR_BOLD_WHITE}${module_name}${COLOR_RESET}${COLOR_GREEN} completed in ${execution_time}s${COLOR_RESET}"
    else
        log 1 "${COLOR_BG_RED}${COLOR_BOLD_WHITE} FAILED ${COLOR_RESET} ${COLOR_RED}Module ${COLOR_BOLD_WHITE}${module_name}${COLOR_RESET}${COLOR_RED} failed with code ${exit_code} (${execution_time}s)${COLOR_RESET}"

        if [ "${CONTINUE_ON_ERROR}" = false ]; then
            log 1 "${COLOR_BOLD_RED}${SYMBOL_ERROR} Stopping installation${COLOR_RESET}"
            exit ${exit_code}
        else
            log 1 "${COLOR_BOLD_YELLOW}${SYMBOL_WARNING} Continuing despite failure...${COLOR_RESET}"
        fi
    fi
done

# Completion message
log 1 ""
log 1 "┌───────────────────────────────────────────────┐"
log 1 "│ ${COLOR_BOLD_GREEN}INSTALLATION COMPLETED SUCCESSFULLY${COLOR_RESET}           │"
log 1 "└───────────────────────────────────────────────┘"
log 1 "${COLOR_WHITE}${SYMBOL_INFO} Finished at $(date)${COLOR_RESET}"
log 1 "${COLOR_WHITE}${SYMBOL_INFO} Log saved to: ${LOG_FILE}${COLOR_RESET}"

exit 0
