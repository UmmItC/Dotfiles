#!/bin/bash

# This is the old command to get battery status, but it requires the acpi package :)
# for those who perfer acpi command, install it by 'sudo pacman -S acpi'
# acpi -b | sed -n '2p' | awk -F': ' '{split($2, a, ","); print "Battery - " a[1] ", " a[2]}'

# Function to check if the system is a laptop (by checking battery directory)
is_laptop() {
    # Check for any BAT* directory to detect a laptop (battery presence)
    if ls /sys/class/power_supply/BAT* &>/dev/null; then
        return 0  # Laptop detected (battery is present)
    else
        return 1  # Not a laptop (no battery directory)
    fi
}

# Function to display battery status for all batteries
display_battery_status() {
    # Loop through all battery directories and display status for each
    for battery_dir in /sys/class/power_supply/BAT*; do
        if [ -d "$battery_dir" ]; then
            battery_status=$(cat "$battery_dir/status")
            battery_capacity=$(cat "$battery_dir/capacity")
            battery_name="Battery"
            echo "$battery_name: $battery_status, $battery_capacity% remaining"
        fi
    done
}

# Main logic to check laptop status and display battery info
if is_laptop; then
    display_battery_status
else
    # echo "This system is not a laptop or has no battery."
    # I dont think this is necessary, so I commented it out, for those guys
    # want to know what is going on :)
    # for the lock screen, you probably dont want to see this message, so you can
    # comment out the this line lol
    :
fi
