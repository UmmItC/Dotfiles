#!/bin/bash

# Run cliphist to list clipboard history
clipboard_text=$(cliphist list)

# Check if cliphist returned any text
if [[ -n "$clipboard_text" ]]; then
    # Use fuzzel and dmenu to select an item from clipboard history
    selected_text=$(echo "$clipboard_text" | fuzzel --dmenu -w 80)

    if [[ -n "$selected_text" ]]; then
        # Decode the selected text using cliphist
        decoded_text=$(echo "$selected_text" | cliphist decode)

        # Copy the decoded text to the clipboard using wl-copy
        echo "$decoded_text" | wl-copy

        # Notify the user
        notify-send "Clipboard" "Selected text copied to clipboard" --app-name="Cliphist"

    else
        notify-send "Clipboard" "No text selected from clipboard history" --app-name="Cliphist"
    fi

else
    notify-send "Clipboard" "No clipboard history available or no text copied recently" --app-name="Cliphist"
fi
