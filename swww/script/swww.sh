#!/bin/bash

# Configuration variables
FPS=185
FUZZEL_WIDTH=50
FUZZEL_TITLE="Select Wallpaper: "

# Directory where wallpapers are stored
WALLPAPER_DIR="$HOME/.wallpaper"

# Get list of all files (including those in subdirectories) relative to $WALLPAPER_DIR
filenames=$(find "$WALLPAPER_DIR" -type f -printf "%P\n")

# Use fuzzel to display the list and get user selection
selected=$(echo "$filenames" | fuzzel --dmenu -w "$FUZZEL_WIDTH" -p "$FUZZEL_TITLE")

# Construct the full path based on user selection
selected_path="$WALLPAPER_DIR/$selected"

# Randomly choose a transition type and its arguments
transition_options=(
    "--transition-type grow --transition-pos 0.977,0.969 --transition-step 200 --transition-duration 3"
    "--transition-type wipe --transition-pos 0.977,0.969 --transition-step 90 --transition-duration 3 --transition-angle 30"
    "--transition-type outer --transition-pos 0.977,0.969 --transition-step 90 --transition-duration 3"
    "--transition-type center --transition-pos 0.977,0.969 --transition-step 90 --transition-duration 3"
)

# Choose a random index
selected_transition=${transition_options[RANDOM % ${#transition_options[@]}]}

# Wallpaper picker with Swww using the selected transition
swww img \
    --transition-fps "$FPS" \
    $selected_transition \
    "$selected_path"

# Display notification about wallpaper change
notify-send "Wallpaper Changed" "Wallpaper changed to $selected_path" \
    --app-name="Swww" \
    --icon="$selected_path"
