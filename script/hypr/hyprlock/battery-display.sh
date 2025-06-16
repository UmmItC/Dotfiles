#!/bin/bash

# You can see so much comment
# in the code, so you can understand the code better :)
# Testing this environment is not easy, so I write so much comment here lol

# -----------------------------------------------------------------------------

# TEST MODE - Set to true to show fake battery status on desktop
# This test mode is for developer testing the battery display only.
# Since not every state have the laptop to test the battery display.
# So I set it to true when I'm testing, and you can set it to false if you want to
# see the real battery status.

# -----------------------------------------------------------------------------

TEST_MODE=true

# Function to check if the system is a laptop (by checking battery directory)
is_laptop() {
    # Check for any BAT* directory to detect a laptop (battery presence)
    if ls /sys/class/power_supply/BAT* &>/dev/null; then
        return 0  # Laptop detected (battery is present)
    else
        return 1  # Not a laptop (no battery directory)
    fi
}

# Function to display fake battery status for testing
display_fake_battery_status() {
    battery_capacity=$((RANDOM % 101))
    
    current_minute=$(date +%M)
    minute_mod=$((current_minute % 3))
    
    case $minute_mod in
        0)
            battery_status="Charging"
            echo "⚡ $battery_capacity% charging"
            ;;
        1)
            battery_status="Discharging"
            if [ $battery_capacity -gt 75 ]; then
                echo "🔋 $battery_capacity%"
            elif [ $battery_capacity -gt 50 ]; then
                echo "🔋 $battery_capacity%"
            elif [ $battery_capacity -gt 25 ]; then
                echo "🪫 $battery_capacity%"
            else
                echo "🪫 $battery_capacity%"
            fi
            ;;
        2)
            battery_status="Full"
            echo "🔋 100% full"
            ;;
    esac
}

# Function to display battery status for all batteries
display_battery_status() {
    for battery_dir in /sys/class/power_supply/BAT*; do
        if [ -d "$battery_dir" ]; then
            battery_status=$(cat "$battery_dir/status")
            battery_capacity=$(cat "$battery_dir/capacity")
            
            case $battery_status in
                "Charging")
                    echo "⚡ $battery_capacity% charging"
                    ;;
                "Discharging")
                    if [ $battery_capacity -gt 75 ]; then
                        echo "🔋 $battery_capacity%"
                    elif [ $battery_capacity -gt 50 ]; then
                        echo "🔋 $battery_capacity%"
                    elif [ $battery_capacity -gt 25 ]; then
                        echo "🪫 $battery_capacity%"
                    elif [ $battery_capacity -gt 15 ]; then
                        echo "🪫 $battery_capacity% low"
                    else
                        echo "🚨 $battery_capacity% critical"
                    fi
                    ;;
                "Full")
                    echo "🔋 $battery_capacity% full"
                    ;;
                *)
                    echo "🔋 $battery_capacity%"
                    ;;
            esac
        fi
    done
}

# Main logic to check laptop status and display battery info
if is_laptop; then
    display_battery_status
else
    if [ "$TEST_MODE" = true ]; then
        # Show fake battery status for testing on desktop
        display_fake_battery_status
    else
        # Show nothing on desktop
        :
    fi
fi