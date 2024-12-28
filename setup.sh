#!/bin/bash

# Define colors
COLOR_GREEN='\033[0;32m'
COLOR_GRAY='\033[1;30m'
COLOR_DARKRED='\033[0;31m'
COLOR_YELLOW='\033[0;33m'
COLOR_RESET='\033[0m' # No Color

repo_url=https://github.com/UmmItC/Dotfiles.git
repo=Dotfiles

# Function to prompt for yes/no input with default value 'y'
prompt_yna() {
    local choice
    while true; do
        read -p "$1 [Y/n]: " choice
        choice=${choice:-y}
        case "$choice" in
            [Yy]* ) return 0;;
            [Nn]* ) return 1;;
            * ) echo -e "${COLOR_YELLOW}[!] Invalid input. Please enter 'y' or 'n'.${COLOR_RESET}";;
        esac
    done
}

# Function to check if a command is available
command_exists() {
    command -v "$1" &>/dev/null
}

# Function to check if git is installed
check_git() {
    if ! command_exists git; then
        echo -e "${COLOR_YELLOW}:: git is not installed.${COLOR_RESET}"
        if prompt_yna ":: Would you like to install git?"; then
            echo -e "${COLOR_GREEN}:: Installing git...${COLOR_RESET}"
            if ! (sudo pacman -S git --noconfirm); then
                echo -e "${COLOR_DARKRED}:: Failed to install git.${COLOR_RESET}"
                exit 1
            fi
        else
            echo -e "${COLOR_GRAY}:: Exiting...${COLOR_RESET}"
            exit 0
        fi
    fi
}

# Function to check if yay is installed
check_yay() {
    if ! command_exists yay; then
        echo "${COLOR_YELLOW}:: yay is not installed.${COLOR_RESET}"
        if prompt_yna ":: Would you like to install yay?"; then
            echo "${COLOR_GREEN}:: Installing yay...${COLOR_RESET}"
            if ! (cd .. && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si); then
                echo "${COLOR_DARK_RED}:: Failed to install yay.${COLOR_RESET}"
                exit 1
            fi
        else
            echo "${COLOR_DARK_RED}:: Exiting...${COLOR_RESET}"
            exit 0
        fi
    fi
}

# Check if user wants to run the script
if prompt_yna "Do you want to run the script?"; then
    # Run the setup script
    echo -e "${COLOR_GREEN}[+] Running setup script...${COLOR_RESET}"
else
    echo -e "${COLOR_GRAY}[~] Exiting the program.${COLOR_RESET}"
    exit 0
fi

# Check if git and yay are installed
check_git
check_yay

# Check if user wants to clone the repository
if prompt_yna "Do you want to clone the repository?"; then
    # Clone the repository
    echo -e "${COLOR_GREEN}[+] Cloning repository...${NC}"
    git clone --recursive $repo_url
    if [ $? -eq 0 ]; then
        echo -e "${COLOR_GREEN}[+] Repository cloned successfully.${COLOR_RESET}"
        cd $repo
        # Check if user wants to run the install script
        if prompt_yna "Do you want to run the install script?"; then
            # Run the install script if it exists
            if [ -f "install.sh" ]; then
                echo -e "${COLOR_GREEN}[+] Running install script...${COLOR_RESET}"
                bash install.sh
            else
                echo -e "${COLOR_GRAY}[~] No install script found.${COLOR_RESET}"
            fi
        else
            echo -e "${COLOR_GRAY}[~] Install script not executed.${COLOR_RESET}"
        fi
    else
        echo -e "${COLOR_DARK_RED}[!] Cloning failed.${COLOR_RESET}"
    fi
else
    echo -e "${COLOR_GRAY}[~] Repository not cloned.${COLOR_RESET}"
fi
