#!/bin/bash

# Check if rofi is already running
if pgrep -x "rofi" > /dev/null; then
    hyprctl notify 3 2500 "rgb(EF6D6D)" "fontsize:35   Bruh, don't launch multiple instances of rofi 🫠"

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
    hyprctl notify 3 2500 "rgb(EF6D6D)" "fontsize:35   Error: rofi did not run correctly 🫠"
    exit 1
fi
