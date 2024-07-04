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
                execute_command "sudo pacman -Syuv --ignore dart" "Full system upgrade (Syuv)"

                # Update AUR packages using yay
                execute_command "yay -Syu" "Upgrading AUR Packages"

                # Upgrade oh my zsh
                execute_command "~/.oh-my-zsh/tools/upgrade.sh" "Upgrading oh my zsh"

                # Update Powerlevel10k theme
                execute_command "git -C $HOME/powerlevel10k pull" "Upgrading Powerlevel10k"

                # Update Flatpak packages
                execute_command "flatpak update -v" "Upgrading Flatpak packages"
            )

            # Calculate total update duration
            end_time=$(date +%s)
            total_duration=$((end_time - start_time))

            # Print total update time
            echo -e "${COLOR_GREEN}Total update time: ${total_duration} seconds${COLOR_RESET}"
            notify-send "System Upgrade" "Upgrade completed successfully.\nTotal duration: ${total_duration} seconds"

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
