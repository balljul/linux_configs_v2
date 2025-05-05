# Common Helper Functions

# Check if a command exists in the system
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check if a directory exists
dir_exists() {
    [ -d "$1" ]
}

# Check if a file exists
file_exists() {
    [ -f "$1" ]
}

# Create directory if it doesn't exist
ensure_dir() {
    if [ ! -d "$1" ]; then
        mkdir -p "$1"
        verbose "Created directory: $1"
    fi
}

# Ask the user a yes/no question
ask_question() {
    local question="$1"
    local default="${2:-yes}"
    
    if [ "$default" = "yes" ]; then
        local options="[Y/n]"
    else
        local options="[y/N]"
    fi
    
    while true; do
        echo -en "${COLOR_BOLD_CYAN}${question} ${options}:${COLOR_RESET} "
        read -r answer
        
        # Handle empty input (use default)
        if [ -z "$answer" ]; then
            answer="$default"
        fi
        
        case "$answer" in
            [Yy]|[Yy][Ee][Ss])
                return 0
                ;;
            [Nn]|[Nn][Oo])
                return 1
                ;;
            *)
                echo "Please answer 'yes' or 'no'."
                ;;
        esac
    done
}

# Get user input with a prompt
get_input() {
    local prompt="$1"
    local default="$2"
    local value
    
    if [ -n "$default" ]; then
        echo -en "${COLOR_BOLD_CYAN}${prompt} [${default}]:${COLOR_RESET} "
    else
        echo -en "${COLOR_BOLD_CYAN}${prompt}:${COLOR_RESET} "
    fi
    
    read -r value
    
    if [ -z "$value" ] && [ -n "$default" ]; then
        echo "$default"
    else
        echo "$value"
    fi
}

# Check if running as root
is_root() {
    [ "$EUID" -eq 0 ]
}

# Check if the system is Debian-based
is_debian_based() {
    [ -f /etc/debian_version ]
}

# Backup a file before modifying it
backup_file() {
    local file="$1"
    local backup="${file}.bak"
    
    if [ -f "$file" ]; then
        cp "$file" "$backup"
        verbose "Backed up $file to $backup"
    fi
}
