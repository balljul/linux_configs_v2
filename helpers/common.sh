command_exists() {
    command -v "$1" >/dev/null 2>&1
}

package_installed() {
    dpkg -l "$1" 2>/dev/null | grep -q "^ii"
}

ensure_dir() {
    mkdir -p "$1"
}
