#!/bin/bash

# Load the color codes and prompt functions
source <(head -n 23 ../install.sh)

# Function to install Pacman packages
install_brightnessctl() {
    local package="brightnessctl"
    
    echo -e "${COLOR_GREEN}:: Package to be installed: ${COLOR_RESET}$package"

    if prompt_yna ":: Install $package?"; then
        sudo pacman -S "$package"

        sleep 1
        clear
    else
        echo "${COLOR_YELLOW}:: Skipping $package installation.${COLOR_RESET}"
        
        sleep 1
        clear
    fi
}

# Function to display the banner
display_banner() {
    echo -e "${COLOR_GRAY}---------------------------------------------------------${COLOR_RESET}"
    echo -e "${COLOR_BLUE}Installing Brightness Control Tool${COLOR_RESET}"
    echo -e "${COLOR_BLUE}This will install brightnessctl for managing screen brightness.${COLOR_RESET}"
    echo -e "${COLOR_BLUE}You will be prompted to choose whether to proceed with the installation.${COLOR_RESET}"
    echo -e "${COLOR_GRAY}---------------------------------------------------------${COLOR_RESET}"
}

main() {
    clear
    # Display the banner
    display_banner

    # Install brightnessctl
    install_brightnessctl
}

# Run the main function
main
