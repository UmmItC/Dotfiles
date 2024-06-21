#!/bin/bash

record_or_stop() {
    recording_dir="/home/$USER/Videos/wf-recorder"

    # Check if the directory exists; if not, create it
    if ! ls "$recording_dir" > /dev/null 2>&1; then
        mkdir -p "$recording_dir"
    fi

    # Check if the directory creation was successful
    if [[ ! -d $recording_dir ]]; then
        echo "Error: Failed to create the directory $recording_dir"
        exit 1
    fi

    if [[ $SWAYNC_TOGGLE_STATE == true ]]; then
        filename="$recording_dir/wf-recorder-$(date +'%Y-%m-%d-%H-%M-%S').mkv"
        notify-send "wf-recorder" "Starting video recording with wf-recorder" \
        --app-name="wf-recorder"
        wf-recorder -a --file "$filename"
    else
        # Get the PID of wf-recorder
        PID=$(pidof wf-recorder)
        if [ -n "$PID" ]; then
            echo "Sending Ctrl + C signal to wf-recorder with PID $PID"
            kill -SIGINT $PID
            filename=$(ls -t "$recording_dir" | head -n1)
            notify-send "wf-recorder" "Video recording ended and saved to: \n\n$recording_dir/$filename" \
            --app-name="wf-recorder"
            echo "Video recording ended and saved to $filename"
        else
            echo "wf-recorder is not running."
        fi
    fi
}

record_or_stop
