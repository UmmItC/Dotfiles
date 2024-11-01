#!/bin/bash

# ----------------------------------------------------------
# Clipboard Cleaner Script
# Designed for use with wl-paste and cliphist
# This script prompts the user to clear the clipboard history.
# ----------------------------------------------------------

# Function to check if wl-paste is running
is_wl_paste_running() {
    pgrep -x "wl-paste" > /dev/null 2>&1
}

# ANSI color codes
readonly COLOR_LIGHT_BLUE='\e[94m'
readonly COLOR_GREEN='\e[32m'
readonly COLOR_DARK_RED='\e[31m'
readonly COLOR_RESET='\e[0m'

# Banner for clipboard Cleaner
ascii_art="\
╔═╗┬  ┬┌─┐┌┐ ┌─┐┌─┐┬─┐┌┬┐  ╔═╗┬  ┌─┐┌─┐┌┐┌┌─┐┬─┐  ╔═╗┌─┐┬─┐┬┌─┐┌┬┐
║  │  │├─┘├┴┐│ │├─┤├┬┘ ││  ║  │  ├┤ ├─┤│││├┤ ├┬┘  ╚═╗│  ├┬┘│├─┘ │ 
╚═╝┴─┘┴┴  └─┘└─┘┴ ┴┴└──┴┘  ╚═╝┴─┘└─┘┴ ┴┘└┘└─┘┴└─  ╚═╝└─┘┴└─┴┴   ┴ 
"

echo -e "${COLOR_LIGHT_BLUE}${ascii_art}${COLOR_RESET}"
echo -e "${COLOR_LIGHT_BLUE}Designed for use with wl-paste and cliphist${COLOR_RESET}"
echo -e "${COLOR_LIGHT_BLUE}This script prompts the user to clear the clipboard history.${COLOR_RESET}"

while true; do
    echo -e "${COLOR_LIGHT_BLUE}"
    read -p "Do you want to clean your clipboard history? (y: wipe clipboard history, n: no): " choice
    echo -e "${COLOR_RESET}"
    
    case "$choice" in
        y)
            if is_wl_paste_running; then
                cliphist wipe
                echo -e "${COLOR_GREEN}Clipboard history cleared successfully.${COLOR_RESET}"
            else
                echo -e "${COLOR_DARK_RED}Error: wl-paste is not running. Cannot clear clipboard history.${COLOR_RESET}"
            fi
            break
            ;;
        n)
            echo -e "${COLOR_GREEN}No action taken.${COLOR_RESET}"
            break
            ;;
        *)
            echo -e "${COLOR_DARK_RED}Invalid choice. Please enter 'y' or 'n'.${COLOR_RESET}"
            ;;
    esac
done
