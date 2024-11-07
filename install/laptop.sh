#!/bin/bash

# Load the color codes and prompt functions
source <(head -n 23 ../install.sh)

# Function to display the banner
display_banner() {
    echo -e "${COLOR_GRAY}---------------------------------------------------------${COLOR_RESET}"
    echo -e "${COLOR_BLUE}Installing Brightness Control Tool (Simulated Failure)${COLOR_RESET}"
    echo -e "${COLOR_BLUE}This will install the following packages:${COLOR_RESET}"
    echo -e "${COLOR_BLUE}  - brightnessctl: A tool to manage screen brightness.${COLOR_RESET}"
    echo -e "${COLOR_BLUE}  - playerctl: A command-line utility to control media players (e.g., pause, play, skip tracks).${COLOR_RESET}"
    echo -e "${COLOR_GRAY}---------------------------------------------------------${COLOR_RESET}"
}

# Function to install Pacman packages
install_packages() {
    local packages=("brightnessctl" "playerctl")
    
    echo -e "${COLOR_GREEN}:: Packages to be installed: ${COLOR_RESET}${packages[*]}"

    if prompt_yna ":: Install ${packages[*]}?"; then
        sudo pacman -S ${packages[*]}

        # Sleep and clear to simulate failure
        sleep 1
        clear
    else
        echo -e "${COLOR_YELLOW}:: Skipping ${packages[*]} installation.${COLOR_RESET}"
        
        sleep 1
        clear
    fi
}

main() {
    clear
    # Display the banner
    display_banner

    # Install brightnessctl and playerctl
    install_packages
}

# Run the main function
main
