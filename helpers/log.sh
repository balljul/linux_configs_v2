log() {
    local level=$1
    local message=$2
    local color=${3:-""}

    echo -e "[$(date +"%Y-%m-%d %H:%M:%S")] [$level] $message" | sed 's/\x1B\[[0-9;]*[mGK]//g' >> "${LOG_FILE}"

    if [ ${LOG_LEVEL} -ge $level ]; then
        if [ -n "$color" ]; then
            printf "%b%s%b\n" "$color" "$message" "$COLOR_RESET"
        else
            printf "%s\n" "$message"
        fi
    fi
}

info() {
    log 1 "${LOG_PREFIX} ${COLOR_CYAN}${SYMBOL_INFO} $1${COLOR_RESET}"
}

success() {
    log 1 "${LOG_PREFIX} ${COLOR_BOLD_GREEN}${SYMBOL_SUCCESS} $1${COLOR_RESET}"
}

warn() {
    log 1 "${LOG_PREFIX} ${COLOR_BOLD_YELLOW}${SYMBOL_WARNING} $1${COLOR_RESET}"
}

warning() {
    warn "$1"
}

error() {
    log 1 "${LOG_PREFIX} ${COLOR_BOLD_RED}${SYMBOL_ERROR} $1${COLOR_RESET}"
}

step() {
    log 1 "${LOG_PREFIX} ${COLOR_BOLD_BLUE}${SYMBOL_ARROW} $1${COLOR_RESET}"
}

verbose() {
    log 2 "${LOG_PREFIX} ${COLOR_WHITE}$1${COLOR_RESET}"
}
