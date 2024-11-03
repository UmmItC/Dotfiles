#!/bin/bash

# Function to install Pacman packages
install_pacman_packages() {
    local packages=(
        "zsh" "kitty"
        "neovim" "vim"
        "cliphist" "clipmenu"
        "ly"
        "hyprland" "hyprlock" "hypridle" "xdg-desktop-portal-hyprland"
        "ttf-jetbrains-mono" "ttf-jetbrains-mono-nerd" "papirus-icon-theme"
        "waybar" "rofi" "fastfetch" "wf-recorder" "swaync"
        "pipewire-jack" "pipewire-alsa" "pipewire-pulse" "qjackctl" "pavucontrol" "wireplumber"
        "mpv"
    )

    local total_packages=${#packages[@]}
    echo -e "${COLOR_GREEN}:: Pacman packages to be installed - Package (${total_packages})${COLOR_RESET}"

    for package in "${packages[@]}"; do
        echo -e "${COLOR_GREY}$package${COLOR_RESET}"
    done

    if prompt_yna ":: Install these pacman packages?"; then
        sudo pacman -S "${packages[@]}"

        sleep 1
        clear
    else
        echo "${COLOR_YELLOW}:: Skipping pacman package installation.${COLOR_RESET}"
        
        sleep 1
        clear
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

            sleep 1
            clear
        else
            echo "${COLOR_YELLOW}:: Skipping GPU package installation.${COLOR_RESET}"

            sleep 1
            clear
        fi
    else
 echo "${COLOR_YELLOW}:: AMDGPU driver not detected. These packages are typically used with AMD GPUs. Installation aborted.${COLOR_RESET}"
    fi
}

# Function to install AUR packages
install_aur_packages() {
    local aur_packages=("hyprshot" "hyprswitch" "hyprpicker" "swww" "wlogout" "emote" "woomer" "bibata-cursor-theme")
    echo "${COLOR_GREEN}:: AUR packages to be installed:${COLOR_RESET}"

    for package in "${aur_packages[@]}"; do
        echo "${COLOR_GREY}$package${COLOR_RESET}"
    done

    if prompt_yna ":: Install these AUR packages?"; then
        yay -S "${aur_packages[@]}"

        sleep 1
        clear
    else
      echo "${COLOR_YELLOW}:: Skipping AUR package installation.${COLOR_RESET}"

      sleep 1
      clear
    fi
}

# Function to display the banner
display_banner() {
    echo -e "${COLOR_GRAY}---------------------------------------------------------${COLOR_RESET}"
    echo -e "${COLOR_BLUE}Part 1: Installing Required Packages${COLOR_RESET}"
    echo -e "${COLOR_BLUE}This part will install the necessary packages from pacman and AUR.${COLOR_RESET}"
    echo -e "${COLOR_BLUE}Packages are categorized into tool packages, GPU packages, and AUR packages (yay).${COLOR_RESET}"
    echo -e "${COLOR_BLUE}You will be prompted to choose whether to proceed with each installation.${COLOR_RESET}"
    echo -e "${COLOR_BLUE}Type 'n' or 'no' if you wish to skip a package.${COLOR_RESET}"
    echo -e "${COLOR_GRAY}---------------------------------------------------------${COLOR_RESET}"
}

main(){
    clear
    # Display the banner
    display_banner

    # Install pacman packages
    install_pacman_packages

    # Install AUR packages
    install_aur_packages

    # Install GPU packages
    install_gpu_package
}

# Run the main function
main
