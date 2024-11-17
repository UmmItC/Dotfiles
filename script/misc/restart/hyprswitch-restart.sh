#!/bin/bash

start_hyprswitch="hyprswitch init --show-title --size-factor 6.5 --custom-css /home/leon/.config/hypr/hyprswitch/style.css"

# Log path
log_file=~/script/hypr/hyprswitch/hyprswitch-restart.log

# Ensure the directory exists
if mkdir -p "$LOG_DIR"; then
    echo "Directory $LOG_DIR created or already exists."
else
    echo "Failed to create $LOG_DIR."
fi

# Check if hyprswitch is running
if pgrep -x "hyprswitch" > /dev/null; then
    echo "Hyprswitch is running. Restarting..."
    killall hyprswitch
    nohup $start_hyprswitch 2>&1 &
    hyprctl notify 1 2500 "rgb(ED5AB3)" "fontsize:35   Hyprswitch has been restarted."
    echo "Hyprswitch has been restarted." >> $log_file
else
    echo "Hyprswitch is not currently running"
    nohup $start_hyprswitch 2>&1 &
    hyprctl notify 1 2500 "rgb(ED5AB3)" "fontsize:35   Hyprswitch has been started."
fi
