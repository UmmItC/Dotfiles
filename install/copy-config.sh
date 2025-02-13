#!/bin/bash

config_dir="$HOME/.config"

# Function to display the banner
display_banner() {
    cat <<EOF
${COLOR_GREEN}--------------------------------------------------${COLOR_RESET}
${COLOR_BLUE}Part 2: Copying Configuration Files

This section will copy the configuration files to the appropriate directories.
Those configuration are preconfigured for my setup.
You should modify them according to your needs.
Such as the monitor configuration of hyprland.
This script is using cp -rv to copy the configuration files.
Please make sure to backup your existing configuration files before copying.

- hypr
- kitty
- fastfetch
- waybar
- rofi
- swaync
- wlogout
- mpv
- yazi
- script
- wallpaper${COLOR_RESET}

${COLOR_GREEN}--------------------------------------------------${COLOR_RESET}
EOF
}

# Function to copy and update configuration files
copy_config_files() {
    # Copy configuration files
    if prompt_yna ":: Copy configuration files?"; then
        cp -rv ./configs/hypr "$config_dir/"
        cp -rv ./configs/kitty "$config_dir/"
        cp -rv ./configs/fastfetch "$config_dir/"
        cp -rv ./configs/waybar "$config_dir/"
        cp -rv ./configs/rofi "$config_dir"
        cp -rv ./configs/swaync "$config_dir/"
        cp -rv ./configs/wlogout "$config_dir/"
        cp -rv ./configs/mpv "$config_dir/"
        cp -rv ./configs/yazi "$config_dir/"
        
        cp -rv ./script "$HOME/"
        
        cp -rv ./.wallpaper/ "$HOME/"
        
        echo "${COLOR_GREEN}:: Configuration files copied successfully.${COLOR_RESET}"

        read -p ":: Configuration files copied successfully. Press any key to keep going :)"
        clear
    else
        echo "${COLOR_YELLOW}:: Skipping configuration file copying and updates.${COLOR_RESET}"

        read -p ":: Configuration files copied skipped. Press any key to keep going :)"
        clear
    fi
}

# Main function
main() {
    # Display the banner
    display_banner

    # Copy configuration files
    copy_config_files
}

# Main script execution
main
