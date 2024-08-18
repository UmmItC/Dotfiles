#!/bin/bash

# Define a function to send notifications
notify() {
    local message="$1"
    notify-send "Hyprpicker" "$message" --app-name="hyprpicker" --icon="hyprpicker"
}

# Run hyprpicker and capture the output
color=$(hyprpicker --autocopy)

# Check if a color was selected
if [ -z "$color" ]; then
    # If no color was selected, notify the user
    notify "Oh, No color selected."
else
    # Notify the user that the color has been copied to the clipboard
    notify "Color $color has been copied to clipboard."
    
    # Just for the terminal display
    echo $color
fi
