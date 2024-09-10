#!/bin/bash

# Check if rofi is already running
if pgrep -x "rofi" > /dev/null; then
    notify-send "Rofi" "Well, rofi is already running :D" --app-name="rofi" --icon="rofi"
    exit 1
fi

# Run the rofi command
rofi \
    -show drun \
    -modi drun \
    -drun-match-fields all \
    -drun-display-format "{name}" \
    -no-drun-show-actions \
    -terminal kitty \
    -kb-cancel Escape \
    -theme ~/.config/rofi/application-launcher.rasi

# Check the exit status of the rofi command
if [ $? -ne 0 ]; then
    notify-send "Rofi" "Error: rofi did not run correctly."
    exit 1
fi
