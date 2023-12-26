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

# Step 1: List and install necessary pacman packages
pacman_packages=("neofetch" "zsh" "hyprland" "hyprpaper" "waybar" "rofi" "ttf-jetbrains-mono" "kitty" "git")

echo "$(tput setaf 6)Pacman packages to be installed:$(tput sgr0)"
printf "$(tput setaf 4)%s$(tput sgr0)\n" "${pacman_packages[@]}"
if prompt_yna "Install these pacman packages?"; then
    sudo pacman -S "${pacman_packages[@]}"
fi

# Step 2: Install yay if not installed
if ! is_package_installed "yay"; then
    git clone https://aur.archlinux.org/yay.git
    cd yay || exit
    makepkg -si
    cd ..
    rm -rf yay
fi

# Step 3: List and install necessary yay packages
yay_packages=("wlogout" "hyprshot")

echo "$(tput setaf 6)Yay packages to be installed:$(tput sgr0)"
printf "$(tput setaf 4)%s$(tput sgr0)\n" "${yay_packages[@]}"
if prompt_yna "Install these yay packages?"; then
    yay -S "${yay_packages[@]}"
fi

# Step 4: Copy configuration files
config_dir="$HOME/.config"
config_paths=(
    "$(pwd)/hypr"
    "$(pwd)/kitty"
    "$(pwd)/neofetch"
    "$(pwd)/waybar"
    "$(pwd)/.p10k.zsh"
    "$(pwd)/.zshrc"
)

# Prompt for copying configurations
case "$(prompt_yna "Copy configuration files?")" in
    0 ) # Yes
        for path in "${config_paths[@]}"; do
            cp -r "$path" "$config_dir"
        done
        ;;
    * ) # No
        echo "$(tput setaf 3)Skipping configuration file copying.$(tput sgr0)"
        ;;
esac

echo "$(tput setaf 2)Installation completed successfully.$(tput sgr0)"

