#!/bin/bash

# Define colors
readonly COLOR_YELLOW=$(tput setaf 3)
readonly COLOR_GREEN=$(tput setaf 2)
readonly COLOR_GREY=$(tput setaf 8)
readonly COLOR_DARK_RED=$(tput setaf 1)
readonly COLOR_BLUE=$(tput setaf 4)
readonly COLOR_RESET=$(tput sgr0)

# Function to prompt for Yes/No
prompt_yna() {
    local prompt_message="$1"
    local choice
    while true; do
        read -rp "${COLOR_GREEN}${prompt_message} (Y/N): ${COLOR_RESET}" choice
        case $choice in
            [Yy]*) return 0 ;;
            [Nn]*) return 1 ;;
            *) echo "${COLOR_DARK_RED}:: Please answer Y or N.${COLOR_RESET}" ;;
        esac
    done
}

# Function to check if a package is installed
is_package_installed() {
    pacman -Qs "$1" &>/dev/null
}

# Function to check if a command is available
command_exists() {
    command -v "$1" &>/dev/null
}

# Function to prompt for installation confirmation
prompt_installation() {
    if prompt_yna ":: Do you want to continue with the installation?"; then
        return 0
    else
        echo "${COLOR_YELLOW}:: Installation aborted.${COLOR_RESET}"
        exit 0
    fi
}

# Main function
main() {
    # install packages from install-packages.sh
    source ./install/install-packages.sh

    # Configure Display Manager
    source ./install/config-ly.sh

    # Copy configuration files
    source ./install/copy-config.sh

    # Clone NvChad and run Neovim if user confirms
    source ./install/nvchad-neovim.sh

    # Personal setup
    source ./install/personal-config.sh

    echo "${COLOR_GREEN}:: Installation completed successfully.${COLOR_RESET}"
    echo "${COLOR_GREEN}:: Please reboot your system to apply all changes!${COLOR_RESET}"
}

# Main script execution
if [ -f /etc/arch-release ]; then
    prompt_installation

    main
else
    echo "${COLOR_YELLOW}:: Sorry, Script only allows Arch Linux to run.${COLOR_RESET}"
fi
