#!/bin/bash

WALLPAPER_PATH=$(swww query | grep -oP '(?<=currently displaying: image: ).*')

WALLPAPER_PATH_WITH_HOME=$(echo "$WALLPAPER_PATH" | sed "s|^$HOME|\$HOME|")

# Update the hyprlock.conf file with the modified path
sed -i "s|path = .*|path = $WALLPAPER_PATH_WITH_HOME|" ~/.config/hypr/hyprlock.conf

# Print the result to verify - used for debugging
echo "Updated hyprlock.conf with the following wallpaper path:"
echo "path = $WALLPAPER_PATH_WITH_HOME"
