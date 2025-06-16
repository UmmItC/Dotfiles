#!/bin/bash

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PARENT_DIR="$(dirname "$SCRIPT_DIR")"

# Source library functions
source "$PARENT_DIR/lib/common.sh"
source "$PARENT_DIR/lib/display-utils.sh"

enable_ly_service() {

    pause_and_continue

    # Check if ly is installed
    if ! command_exists ly-dm; then
        echo -e "${COLOR_RED}:: ly is not installed. turn back to main menu and install our main packages first.${COLOR_RESET}"
        read -p "Press Enter to continue..."
        return 1
    fi
    
    if systemctl is-enabled ly.service &> /dev/null; then
        echo -e "${COLOR_GREEN}:: ly service is already enabled.${COLOR_RESET}"
        echo -e "${COLOR_YELLOW}:: There's nothing to do here.${COLOR_RESET}"
    else
        echo -e "${COLOR_RED}:: ly-dm service is not enabled, now will enable it.${COLOR_RESET}"
        if prompt_yna ":: Enable ly-dm service?"; then
            sudo systemctl enable ly-dm
        else
            echo -e "${COLOR_YELLOW}:: You can enable it later by running 'sudo systemctl enable ly-dm'${COLOR_RESET}"
        fi
    fi
    
    if [[ $? -eq 0 ]]; then
        read -p "Press Enter to continue..."
        return 0
    else
        echo -e "${COLOR_RED}:: Command run failed. try run again?${COLOR_RESET}"
        read -p "Press Enter to continue..."
        return 1
    fi
}

main() {
    display_manager_banner
    enable_ly_service
}

main