#!/bin/bash

# Check if rofi is already running
if pgrep -x "rofi" > /dev/null; then
    hyprctl notify 3 2500 "rgb(C62E2E)" "fontsize:35   Bruh, Don't launch multiple instances of rofi 🫠"
    echo "<NOTICE> $(date +"%Y-%m-%d %H:%M:%S"): Bruh, Don't launch multiple instances of rofi 🫠 - Cliphist" >> ~/script/cliphist/cliphist.log
    exit 1
fi

# Run cliphist to list clipboard history
clipboard_text=$(cliphist list)

# Check if cliphist returned any text
if [[ -n "$clipboard_text" ]]; then
    # Use fuzzel and dmenu to select an item from clipboard history
    selected_text=$(echo "$clipboard_text" | rofi -dmenu -p "Select history:" -theme ~/.config/rofi/clipboard.rasi)

    if [[ -n "$selected_text" ]]; then
        # Decode the selected text using cliphist
        decoded_text=$(echo "$selected_text" | cliphist decode)

        # Copy the decoded text to the clipboard using wl-copy
        echo "$decoded_text" | wl-copy

        # Notify the user
        hyprctl notify 5 2500 "rgb(86D293)" "fontsize:35   Copied to clipboard"
        echo "<NOTICE> $(date +"%Y-%m-%d %H:%M:%S"): Copied to clipboard - Cliphist" >> ~/script/cliphist/cliphist.log

    else
        hyprctl notify 2 2500 "rgb(4CC9FE)" "fontsize:35   No text selected"
        echo "<NOTICE> $(date +"%Y-%m-%d %H:%M:%S"): No text selected - Cliphist" >> ~/script/cliphist/cliphist.log
    fi

else
    hyprctl notify 2 2500 "rgb(FFF100)" "fontsize:35   No clipboard history available"
    echo "<NOTICE> $(date +"%Y-%m-%d %H:%M:%S"): No clipboard history available - Cliphist" >> ~/script/cliphist/cliphist.log
fi
