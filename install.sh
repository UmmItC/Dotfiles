#!/bin/bash

# Function to prompt for Yes/No
prompt_yna() {
    while true; do
        read -rp "$(tput setaf 3)$1 (Y/N): $(tput sgr0)" choice
        case $choice in
            [Yy]* ) return 0;;
            [Nn]* ) return 1;;
            * ) echo "Please answer Y or N.";;
        esac
    done
}

# Function to check if a package is installed
is_package_installed() {
    pacman -Qs "$1" &>/dev/null
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

# Check if the user cancelled or exited without making a selection
if [[ $? -ne 0 ]]; then
    echo "No resolution selected. Exiting..."
    exit 1
else
  echo "You selected $selected_resolution as your screen resolution. ($connected_display)"
fi


# List and install necessary pacman packages
pacman_packages=("neofetch" "zsh" "hyprland" "hyprpaper" "waybar" "fuzzel" "ttf-jetbrains-mono" "kitty" "git" "cliphist" "clipmenu" "neovim" "hyprlock")

echo "$(tput setaf 6)Pacman packages to be installed:$(tput sgr0)"
printf "$(tput setaf 4)%s$(tput sgr0)\n" "${pacman_packages[@]}"
if prompt_yna "Install these pacman packages?"; then
    sudo pacman -S "${pacman_packages[@]}"
fi

# Install yay if not installed
if ! is_package_installed "yay"; then
    git clone https://aur.archlinux.org/yay.git
    cd yay || exit
    makepkg -si
    cd ..
    rm -rf yay
fi

# List and install necessary yay packages
yay_packages=("wlogout" "hyprshot")

echo "$(tput setaf 6)Yay packages to be installed:$(tput sgr0)"
printf "$(tput setaf 4)%s$(tput sgr0)\n" "${yay_packages[@]}"
if prompt_yna "Install these yay packages?"; then
    yay -S "${yay_packages[@]}"
fi

# Copy configuration files
config_dir="$HOME/.config"

# Prompt for copying configurations
if prompt_yna "Copy configuration files?"; then
    cp -rv ./hypr "$config_dir/"
    cp -rv ./kitty "$config_dir/"
    cp -rv ./neofetch "$config_dir/"
    cp -rv ./waybar "$config_dir/"
    cp -v .p10k.zsh "$config_dir/"
    cp -v .zshrc "$config_dir/"
else
    echo "$(tput setaf 3)Skipping configuration file copying.$(tput sgr0)"
fi

# Prompt for monitor refresh rate until a valid integer is provided
while true; do
    read -rp "Enter the Monitor refresh rate you want: " monitor_hz
    if [[ -z $monitor_hz ]]; then
        echo "$(tput setaf 3):: Warning - Input cannot be empty.$(tput sgr0)"
    elif ! [[ $monitor_hz =~ ^[0-9]+$ ]]; then
        echo "$(tput setaf 1):: Error - '$monitor_hz' is not a valid integer.$(tput sgr0)"
    else
        break
    fi
done

# Update hyprland.conf on line 16
sed -i "16 s/^monitor=.*/monitor=$connected_display,$selected_resolution@$monitor_hz,0x0,1/" "$config_dir/hypr/hyprland.conf"

# Prompt for cloning NvChad and running nvim
if prompt_yna "Clone NvChad and run nvim?"; then
    echo "$(tput setaf 6)Neovim using NvChad:$(tput sgr0)"
    echo "NvChad will ask you the default configuration, please enter 'n'."
    git clone https://github.com/NvChad/NvChad "$config_dir/nvim" --depth 1 && nvim
else
    echo "$(tput setaf 3)Skipping NvChad cloning and nvim execution.$(tput sgr0)"
fi

echo "$(tput setaf 2)Installation completed successfully.$(tput sgr0)"

