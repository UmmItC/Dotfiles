#!/bin/bash

# ANSI color codes
readonly COLOR_LIGHT_BLUE='\e[94m'
readonly COLOR_GREEN='\e[32m'
readonly COLOR_DARK_RED='\e[31m'
readonly COLOR_RESET='\e[0m'

# Function to print systemd-style status messages
print_status() {
    local status="$1"
    local message="$2"
    if [ "${status}" == "OK" ]; then
        echo -e "[ ${COLOR_GREEN}OK${COLOR_RESET} ] ${message}"
    else
        echo -e "[ ${COLOR_DARK_RED}FAILED${COLOR_RESET} ] ${message}"
    fi
}

# Function to execute commands and check for errors
execute_command() {
    local cmd="$1"
    local description="$2"
    if eval "${cmd}"; then
        print_status "OK" "${description}"
        return 0
    else
        print_status "FAILED" "${description}"
        return 1
    fi
}

# Function for countdown
countdown() {
    local seconds=$1
    while [ $seconds -gt 0 ]; do
        echo -e "${COLOR_GREEN}Rebooting in $seconds seconds...${COLOR_RESET}"
        hyprctl notify 1 1000 "rgb(433878)" """fontsize:35   Rebooting in $seconds seconds"
        sleep 1
        : $((seconds--))
    done
}

# Banner for upgrade system
echo -e "${COLOR_LIGHT_BLUE}"
echo "╦ ╦┌─┐┌─┐┬─┐┌─┐┌┬┐┌─┐  ╔═╗┬ ┬┌─┐┌┬┐┌─┐┌┬┐"
echo "║ ║├─┘│ ┬├┬┘├─┤ ││├┤   ╚═╗└┬┘└─┐ │ ├┤ │││"
echo "╚═╝┴  └─┘┴└─┴ ┴─┴┘└─┘  ╚═╝ ┴ └─┘ ┴ └─┘┴ ┴"
echo -e "${COLOR_RESET}"

# Prompt user to confirm system upgrade
while true; do
    echo -e "${COLOR_GREEN}"
    read -p "Do you want to proceed with the system upgrade? (y/n): " choice
    echo -e "${COLOR_RESET}"
    case $choice in
        [Yy]* )
            # Start time for total update duration calculation
            start_time=$(date +%s)

            # Using () for command blocks
            (
                # Update Pacman and ignore dart package
                execute_command "sudo pacman -Syuv" "Full system upgrade (Syuv)"

                # Update AUR packages using yay
                execute_command "yay -Syu" "Upgrading AUR Packages"

                # Check if oh-my-zsh upgrade script exists before running it
                if [ -f "$HOME/.oh-my-zsh/tools/upgrade.sh" ]; then
                    execute_command "~/.oh-my-zsh/tools/upgrade.sh" "Upgrading oh my zsh"
                else
                    print_status "FAILED" "oh-my-zsh upgrade script not found"
                fi

                # Check if Powerlevel10k repository exists before attempting to update
                if [ -d "$HOME/powerlevel10k/.git" ]; then
                    execute_command "git -C $HOME/powerlevel10k pull" "Upgrading Powerlevel10k"
                else
                    print_status "FAILED" "Powerlevel10k repository not found"
                fi

                # Check if flatpak is installed before updating packages
                if command -v flatpak &> /dev/null; then
                    execute_command "flatpak update -v" "Upgrading Flatpak packages"
                else
                    print_status "FAILED" "flatpak is not installed"
                fi
            )

            # Calculate total update duration
            end_time=$(date +%s)
            total_duration=$((end_time - start_time))

            # Print total update time
            echo -e "${COLOR_GREEN}Total update time: ${total_duration} seconds${COLOR_RESET}"

            hyprctl notify 5 5000 "rgb(00ff00)" """fontsize:35   Upgrade completed successfully. Total duration: ${total_duration} seconds"
            
            echo "<NOTICE> $(date +"%Y-%m-%d %H:%M:%S"): System upgrade completed successfully. Total duration: ${total_duration} seconds" >> ~/script/waybar/update.log

            # Prompt user to reboot the system
            while true; do
                echo -e "${COLOR_GREEN}"
                read -p "Would you like to reboot your system now? (y/n): " reboot_choice
                echo -e "${COLOR_RESET}"
                case $reboot_choice in
                    [Yy]* )
                        # Initiate countdown
                        countdown 5

                        # Reboot the system
                        systemctl reboot
                        break;;
                    [Nn]* )
                        echo -e "${COLOR_GREEN}You can manually reboot your system later.${COLOR_RESET}"
                        break;;
                    * )
                        echo -e "${COLOR_DARK_RED}Please answer yes or no.${COLOR_RESET}";;
                esac
            done

            # Prompt user to press Enter to exit
            echo -e "${COLOR_GREEN}Press Enter to exit...${COLOR_RESET}"
            read -r
            break;;
        [Nn]* )
            echo -e "${COLOR_GREEN}System upgrade aborted.${COLOR_RESET}"
            echo -e "${COLOR_GREEN}Press Enter to exit...${COLOR_RESET}"
            read -r
            exit;;
        * )
            echo -e "${COLOR_DARK_RED}Please answer yes or no.${COLOR_RESET}";;
    esac
done
