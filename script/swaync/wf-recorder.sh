#!/bin/bash

# Define the directory where recordings will be saved
recording_dir="/home/$USER/Videos/wf-recorder"

# Function to handle recording start or stop
record_or_stop() {
    # Check if the recording directory exists; create it if not
    if [[ ! -d $recording_dir ]]; then
        mkdir -p "$recording_dir" || { echo "Error: Failed to create the directory $recording_dir"; exit 1; }
    fi

    # Check if recording should start or stop
    if [[ $SWAYNC_TOGGLE_STATE == true ]]; then
        # Start recording
        local filename="$recording_dir/wf-recorder-$(date +'%Y-%m-%d-%H-%M-%S').mkv"
        notify-send "wf-recorder" "Starting video recording with wf-recorder" \
            --app-name="wf-recorder" --icon="wf-recorder"
        wf-recorder -a --file "$filename"
    else
        # Stop recording
        local pid
        pid=$(pidof wf-recorder)

        if [[ -n $pid ]]; then
            # Send SIGINT signal to stop wf-recorder
            echo "Sending Ctrl + C signal to wf-recorder with PID $pid"
            kill -SIGINT "$pid"

            # Get the most recent recording file
            local filename
            filename=$(ls -t "$recording_dir" | head -n1)
            notify-send "wf-recorder" "Video recording ended and saved to: \n\n$recording_dir/$filename" \
                --app-name="wf-recorder" --icon="wf-recorder"
            echo "Video recording ended and saved to $filename"
        else
            echo "wf-recorder is not running."
        fi
    fi
}

# Call the function to start or stop recording
record_or_stop
