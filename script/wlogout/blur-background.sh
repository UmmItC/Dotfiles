#!/bin/bash

# Capture a screenshot
if grim /tmp/shot.png; then
    echo "<NOTICE> $(date +"%Y-%m-%d %H:%M:%S"): Screenshot captured successfully" >> ~/script/wlogout/wlogout.log
else
    echo "<ERROR> $(date +"%Y-%m-%d %H:%M:%S"): Screenshot capture failed" >> ~/script/wlogout/wlogout.log
    hyprctl notify 1 5000 "rgb(FF0000)" "fontsize:35   Screenshot capture failed. Please check your setup."
    exit 1
fi

# Apply blur and darken the image
if magick /tmp/shot.png -blur 0x7 -brightness-contrast -6x6 /tmp/magick_blurred.png; then
    echo "<NOTICE> $(date +"%Y-%m-%d %H:%M:%S"): Image blurred and darkened successfully" >> ~/script/wlogout/wlogout.log
else
    echo "<ERROR> $(date +"%Y-%m-%d %H:%M:%S"): Image processing failed" >> ~/script/wlogout/wlogout.log
    hyprctl notify 1 5000 "rgb(FF0000)" "fontsize:35   Image processing failed"
    exit 1
fi

# Wlogout launch
if wlogout --protocol layer-shell; then
    ecoh "<NOTICE> $(date +"%Y-%m-%d %H:%M:%S"): Wlogout executed successfully" >> ~/script/wlogout/wlogout.log
else
    echo "<ERROR> $(date +"%Y-%m-%d %H:%M:%S"): Wlogout failed to lauch" >> ~/script/wlogout/wlogout.log
    hyprctl notify 1 5000 "rgb(FF0000)" "fontsize:35   Wlogout failed to launch"
    exit 1
fi
