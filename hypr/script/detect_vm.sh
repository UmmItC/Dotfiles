#!/bin/bash

# This script is designed for scenarios where gaming with a KVM (Keyboard, Video, Mouse switch), activating hypridle, and using hyprlock to lock your screen may conflict with the KVM setup. This conflict can result in your KVM system shutting down unexpectedly, potentially causing data loss or system instability. Additionally, even if you are using KDE or GNOME, it's advisable to disable default idle options to prevent this issue, especially for GPU Passthrough users. Furthermore, the main system may become unresponsive, necessitating a system reboot.

# Define color variables
BLUE='\e[34m'
GREEN='\e[32m'
RESET='\e[0m'  # Reset color to default

# Function to check QEMU status
check_qemu_and_lock() {
    # Check if qemu-system-x86_64 is running
    if ps aux | grep -v grep | grep qemu-system-x86_64 > /dev/null; then
        echo -e "${BLUE}:: QEMU is running.${RESET}"

        # Display notification about QEMU running
        notify-send "QEMU is Running" \
                    "System locking is not performed because QEMU is using system resources." \
                    --app-name="hyprlock" \
                    --icon="hyprlock"
    else
        echo -e "${GREEN}:: QEMU is not running. Going to use hyprlock to lock your system.${RESET}"

        # Execute hyprlock to lock the system
        hyprlock
    fi
}

# Check if QEMU is installed
if command -v qemu-system-x86_64 > /dev/null; then
    echo -e "${GREEN}:: QEMU is installed. Checking if qemu-system is launched or not...${RESET}"
    check_qemu_and_lock
else
    echo -e "${BLUE}:: QEMU is not installed. Locking with hyprlock.${RESET}"
    hyprlock
fi
