#!/bin/bash

# Check if rofi is already running
if pgrep -x "rofi" > /dev/null; then
    hyprctl notify 3 2500 "rgb(C62E2E)" "fontsize:35   Bruh, Don't launch multiple instances of rofi 🫠"
    echo "<NOTICE> $(date +"%Y-%m-%d %H:%M:%S"): Bruh, Don't launch multiple instances of rofi 🫠 - Swww" >> ~/script/swww/swww.log
    exit 1
fi

# Frame rate
FPS=60

# Directory where wallpapers are stored
WALLPAPER_DIR="$HOME/.wallpaper"

# Get list of all files (including those in subdirectories) relative to $WALLPAPER_DIR
filenames=$(find "$WALLPAPER_DIR" -type f -printf "%P\n")

# Use rofi to display the list and get user selection
selected=$(echo "$filenames" | rofi -dmenu -p "Select Wallpaper:" -theme ~/.config/rofi/wallpaper-picker.rasi)

# Check if user selected a wallpaper
if [ -n "$selected" ]; then
    # Construct the full path based on user selection
    selected_path="$WALLPAPER_DIR/$selected"

    # Get the filename from the selected path
    selected_filename=$(echo "$selected")

    # Randomly choose a transition type and its arguments
    transition_options=(
        "--transition-type random --transition-pos 0.977,0.969 --transition-step 90 --transition-duration 2.5"
        "--transition-type center --transition-pos 0.977,0.969 --transition-step 90 --transition-duration 2.5"

    )

    # Choose a random index
    selected_transition=${transition_options[RANDOM % ${#transition_options[@]}]}

    # Wallpaper picker with Swww using the selected transition
    swww img \
        --transition-fps "$FPS" \
        $selected_transition \
        "$selected_path"

    hyprctl notify 5 2500 "rgb(86D293)" "fontsize:35   Ayo, Wallpaper changed to $selected_filename 🚀"
    echo "<NOTICE> $(date +"%Y-%m-%d %H:%M:%S"): Wallpaper changed to $selected_filename - Swww" >> ~/script/swww/swww.log
else
    hyprctl notify 2 2500 "rgb(FEEC37)" "fontsize:35   Don't you choose wallpaper? 🤔"
    echo "<NOTICE> $(date +"%Y-%m-%d %H:%M:%S"): Don't you choose wallpaper? 🤔 - Swww" >> ~/script/swww/swww.log
fi
