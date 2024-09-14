#!/bin/bash

config_dir="$HOME/.config"

# Function to display the banner
display_banner() {
    echo -e "${COLOR_GRAY}---------------------------------------------------------${COLOR_RESET}"
    echo -e "${COLOR_BLUE} Part 3: Copy Configuration Files${COLOR_RESET}\n"
    echo -e "${COLOR_BLUE} ${COLOR_RESET}This section will copy the necessary configuration files.${COLOR_RESET}"
    echo -e "${COLOR_BLUE} ${COLOR_RESET}This includes CSS styles, JSON configuration, and scripts.${COLOR_RESET}"
    echo -e "${COLOR_GRAY}---------------------------------------------------------${COLOR_RESET}"
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
        cp -rv ./configs/cava "$config_dir/"

        sudo cp -v ./configs/ly/config.ini /etc/ly
        
        cp -rv ./script "$HOME/"
        
        cp -rv ./.wallpaper/ "$HOME/"
        
        echo "${COLOR_GREEN}:: Configuration files copied successfully.${COLOR_RESET}"

        sleep 1
        clear
    else
        echo "${COLOR_YELLOW}:: Skipping configuration file copying and updates.${COLOR_RESET}"

        sleep 1
        clear
    fi
}

# Function to copy Steam configuration files
copy_steam_config_files() {
    if prompt_yna ":: Do you want to copy Steam configuration files?"; then
        if command_exists steam; then
            cp -v ./configs/steam/steam_dev.cfg ~/.steam/steam/
            echo "Steam configuration files copied successfully."

            sleep 1
            clear
        else
            echo "Steam is not installed. Installing Steam..."
            sudo pacman -S steam
            if [ $? -eq 0 ]; then
                echo "Steam installed successfully."
                cp -v ./configs/steam/steam_dev.cfg ~/.steam/steam/
                echo "Steam configuration files copied successfully."

                sleep 1
                clear
            else
                echo "Failed to install Steam."

                sleep 1
                clear
            fi
        fi
    else
        echo "${COLOR_YELLOW}:: Skipping copying of Steam configuration files.${COLOR_RESET}"

        sleep 2
        clear
    fi
}

# Main function
main() {
    # Display the banner
    display_banner

    # Copy configuration files
    copy_config_files

    # Copy Steam configuration files
    copy_steam_config_files
}

# Main script execution
main
