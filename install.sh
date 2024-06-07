#!/bin/bash

# Define colors
readonly COLOR_YELLOW=$(tput setaf 3)
readonly COLOR_GREEN=$(tput setaf 2)
readonly COLOR_GREY=$(tput setaf 8)
readonly COLOR_DARK_RED=$(tput setaf 1)
readonly COLOR_RESET=$(tput sgr0)

# Function to prompt for Yes/No
prompt_yna() {
    local choice
    while true; do
        read -rp "${COLOR_GREEN}$1 (Y/N): ${COLOR_RESET}" choice
        case $choice in
            [Yy]*) return 0 ;;
            [Nn]*) return 1 ;;
            *) echo "${COLOR_DARK_RED}:: Please answer Y or N.${COLOR_RESET}" ;;
        esac
    done
}

# Function to check if a package is installed
is_package_installed() {
    pacman -Qs "$1" &>/dev/null
}

# Function to check if a command is available
command_exists() {
    command -v "$1" &>/dev/null
}

# Function to check if yay is installed
check_yay() {
    if ! command_exists yay; then
        echo "${COLOR_YELLOW}:: yay is not installed.${COLOR_RESET}"
        if prompt_yna ":: Would you like to install yay?"; then
            echo "${COLOR_GREEN}:: Installing yay...${COLOR_RESET}"
            if ! (git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si); then
                echo "${COLOR_DARK_RED}:: Failed to install yay.${COLOR_RESET}"
                exit 1
            fi
        else
            echo "${COLOR_DARK_RED}:: Exiting...${COLOR_RESET}"
            exit 0
        fi
    fi
}

# Function to install Pacman packages
install_pacman_packages() {
    local pacman_packages=("zsh" "hyprland" "hyprpaper" "waybar" "fuzzel" "ttf-jetbrains-mono" "ttf-jetbrains-mono-nerd" "kitty" "cliphist" "clipmenu" "neovim" "hyprlock" "fastfetch" "wf-recorder" "swaync" "ly")
    echo "${COLOR_GREEN}:: Pacman packages to be installed:${COLOR_RESET}"
    for package in "${pacman_packages[@]}"; do
        echo "${COLOR_GREY}$package${COLOR_RESET}"
    done
    if prompt_yna ":: Install these pacman packages?"; then
        sudo pacman -S "${pacman_packages[@]}"
    fi
}

# Function to install aur packages
install_aur_packages() {
    local aur_packages=("wlogout" "hyprshot")
    echo "${COLOR_GREEN}:: AUR packages to be installed:${COLOR_RESET}"
    for package in "${aur_packages[@]}"; do
        echo "${COLOR_GREY}$package${COLOR_RESET}"
    done
    if prompt_yna ":: Install these aur packages?"; then
        yay -S "${aur_packages[@]}"
    fi
}

# Copy configuration files
config_dir="$HOME/.config"

# Function to copy configuration files
copy_config_files() {
    if prompt_yna ":: Copy configuration files?"; then
        cp -rv ./hypr "$config_dir/"
        cp -rv ./kitty "$config_dir/"
        cp -rv ./fastfetch "$config_dir/"
        cp -rv ./waybar "$config_dir/"
        cp -rv ./fuzzel "$config_dir"
        cp -rv ./swaync "$config_dir/"

        sudo cp -v ./ly/config.ini /etc/ly
    else
        echo "${COLOR_YELLOW}:: Skipping configuration file copying.${COLOR_RESET}"
    fi
}

# Main function
main() {
    # Check if a resolution is selected
    if [[ -z $selected_resolution ]]; then
        echo "${COLOR_DARK_RED}:: No resolution selected. Exiting...${COLOR_RESET}"
        exit 1
    else
        echo "${COLOR_GREEN}:: You selected $selected_resolution as your screen resolution. ($connected_display)${COLOR_RESET}"
    fi

    install_pacman_packages
    check_yay
    install_aur_packages
    
    copy_config_files
   
    # Prompt for monitor refresh rate until a valid integer is provided
    while true; do
        read -rp ":: Enter the Monitor refresh rate you want: " monitor_hz
        if [[ -z $monitor_hz ]]; then
            echo "${COLOR_YELLOW}:: Warning - Input cannot be empty.${COLOR_RESET}"
        elif ! [[ $monitor_hz =~ ^[0-9]+$ ]]; then
            echo "${COLOR_DARK_RED}:: Error - '$monitor_hz' is not a valid integer.${COLOR_RESET}"
        else
            break
        fi
    done

    # Update hyprland.conf on line 16
    sed -i "16 s/^monitor=.*/monitor=$connected_display,$selected_resolution@$monitor_hz,0x0,1/" "$config_dir/hypr/hyprland.conf"

    # Update hyprlock.conf
    sed -i "s/monitor = .*/monitor = $connected_display/g" "$config_dir/hypr/hyprlock.conf"
    
    # Update hyprpaper.conf
    sed -i "10s@wallpaper = .*@wallpaper = $connected_display,~/.config/hypr/wallpaper/hong-kong.jpg@" "$config_dir/hypr/hyprpaper.conf"

    # Prompt for cloning NvChad and running nvim
    if prompt_yna ":: Clone NvChad and run nvim?"; then
        echo "${COLOR_YELLOW}Neovim using NvChad:${COLOR_RESET}"
        echo ":: NvChad will ask you the default configuration, please enter 'n'."
        git clone https://github.com/NvChad/NvChad "$config_dir/nvim" --depth 1 && nvim
    else
        echo "${COLOR_YELLOW}:: Skipping NvChad cloning and nvim execution.${COLOR_RESET}"
    fi

    echo "${COLOR_GREEN}:: Installation completed successfully.${COLOR_RESET}"
    echo "${COLOR_GREEN}:: Please reboot your system to apply all changes!${COLOR_RESET}"
}

# Get the connected display name
connected_display=$(xrandr | awk '/\<connected\>/ {print $1}')

# Run whiptail and capture the output
selected_resolution=$(whiptail --title "Resolution Selection" --menu "Choose a resolution with $connected_display" 20 60 10 \
"1920x1080" "" \
"1440x1080" "" \
"1400x1050" "" \
"1280x1024" "" \
"1280x960" "" \
"1152x864" "" \
"1024x768" "" \
"800x600" "" \
"640x480" "" \
"320x240" "" \
"1680x1050" "" \
"1440x900" "" \
"1280x800" "" \
"1152x720" "" \
"960x600" "" \
"928x580" "" \
"800x500" "" \
"768x480" "" \
"720x480" "" \
"640x400" "" \
"320x200" "" \
"1600x900" "" \
"1368x768" "" \
"1280x720" "" \
"1024x576" "" \
"864x486" "" \
"720x400" "" \
"640x350" "" \
3>&1 1>&2 2>&3)

main
