#!/bin/bash

# Check if Swaync is running
if pgrep -x "swaync" > /dev/null; then
    killall swaync
    nohup swaync >> ~/script/swaync/swaync-restart.log 2>&1 &
    nohup swaync-client >> ~/script/swaync/swaync-restart.log 2>&1 &
    hyprctl notify 1 2500 "rgb(ED5AB3)" "fontsize:35   Swaync has been restarted."

else
    echo "Swaync is not currently running. will start it."
    hyprctl notify 1 2500 "rgb(ED5AB3)" "fontsize:35   Swaync has been started."
    nohup swaync >> ~/script/swaync/swaync-restart.log 2>&1 &
    echo "Swaync has been started."
fi
