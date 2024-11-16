#!/bin/bash

# this file still testing, for convert all files into specific extension (jpg, jpeg, png)

target_dir="$HOME/.wallpaper/"

non_image_files=$(find "$target_dir" -type f ! \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \))

if [ -n "$non_image_files" ]; then
    echo "Found non-image files:"
    echo "$non_image_files"
else
    echo "No non-image files found."
fi
