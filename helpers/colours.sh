#!/bin/bash

# Force ANSI color support for tmux/xfce4
if [[ "$TERM" == *"tmux"* || "$TERM" == *"xfce"* ]]; then
    export TERM=xterm-256color
fi

# Regular colors
export COLOR_RED=$'\e[31m'
export COLOR_GREEN=$'\e[32m'
export COLOR_YELLOW=$'\e[33m'
export COLOR_BLUE=$'\e[34m'
export COLOR_MAGENTA=$'\e[35m'
export COLOR_CYAN=$'\e[36m'
export COLOR_WHITE=$'\e[37m'
export COLOR_BLACK=$'\e[30m'

# Bold/bright colors
export COLOR_BOLD_RED=$'\e[1;31m'
export COLOR_BOLD_GREEN=$'\e[1;32m'
export COLOR_BOLD_YELLOW=$'\e[1;33m'
export COLOR_BOLD_BLUE=$'\e[1;34m'
export COLOR_BOLD_MAGENTA=$'\e[1;35m'
export COLOR_BOLD_CYAN=$'\e[1;36m'
export COLOR_BOLD_WHITE=$'\e[1;37m'

# Background colors
export COLOR_BG_RED=$'\e[41m'
export COLOR_BG_GREEN=$'\e[42m'
export COLOR_BG_YELLOW=$'\e[43m'
export COLOR_BG_BLUE=$'\e[44m'
export COLOR_BG_MAGENTA=$'\e[45m'
export COLOR_BG_CYAN=$'\e[46m'
export COLOR_BG_WHITE=$'\e[47m'
export COLOR_BG_BLACK=$'\e[40m'

# Text styles
export COLOR_BOLD=$'\e[1m'
export COLOR_DIM=$'\e[2m'
export COLOR_ITALIC=$'\e[3m'
export COLOR_UNDERLINE=$'\e[4m'
export COLOR_BLINK=$'\e[5m'
export COLOR_REVERSE=$'\e[7m'
export COLOR_HIDDEN=$'\e[8m'
export COLOR_RESET=$'\e[0m'

# Symbols
export SYMBOL_SUCCESS="✓"
export SYMBOL_ERROR="✗"
export SYMBOL_WARNING="⚠"
export SYMBOL_INFO="ℹ"
export SYMBOL_ARROW="→"
export SYMBOL_LOADING="⟳"
