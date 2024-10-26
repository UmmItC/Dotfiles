# Scripts

This directory contains various scripts that utilize tools for managing applications and utilities, aiming to automate tasks and enhance workflows. The scripts included are:

- **Cliphist**: Manages clipboard history and selection.
- **hyprlock**: Controls system lock conditions for Hyprland.
- **swaync**: Includes a script for `wf-recorder`
- **swww**: Provides for selecting wallpapers.
- **waybar**: System upgrades on Waybar status bar.
- **hyprpicker**: Color picker for Hyprland.

## Loggers

All the bash script including a logger function that logs messages to a file. The logger function is defined in all the scripts. which is track when access is attempted for the application.

Instead of relying on swaync notifications, it is better to use the .log file to track the access of the application.
