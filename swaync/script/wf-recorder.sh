#!/bin/bash

record_or_stop() {
    recording_dir="/home/$USER/Videos/wf-recording"

    # Check if the directory exists, if not, create it
    if ! ls "$recording_dir" > /dev/null 2>&1; then
        mkdir -p "$recording_dir"
    fi

    # Check if the directory creation was successful
    if [[ ! -d $recording_dir ]]; then
        echo "Error: Failed to create directory $recording_dir"
        exit 1
    fi

    if [[ $SWAYNC_TOGGLE_STATE == true ]]; then
        wf-recorder -a --file "$recording_dir/wf-recording-$(date +'%Y-%m-%d-%H-%M-%S').mkv"
    else
        pkill -15 wf-recorder
    fi
}

record_or_stop