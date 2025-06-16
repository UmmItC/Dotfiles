#!/bin/bash

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PARENT_DIR="$(dirname "$SCRIPT_DIR")"

# Source library functions
source "$PARENT_DIR/lib/common.sh"
source "$PARENT_DIR/lib/display-utils.sh"

# Default config directory
config_dir="$HOME/.config"

# Function to safely copy configuration with existence check
safe_copy() {
    local src="$1"
    local dest="$2"
    local name="$3"
    local current="$4"
    local total="$5"
    
    echo "${COLOR_BLUE}[$current/$total] Processing $name configuration...${COLOR_RESET}"
    
    if [ -d "$dest" ] || [ -f "$dest" ]; then
        echo "${COLOR_YELLOW}:: $name already exists at $dest${COLOR_RESET}"
        if prompt_yna ":: Do you want to overwrite existing $name configuration?"; then
            echo "${COLOR_GREEN}:: [$current/$total] Overwriting $name configuration...${COLOR_RESET}"
            cp -rv "$src" "$(dirname "$dest")/"
            pause_and_continue
            clear
        else
            echo "${COLOR_YELLOW}:: [$current/$total] Skipping $name configuration copy.${COLOR_RESET}"
            pause_and_continue
            clear
        fi
    else
        echo "${COLOR_GREEN}:: [$current/$total] Copying $name configuration...${COLOR_RESET}"
        cp -rv "$src" "$(dirname "$dest")/"
        clear
    fi
}

# Function to set nushell as default shell
set_nushell_default() {
    if [ "$SHELL" = "/usr/bin/nu" ]; then
        echo "${COLOR_GREEN}:: We're detected that Nushell is already set as default shell!${COLOR_RESET}"
        return 0
    else
        echo "${COLOR_YELLOW}:: Setting nushell as default shell...${COLOR_RESET}"
        chsh -s /usr/bin/nu
        if [ $? -eq 0 ]; then
            echo "${COLOR_GREEN}:: Nushell set as default shell.${COLOR_RESET}"
            return 0
        else
            echo "${COLOR_RED}:: Failed to set nushell as default shell.${COLOR_RESET}"
            echo "${COLOR_YELLOW}:: You can manually set nushell as default shell later with: chsh -s /usr/bin/nu${COLOR_RESET}"
            return 1
        fi
    fi
}

# Function to copy all configuration files
copy_all_configs() {
    if prompt_yna ":: Copy configuration files?"; then
        safe_copy "./configs/hypr" "$config_dir/hypr" "Hyprland" "1" "13"
        safe_copy "./configs/kitty" "$config_dir/kitty" "Kitty" "2" "13"
        safe_copy "./configs/fastfetch" "$config_dir/fastfetch" "Fastfetch" "3" "13"
        safe_copy "./configs/waybar" "$config_dir/waybar" "Waybar" "4" "13"
        safe_copy "./configs/rofi" "$config_dir/rofi" "Rofi" "5" "13"
        safe_copy "./configs/swaync" "$config_dir/swaync" "SwayNC" "6" "13"
        safe_copy "./configs/wlogout" "$config_dir/wlogout" "Wlogout" "7" "13"
        safe_copy "./configs/mpv" "$config_dir/mpv" "MPV" "8" "13"
        safe_copy "./configs/yazi" "$config_dir/yazi" "Yazi" "9" "13"

        safe_copy "./script" "$HOME/script" "Scripts" "10" "13"
        safe_copy "./.wallpaper" "$HOME/.wallpaper" "Wallpapers" "11" "13"
        
        echo "${COLOR_GREEN}:: Basic Configuration files copied successfully.${COLOR_RESET}"
        echo "${COLOR_GREEN}:: Now setting nushell as default shell...${COLOR_RESET}"

        set_nushell_default
        
        safe_copy "./configs/nushell" "$config_dir/nushell" "Nushell" "12" "13"
        safe_copy "./configs/starship.toml" "$config_dir/" "Starship" "13" "13"

        echo "${COLOR_GREEN}:: All the files copied successfully.${COLOR_RESET}"
        pause_and_continue
        clear
    else
        echo "${COLOR_YELLOW}:: Skipping configuration file copying and updates.${COLOR_RESET}"
        echo "${COLOR_GREEN}:: You can copy the configuration files manually later.${COLOR_RESET}"
        clear
    fi
}

main() {
    display_config_banner

    copy_all_configs
}

main