#!/bin/bash

configure_system_settings() {
    step "Configuring system settings"
    
    mkdir -p "${HOME}/.config"
    
    if command_exists zsh; then
        step "Setting ZSH as default shell"
        sudo chsh -s "$(which zsh)" "$USER"
        success "Default shell changed to ZSH"
    fi
    
    if [ -f /etc/timezone ]; then
        current_timezone=$(cat /etc/timezone)
        step "Current timezone: $current_timezone"
    else
        step "Setting timezone to Europe/Berlin"
        if [ -f /proc/1/comm ] && [ "$(cat /proc/1/comm)" = "systemd" ]; then
            sudo timedatectl set-timezone Europe/Berlin
            success "Timezone set to Europe/Berlin"
        else
            sudo ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime
            echo "Europe/Berlin" | sudo tee /etc/timezone > /dev/null
            success "Timezone set to Europe/Berlin (non-systemd method)"
        fi
    fi
    
    step "Setting keyboard layout to German"
    if [ -f /proc/1/comm ] && [ "$(cat /proc/1/comm)" = "systemd" ]; then
        sudo localectl set-keymap de
        success "Keyboard layout set to German"
    else
        if [ -d /etc/default ]; then
            sudo sh -c 'echo "XKBLAYOUT=\"de\"" > /etc/default/keyboard'
            if command_exists setupcon; then
                sudo setupcon
            fi
            success "Keyboard layout set to German (non-systemd method)"
        else
            warning "Cannot set keyboard layout in this environment, skipping"
        fi
    fi
    
    step "Setting locale to en_US.UTF-8"
    
    local locale_configured=false
    
    if [ -f /etc/locale.gen ]; then
        if grep -q "^# en_US.UTF-8 UTF-8" /etc/locale.gen; then
            sudo sed -i 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
        fi
        if grep -q "^# de_DE.UTF-8 UTF-8" /etc/locale.gen; then
            sudo sed -i 's/# de_DE.UTF-8 UTF-8/de_DE.UTF-8 UTF-8/' /etc/locale.gen
        fi
        
        sudo locale-gen && sudo update-locale LANG=en_US.UTF-8 && locale_configured=true
        
        if [ "$locale_configured" = true ]; then
            success "Locale configured (standard method)"
        fi
    fi
    
    if [ "$locale_configured" = false ] && is_debian_based && command_exists apt-get; then
        step "Installing locales package"
        if sudo apt-get update && sudo apt-get install -y locales; then
            if [ ! -f /etc/locale.gen ]; then
                echo "en_US.UTF-8 UTF-8" | sudo tee -a /etc/locale.gen > /dev/null
                echo "de_DE.UTF-8 UTF-8" | sudo tee -a /etc/locale.gen > /dev/null
            fi
            
            if sudo locale-gen && sudo update-locale LANG=en_US.UTF-8; then
                locale_configured=true
                success "Locales package installed and configured"
            fi
        fi
    fi
    
    if [ "$locale_configured" = false ]; then
        export LANG=en_US.UTF-8
        if [ -d /etc/default ]; then
            sudo sh -c 'echo "LANG=en_US.UTF-8" > /etc/default/locale'
        fi
        
        if [ -d /etc/profile.d ]; then
            sudo sh -c 'echo "export LANG=en_US.UTF-8" > /etc/profile.d/locale.sh'
            sudo chmod +x /etc/profile.d/locale.sh
        fi
        
        warning "Limited locale configuration applied (environment method)"
        locale_configured=true
    fi
    
    success "System settings configured successfully"
}