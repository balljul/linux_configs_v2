# System Utilities Module

This module installs and configures common system utilities like btop, neofetch, htop, etc.

## Features

- Automatically installs packages from the `files/packages.txt` list
- Imports and sets up configurations from your old linux-configs repo if available
- Creates symlinks to configuration files in your home directory
- Preserves your existing configurations by backing them up

## How to Customize

### Adding Packages

To add more packages, simply edit the `files/packages.txt` file and add one package name per line:

```
btop
neofetch
htop
# Add your packages here
```

### Custom Configurations

Your configurations are stored in the `system/dotfiles` directory:

- btop: `system/dotfiles/btop/btop.conf`
- neofetch: `system/dotfiles/neofetch/config.conf`
- tmux: `system/dotfiles/.tmux.conf`

## Installation

This module is designed to be executed by the main installer script:

```bash
sudo ./installer.sh 02_system-utils
```