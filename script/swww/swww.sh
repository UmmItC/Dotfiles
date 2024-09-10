#!/bin/bash

# Check if rofi is already running
if pgrep -x "rofi" > /dev/null; then
    notify-send "Rofi" "Well, rofi is already running :D" --app-name="rofi" --icon="rofi"
    exit 1
fi

# Frame rate
FPS=185

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
    notify-send "Swww" "Wallpaper changed to $selected_filename" \
        --app-name="Swww" \
        --icon="$selected_path"
else
    # If no wallpaper was selected (selected_path is empty), notify the user or handle as needed
    notify-send "Swww" "No wallpaper was selected. Please choose a wallpaper." \
        --app-name="Swww" \
        --icon="Swww"
fi
