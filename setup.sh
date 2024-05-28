#!/bin/bash

# Define colors
GREEN='\033[0;32m'
GRAY='\033[1;30m'
DARKRED='\033[0;31m'
NC='\033[0m' # No Color

repo_url=https://codeberg.org/UmmIt/Dotfiles.git
repo=Dotfiles
repo_setup=https://codeberg.org/UmmIt/Dotfiles/raw/branch/main/setup.sh

# Function to prompt for yes/no input with default value 'y'
prompt_yes_no() {
    local choice
    read -p "$1 [Y/n]: " choice
    choice=${choice:-y}
    case "$choice" in
        [Yy]* ) return 0;;
        [Nn]* ) return 1;;
        * ) echo -e "${DARKRED}[!] Invalid input. Please enter 'y' or 'n'.${NC}";;
    esac
}

# Check if user wants to run the script
if prompt_yes_no "Do you want to run the script?"; then
    # Run the setup script
    echo -e "${GREEN}[+] Running setup script...${NC}"
    curl -sSL $repo_setup | bash
fi

# Check if user wants to clone the repository
if prompt_yes_no "Do you want to clone the repository?"; then
    # Clone the repository
    echo -e "${GREEN}[+] Cloning repository...${NC}"
    git clone $repo_url
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}[+] Repository cloned successfully.${NC}"
        cd $repo
        # Check if user wants to run the install script
        if prompt_yes_no "Do you want to run the install script?"; then
            # Run the install script if it exists
            if [ -f "install.sh" ]; then
                echo -e "${GREEN}[+] Running install script...${NC}"
                bash install.sh
            else
                echo -e "${GRAY}[~] No install script found.${NC}"
            fi
        else
            echo -e "${GRAY}[~] Install script not executed.${NC}"
        fi
    else
        echo -e "${DARKRED}[!] Cloning failed.${NC}"
    fi
else
    echo -e "${GRAY}[~] Repository not cloned.${NC}"
fi
