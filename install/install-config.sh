#!/bin/bash

# Color definitions
export COLOR_GREEN='\033[0;32m'
export COLOR_YELLOW='\033[1;33m'
export COLOR_BLUE='\033[0;34m'
export COLOR_WHITE='\033[1;37m'
export COLOR_RED='\033[0;31m'
export COLOR_GRAY='\033[0;90m'
export COLOR_GREY='\033[0;90m'
export COLOR_RESET='\033[0m'
export NC='\033[0m'

# Package file paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export PACKAGES_MAIN="$SCRIPT_DIR/packages_main"
export PACKAGES_GPU="$SCRIPT_DIR/packages_gpu"
export PACKAGES_LAPTOP="$SCRIPT_DIR/packages_laptop"

# Installation messages
export MSG_MAIN_BANNER="Part 1: Installing Main Packages

This section will install the main packages listed in the packages_main file.
These packages are essential for ensuring that my dotfiles function properly.
The installation process will utilize paru to manage all package installations.
Please note that the installation of AUR packages may take some time, as they will be compiled from source.

The packages will be sourced from the official Arch Linux repositories, including:

- Extra repository
- Multilib repository
- AUR repository"

export MSG_LAPTOP_BANNER="You saw this banner because you were detected as a laptop user.
This script will install brightnessctl and playerctl packages.
Which is useful for controlling screen brightness and media players.
and my dotfiles also use these tools."

# Utility functions
prompt_yna() {
    local prompt="$1"
    while true; do
        read -p "${prompt} [y/N/a] " yn
        case $yn in
            [Yy]* ) return 0;;
            [Nn]* ) return 1;;
            [Aa]* ) return 2;;
            * ) echo "Please answer yes(y), no(n), or all(a).";;
        esac
    done
}

# Function to read packages from file
read_packages_from_file() {
    local file="$1"
    local packages=()
    
    if [[ ! -f "$file" ]]; then
        echo >&2 "${COLOR_RED}Error: Package file $file not found${COLOR_RESET}"
        return 1
    fi
    
    while IFS= read -r package; do
        if [[ -n "$package" ]]; then
            packages+=("$package")
        fi
    done < "$file"
    
    echo "${packages[@]}"
}

# Function to install packages using paru
install_packages_with_paru() {
    local packages=("$@")
    if [[ ${#packages[@]} -gt 0 ]]; then
        echo "${COLOR_BLUE}Installing packages: ${packages[*]}${COLOR_RESET}"
        paru -S "${packages[@]}"
        return $?
    else
        echo "${COLOR_YELLOW}No packages to install${COLOR_RESET}"
        return 0
    fi
}

# Function to display banner
display_banner() {
    local message="$1"
    echo -e "${COLOR_GRAY}---------------------------------------------------------${COLOR_RESET}"
    echo -e "${COLOR_BLUE}${message}${COLOR_RESET}"
    echo -e "${COLOR_GRAY}---------------------------------------------------------${COLOR_RESET}"
}

# Function to check if running on laptop
is_laptop() {
    [[ -f /sys/class/power_supply/BAT0/capacity ]]
}

# Function to check GPU
has_amdgpu() {
    lsmod | grep -q '^amdgpu\s'
}

has_nvidia() {
    lsmod | grep -q '^nvidia\s'
}