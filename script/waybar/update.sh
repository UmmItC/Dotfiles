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
    if [ "${status}" == "SUCESS" ]; then
        echo -e "[ ${COLOR_GREEN}SUCESS${COLOR_RESET} ] ${message}"
    else
        echo -e "[ ${COLOR_DARK_RED}FAILED${COLOR_RESET} ] ${message}"
    fi
}

# Function to execute commands and check for errors
execute_command() {
    local cmd="$1"
    local description="$2"
    if eval "${cmd}"; then
        print_status "SUCESS" "${description}"
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
        hyprctl notify 5 1000 "rgb(433878)" """fontsize:35   Rebooting in $seconds seconds"
        hyprctl notify 4 1000 "rgb(433878)" """fontsize:35   Rebooting in $seconds seconds"
        hyprctl notify 3 1000 "rgb(433878)" """fontsize:35   Rebooting in $seconds seconds"
        hyprctl notify 2 1000 "rgb(433878)" """fontsize:35   Rebooting in $seconds seconds"
        hyprctl notify 1 1000 "rgb(433878)" """fontsize:35   Rebooting in $seconds seconds"
        sleep 1
        : $((seconds--))
    done
}

run_history() {
  # Execute history script first
  execute_command "bash ~/script/waybar/history.sh" "History script been executed :)"
}

# Banner for upgrade system
echo -e "${COLOR_LIGHT_BLUE}"
cat << "EOF"
╦ ╦┌─┐┌─┐┬─┐┌─┐┌┬┐┌─┐  ╔═╗┬ ┬┌─┐┌┬┐┌─┐┌┬┐
║ ║├─┘│ ┬├┬┘├─┤ ││├┤   ╚═╗└┬┘└─┐ │ ├┤ │││
╚═╝┴  └─┘┴└─┴ ┴─┴┘└─┘  ╚═╝ ┴ └─┘ ┴ └─┘┴ ┴

This script will upgrade your system with the following features, which automatically detect the following dose not exist:

- Full system upgrade via paru
- Upgrade oh-my-zsh
- Upgrade Powerlevel10k
- Upgrade Flatpak packages
EOF
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
                # Full system upgrade via paru
                echo -e "[${COLOR_GREEN} RUNNING ${COLOR_RESET}] Full system upgrade via paru"
                execute_command "paru" "Processed full system upgrade via paru"

                # Check if oh-my-zsh upgrade script exists before running it
                if [ -f "$HOME/.oh-my-zsh/tools/upgrade.sh" ]; then
                    echo -e "[${COLOR_GREEN} RUNNING ${COLOR_RESET}] Upgrading oh my zsh"
                    execute_command "~/.oh-my-zsh/tools/upgrade.sh" "Processed oh-my-zsh upgrade script"
                else
                    print_status "SKIP" "oh-my-zsh upgrade script not found"
                fi

                # Check if Powerlevel10k repository exists before attempting to update
                if [ -d "$HOME/powerlevel10k/.git" ]; then
                    echo -e "[${COLOR_GREEN} RUNNING ${COLOR_RESET}] Upgrading Powerlevel10k"
                    execute_command "git -C $HOME/powerlevel10k pull" "Processed Powerlevel10k upgrade"
                else
                    print_status "SKIP" "Powerlevel10k repository not found"
                fi
 
                # Check if flatpak is installed before updating packages
                if command -v flatpak &> /dev/null; then
                    echo -e "[${COLOR_GREEN} RUNNING ${COLOR_RESET}] Upgrading Flatpak packages"
                    execute_command "flatpak update" "Processed Flatpak package upgrade"
                else
                    print_status "SKIP" "flatpak is not installed"
                fi
            )

            # Calculate total update duration
            end_time=$(date +%s)
            total_duration=$((end_time - start_time))
            
            # Print total update time
            echo -e "[${COLOR_GREEN} SUCESS ${COLOR_RESET}] System upgrade completed successfully.\nTotal duration: ${COLOR_GREEN}${total_duration}${COLOR_RESET} seconds"

            hyprctl notify 5 5000 "rgb(00ff00)" """fontsize:35   Upgrade completed successfully. Total duration: ${total_duration} seconds"
            
            echo "<NOTICE> $(date +"%Y-%m-%d %H:%M:%S"): System upgrade completed successfully. Total duration: ${total_duration} seconds" >> ~/script/waybar/update.log

            # Run history script
            run_history

            # Prompt user to reboot the system
            while true; do
                echo -e "${COLOR_GREEN}"
                read -p "All operations have been completed. Would you like to reboot the system now? (y/n): " reboot_choice
                echo -e "${COLOR_RESET}"
                case $reboot_choice in
                    [Yy]* )
                        # Initiate countdown
                        countdown 5

                        # Reboot the system
                        systemctl reboot
                        break;;
                    [Nn]* )
                        break;;
                    * )
                        echo -e "${COLOR_DARK_RED}Please answer yes or no.${COLOR_RESET}";;
                esac
            done

            # Prompt user to press Enter to exit
            echo -e "Press any key to exit..."
            read -r
            break;;
        [Nn]* )
            echo -e "${COLOR_GREEN}System upgrade aborted. Press any key to exit...${COLOR_RESET}"
            read -r
            exit;;
        * )
            echo -e "${COLOR_DARK_RED}Please answer yes or no.${COLOR_RESET}";;
    esac
done
