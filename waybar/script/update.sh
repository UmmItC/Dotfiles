#!/bin/bash

# ANSI color codes
readonly COLOR_GREEN='\e[32m'
readonly COLOR_RED='\e[31m'
readonly COLOR_RESET='\e[0m'

# Function to print systemd-style status messages
print_status() {
    local status="$1"
    local message="$2"
    if [ "${status}" == "OK" ]; then
        echo -e "[ ${COLOR_GREEN}OK${COLOR_RESET} ] ${message}"
    else
        echo -e "[ ${COLOR_RED}FAILED${COLOR_RESET} ] ${message}"
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

# Start time for total update duration calculation
start_time=$(date +%s)

# Using () for command blocks
(
    # Update Pacman and ignore dart package
    execute_command "sudo pacman -Syuv --ignore dart" "Full system upgrade (Syuv)"

    # Update AUR packages using yay
    execute_command "yay -Syu" "Upgrading AUR Packages"

    # Upgrade oh my zsh
    execute_command "bash ~/.oh-my-zsh/tools/upgrade.sh" "Upgrading oh my zsh"

    # Update Powerlevel10k theme
    execute_command "git -C $HOME/powerlevel10k pull" "Upgrading Powerlevel10k"

    # Update Flatpak packages
    execute_command "flatpak update -v" "Upgrading Flatpak packages"
)

# Calculate total update duration
end_time=$(date +%s)
total_duration=$((end_time - start_time))

# Print total update time
echo "Total update time: ${total_duration} seconds"
