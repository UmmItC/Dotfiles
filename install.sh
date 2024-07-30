#!/bin/bash

# Define colors
readonly COLOR_YELLOW=$(tput setaf 3)
readonly COLOR_GREEN=$(tput setaf 2)
readonly COLOR_GREY=$(tput setaf 8)
readonly COLOR_DARK_RED=$(tput setaf 1)
readonly COLOR_BLUE=$(tput setaf 4)
readonly COLOR_RESET=$(tput sgr0)

# Function to prompt for Yes/No
prompt_yna() {
    local prompt_message="$1"
    local choice
    while true; do
        read -rp "${COLOR_GREEN}${prompt_message} (Y/N): ${COLOR_RESET}" choice
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
    local packages=(
        "zsh" "kitty"
        "neovim" "vim"
        "cliphist" "clipmenu"
        "ly"
        "hyprland" "hyprlock" "hypridle" "xdg-desktop-portal-hyprland"
        "ttf-jetbrains-mono" "ttf-jetbrains-mono-nerd" "papirus-icon-theme"
        "waybar" "fuzzel" "fastfetch" "wf-recorder" "swaync"
        "pulseaudio" "pavucontrol" "alsa-plugins" "lib32-alsa-plugins" "lib32-alsa-lib"
    )

    local total_packages=${#packages[@]}
    echo "${COLOR_GREEN}:: Pacman packages to be installed - Package (${total_packages})${COLOR_RESET}"

    for package in "${packages[@]}"; do
        echo "${COLOR_GREY}$package${COLOR_RESET}"
    done

    if prompt_yna ":: Install these pacman packages?"; then
        sudo pacman -S "${packages[@]}"
    fi
}

# Function to install GPU packages
install_gpu_package() {
    local pacman_gpu_packages=(
        "amdvlk" "lib32-amdvlk"
        "lib32-mesa" "lib32-mesa-demos" "lib32-mesa-vdpau" "lib32-vulkan-radeon" 
        "libva-mesa-driver" "mesa" "mesa-vdpau" "vulkan-radeon" "xf86-video-amdgpu"
    )

    if lsmod | grep -q '^amdgpu\s'; then
        local total_packages=${#pacman_gpu_packages[@]}

        echo "${COLOR_GREEN}:: GPU packages to be installed - Package (${total_packages})${COLOR_RESET}"

        for package in "${pacman_gpu_packages[@]}"; do
            echo "${COLOR_GREY}$package${COLOR_RESET}"
        done

        if prompt_yna ":: Install these GPU pacman packages?"; then
            sudo pacman -S "${pacman_gpu_packages[@]}"
        fi
    else
        echo "${COLOR_YELLOW}:: AMDGPU driver not detected. These packages are typically used with AMD GPUs. Installation aborted.${COLOR_RESET}"
    fi
}

# Function to install AUR packages
install_aur_packages() {
    local aur_packages=("wlogout" "hyprshot" "swww" "overskride")
    echo "${COLOR_GREEN}:: AUR packages to be installed:${COLOR_RESET}"

    for package in "${aur_packages[@]}"; do
        echo "${COLOR_GREY}$package${COLOR_RESET}"
    done

    if prompt_yna ":: Install these AUR packages?"; then
        yay -S "${aur_packages[@]}"
    fi
}

# Personal setup
install_addition_setup() {
    local packages_pacman=(
        "thunar" "yazi"
        "keepassxc" "bitwarden"
        "fcitx5-chinese-addons" "fcitx5" "fcitx5-table-extra"
        "fcitx5-qt" "fcitx5-gtk" "fcitx5-im"
        "fcitx5-configtool"
        "libime"
        "wqy-zenhei"
    )

    local packages_aur=(
        "librewolf" "mullvad-vpn"
    )
   
    local all_packages=("${packages_pacman[@]}" "${packages_aur[@]}")
    local total_packages=${#all_packages[@]}
    echo -e "\n${COLOR_BLUE}:: This section is tailored to my personal setup.\nIf you prefer to skip it, you can simply type 'n'.\nHowever, if you want to install packages like fcitx5, LibreWolf, Mullvad, and other programs for building from source—please proceed with this section.\nNote that this is the final step and may take some time, as it involves building from source code. [Y/N]${COLOR_RESET}"

    echo -e "\n${COLOR_GREEN}:: Packages to be installed - Total (${total_packages})${COLOR_RESET}"

    echo "${COLOR_GREEN}Pacman Packages:${COLOR_RESET}"
    for package in "${packages_pacman[@]}"; do
        echo "${COLOR_GREY}$package${COLOR_RESET}"
    done

    echo "${COLOR_GREEN}AUR Packages:${COLOR_RESET}"
    for package in "${packages_aur[@]}"; do
        echo "${COLOR_GREY}$package${COLOR_RESET}"
    done

    if prompt_yna ":: Install these packages?"; then
        echo "${COLOR_YELLOW}Installing Pacman packages...${COLOR_RESET}"
        sudo pacman -S "${packages_pacman[@]}"

        echo "${COLOR_YELLOW}Installing AUR packages...${COLOR_RESET}"
        for package in "${packages_aur[@]}"; do
            yay -S "$package"
        done

        # Define the environment variables to add
        local env_vars=(
            "export GTK_IM_MODULE=fcitx"
            "export XMODIFIERS=fcitx"
            "export QT_IM_MODULE=fcitx"
            "export SDL_IM_MODULE=fcitx"
        )

        # Check if the environment variables are already present
        echo "${COLOR_YELLOW}Checking /etc/environment for existing input method variables...${COLOR_RESET}"
        local found_all=true
        for var in "${env_vars[@]}"; do
            if ! sudo grep -q "^${var}$" /etc/environment; then
                found_all=false
                break
            fi
        done

        if ! $found_all; then
            # Append environment variables to /etc/environment
            echo "${COLOR_YELLOW}Updating /etc/environment with input method variables...${COLOR_RESET}"
            sudo bash -c 'cat << EOF >> /etc/environment
export GTK_IM_MODULE=fcitx
export XMODIFIERS=fcitx
export QT_IM_MODULE=fcitx
export SDL_IM_MODULE=fcitx
EOF
'
        else
            echo "${COLOR_GREEN}The input method variables are already present in /etc/environment.${COLOR_RESET}"
        fi
    fi
}

config_dir="$HOME/.config"

# Function to copy and update configuration files
copy_and_update_config_files() {
    # Copy configuration files
    if prompt_yna ":: Copy configuration files?"; then
        cp -rv ./configs/hypr "$config_dir/"
        cp -rv ./configs/kitty "$config_dir/"
        cp -rv ./configs/fastfetch "$config_dir/"
        cp -rv ./configs/waybar "$config_dir/"
        cp -rv ./configs/fuzzel "$config_dir"
        cp -rv ./configs/swaync "$config_dir/"
        cp -rv ./configs/wlogout/ "$config_dir/"

        sudo cp -v ./configs/ly/config.ini /etc/ly
        
        cp -rv ./script "$HOME/"
        
        cp -rv ./.wallpaper/ "$HOME/"
        
        echo "${COLOR_GREEN}:: Configuration files copied successfully.${COLOR_RESET}"
        
        # Verify that the files have been copied
        local hyprland_config="$HOME/.config/hypr/hyprland.conf"
        local hyprlock_config="$HOME/.config/hypr/hyprlock.conf"

        if [[ -f $hyprland_config && -f $hyprlock_config ]]; then
            # Prompt to update configuration files
            if prompt_yna ":: Update hyprland and hyprlock configuration files? (This will also prompt for the monitor refresh rate you want)"; then
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
                sed -i "16 s/^monitor=.*/monitor=$connected_display,$selected_resolution@$monitor_hz,0x0,1/" "$hyprland_config"

                # Update hyprlock.conf
                sed -i "s/monitor = .*/monitor = $connected_display/g" "$hyprlock_config"
            else
                echo "${COLOR_YELLOW}:: Skipping configuration file updates.${COLOR_RESET}"
            fi
        else
            echo "${COLOR_DARK_RED}:: Warning - Some configuration files are missing.${COLOR_RESET}"
        fi
    else
        echo "${COLOR_YELLOW}:: Skipping configuration file copying and updates.${COLOR_RESET}"
    fi
}

# Function to copy Steam configuration files
copy_steam_config_files() {
    if prompt_yna ":: Do you want to copy Steam configuration files?"; then
        if command_exists steam; then
            cp -v ./configs/steam/steam_dev.cfg ~/.steam/steam/
            echo "Steam configuration files copied successfully."
        else
            echo "Steam is not installed. Installing Steam..."
            sudo pacman -S steam
            if [ $? -eq 0 ]; then
                echo "Steam installed successfully."
                cp -v ./configs/steam/steam_dev.cfg ~/.steam/steam/
                echo "Steam configuration files copied successfully."
            else
                echo "Failed to install Steam."
            fi
        fi
    else
        echo "${COLOR_YELLOW}:: Skipping copying of Steam configuration files.${COLOR_RESET}"
    fi
}

# Function to detect and configure Ly as the default display manager
configure_ly() {
    echo -e "${COLOR_YELLOW}:: Setting up Ly as your Default Display Manager. If Ly is already set up, this step will be skipped.${COLOR_RESET}"

    # Check the currently running display manager
    local current_dm=$(ps -eo comm | grep -E '^ly-dm|^gdm|^sddm|^lightdm|^lxdm|^xdm' | head -n 1)
    local dm_packages=("gdm" "sddm" "lightdm" "xdm" "lxdm")

    if [ "$current_dm" == "ly-dm" ]; then
        echo -e "${COLOR_GREEN}:: You are already using Ly as your display manager. Nothing to do. Skipping...${COLOR_RESET}"
    else
        if [ -n "$current_dm" ]; then
            echo -e "${COLOR_GREEN}:: Setting Ly as your default display manager...${COLOR_RESET}"
            sudo systemctl enable ly.service
        fi

        # Disable other display managers if they are active
        for package in "${dm_packages[@]}"; do
            if systemctl is-active --quiet "$package.service"; then
                echo -e "${COLOR_GREEN}:: Disabling $package...${COLOR_RESET}"
                sudo systemctl disable "$package.service"
                echo -e "${COLOR_GREEN}:: Successfully disabled $package as your previous display manager.${COLOR_RESET}"
            fi
        done
    fi
}

# Function to clone NvChad and run Neovim
clone_nvchad_and_run_nvim() {
    if prompt_yna ":: Clone NvChad and run neovim?"; then
        echo "${COLOR_YELLOW}:: After lazy.nvim finishes downloading plugins, execute the command :MasonInstallAll in Neovim."
        git clone https://github.com/NvChad/starter "$HOME/.config/nvim" && nvim
    else
        echo "${COLOR_YELLOW}:: Skipping NvChad cloning and nvim execution.${COLOR_RESET}"
    fi
}

# Function to prompt for installation confirmation
prompt_installation() {
    if prompt_yna ":: Do you want to continue with the installation?"; then
        return 0
    else
        echo "${COLOR_YELLOW}:: Installation aborted.${COLOR_RESET}"
        exit 0
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

    # Install packages
    install_pacman_packages
    install_gpu_package
    check_yay
    install_aur_packages

    # Configure Display Manager
    configure_ly

    # Copy configuration files
    copy_and_update_config_files
    copy_steam_config_files

    # Clone NvChad and run Neovim if user confirms
    clone_nvchad_and_run_nvim

    # Personal setup
    install_addition_setup

    echo "${COLOR_GREEN}:: Installation completed successfully.${COLOR_RESET}"
    echo "${COLOR_GREEN}:: Please reboot your system to apply all changes!${COLOR_RESET}"
}

# Main script execution
if [ -f /etc/arch-release ]; then
    prompt_installation

    # Get the connected display name
    connected_display=$(xrandr | awk '/\<connected\>/ {print $1}')

    # Run whiptail and capture the output
    selected_resolution=$(whiptail --title "Resolution Selection" --menu \
        "Choose a resolution with $connected_display" 20 60 10 \
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
else
    echo "${COLOR_YELLOW}:: Sorry, Script only allows Arch Linux to run.${COLOR_RESET}"
fi
