#!/bin/bash

# Check if waybar is running
if pgrep -x "waybar" > /dev/null; then
    killall waybar
    hyprctl notify 1 2500 "rgb(ED5AB3)" "fontsize:35   Waybar has been killed."
else
    hyprctl notify 1 2500 "rgb(ED5AB3)" "fontsize:35   Waybar is not running."
fi

# Check if swaync is running
if pgrep -x "swaync" > /dev/null; then
    killall swaync
    hyprctl notify 1 2500 "rgb(ED5AB3)" "fontsize:35   Swaync has been killed."
else
    hyprctl notify 1 2500 "rgb(ED5AB3)" "fontsize:35   Swaync is not running."
fi
