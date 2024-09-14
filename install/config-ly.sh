#!/bin/bash

# Function to display the banner
display_banner() {
    echo -e "${COLOR_GRAY}---------------------------------------------------------${COLOR_RESET}"
    echo -e "${COLOR_BLUE} Part 2: Configure LY Display Manager${COLOR_RESET}\n"
    echo -e "${COLOR_BLUE} ${COLOR_RESET}This section will configure LY as the display manager.${COLOR_RESET}"
    echo -e "${COLOR_BLUE} ${COLOR_RESET}The script will enable LY with systemd and disable${COLOR_RESET}"
    echo -e "${COLOR_BLUE} ${COLOR_RESET}your currently active display manager, if it is not LY.${COLOR_RESET}"
    echo -e "${COLOR_BLUE} ${COLOR_RESET}You may be asked to provide your password to complete${COLOR_RESET}"
    echo -e "${COLOR_BLUE} ${COLOR_RESET}this configuration.${COLOR_RESET}"
    echo -e "${COLOR_GRAY}---------------------------------------------------------${COLOR_RESET}"
}

# Function to detect and configure Ly as the default display manager
configure_ly() {

    if prompt_yna ":: Do you want to run the Ly display manager configuration?"; then
  
        # Check the currently running display manager
        local current_dm=$(ps -eo comm | grep -E '^ly-dm|^gdm|^sddm|^lightdm|^lxdm|^xdm' | head -n 1)
        local dm_packages=("gdm" "sddm" "lightdm" "xdm" "lxdm")

        if [ "$current_dm" == "ly-dm" ]; then
            echo -e "${COLOR_GREEN}:: You are already using Ly as your display manager. Nothing to do. Skipping...${COLOR_RESET}"

            sleep 1
            clear
        else
            if [ -n "$current_dm" ]; then
                echo -e "${COLOR_GREEN}:: Setting Ly as your default display manager...${COLOR_RESET}"
                sudo systemctl enable ly.service
            fi

            # Disable other display managers if they are active
            for package in "${dm_packages[@]}"; do
                if systemctl is-active --quiet "$package.service"; then
                    echo -e "${COLOR_GREEN}:: Disabling $package...${COLOR_RESET}"
                    sudo systemctl disable "$package.service"
                    echo -e "${COLOR_GREEN}:: Successfully disabled $package as your previous display manager.${COLOR_RESET}"

                    sleep 1
                    clear
                fi
            done
        fi
    else
        echo -e "${COLOR_YELLOW}:: Skipping Ly display manager configuration.${COLOR_RESET}"
        
        sleep 1
        clear
    fi
}

main() {
    # Display the banner
    display_banner

    # Start the configuration of Ly
    configure_ly
}

main
