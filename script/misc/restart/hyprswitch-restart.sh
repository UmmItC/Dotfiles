#!/bin/bash

start_hyprswitch="hyprswitch init --show-title --size-factor 6.5 --custom-css $HOME/.config/hypr/hyprswitch/style.css"

LOG_DIR="$HOME/.local/share/hyprswitch"
log_file="$LOG_DIR/hyprswitch-restart.log"

if [ ! -d "$LOG_DIR" ]; then
    if mkdir -p "$LOG_DIR"; then
        echo "Directory $LOG_DIR created."
    else
        echo "Failed to create $LOG_DIR."
    fi
fi

if pgrep -x "hyprswitch" > /dev/null; then
    echo "Hyprswitch is running. Restarting..."
    killall hyprswitch
    nohup $start_hyprswitch > /dev/null 2>&1 &
    hyprctl dispatch notify 3 5000 "Hyprswitch" "Restarted"
    echo "$(date): Hyprswitch has been restarted." >> "$log_file"
else
    echo "Hyprswitch is not currently running"
    nohup $start_hyprswitch > /dev/null 2>&1 &
    hyprctl dispatch notify 3 5000 "Hyprswitch" "Started"
    echo "$(date): Hyprswitch has been started." >> "$log_file"
fi