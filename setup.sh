#!/bin/bash

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source library functions
source "$SCRIPT_DIR/lib/common.sh"

# Repository configuration
repo_url=https://github.com/UmmItC/Dotfiles.git
repo=Dotfiles

# Check if user wants to run the script
if prompt_yna "Do you want to run the script?"; then
    echo -e "${COLOR_GREEN}[+] Running setup script...${COLOR_RESET}"
else
    echo -e "${COLOR_GREY}[~] Exiting the program.${COLOR_RESET}"
    exit 0
fi

check_git
check_paru

# Check if user wants to clone the repository
if prompt_yna "Do you want to clone the repository?"; then
    echo -e "${COLOR_GREEN}[+] Cloning repository...${COLOR_RESET}"
    git clone --recursive $repo_url
    if [ $? -eq 0 ]; then
        echo -e "${COLOR_GREEN}[+] Repository cloned successfully.${COLOR_RESET}"
        cd $repo
        if prompt_yna "Do you want to run the install script?"; then
            if [ -f "install.sh" ]; then
                echo -e "${COLOR_GREEN}[+] Running install script...${COLOR_RESET}"
                bash install.sh
            else
                echo -e "${COLOR_GREY}[~] No install script found.${COLOR_RESET}"
            fi
        else
            echo -e "${COLOR_GREY}[~] Install script not executed.${COLOR_RESET}"
        fi
    else
        echo -e "${COLOR_DARK_RED}[!] Cloning failed.${COLOR_RESET}"
    fi
else
    echo -e "${COLOR_GREY}[~] Repository not cloned.${COLOR_RESET}"
fi