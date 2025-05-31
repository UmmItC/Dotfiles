#!/bin/bash

# Import configuration and utility functions
source "$(dirname "$0")/install-config.sh"

# Clear screen
clear_screen() {
    printf '\033[2J\033[H'
}

pause() {
    read -p "Press Enter to continue..."
}

# Draw header
draw_header() {
    echo -e "${COLOR_BLUE}╔══════════════════════════════════════════════════════════════╗"
    echo -e "║                    UmmIt OS INSTALLATION MENU :D             ║"
    echo -e "╚══════════════════════════════════════════════════════════════╝${COLOR_RESET}\n"
}

# Simple menu function
simple_menu() {
    local title="$1"
    shift
    local options=("$@")
    local selected=0
    local total=${#options[@]}
    
    while true; do
        clear_screen
        draw_header
        echo -e "${COLOR_YELLOW}${title}${COLOR_RESET}\n"
        
        # Display options
        for i in "${!options[@]}"; do
            if [ $i -eq $selected ]; then
                echo -e "${COLOR_WHITE}► ${COLOR_YELLOW}${options[$i]}${COLOR_RESET}"
            else
                echo -e "  ${COLOR_GREEN}${options[$i]}${COLOR_RESET}"
            fi
        done
        
        echo -e "\n${COLOR_GRAY}↑/↓ Navigate │ Enter Select │ b Back │ q Quit${COLOR_RESET}"
        
        # Read input
        read -rsn1 key
        case "$key" in
            $'\033') # Arrow keys
                read -rsn2 key
                case "$key" in
                    '[A') # Up
                        ((selected--))
                        [ $selected -lt 0 ] && selected=$((total-1))
                        ;;
                    '[B') # Down
                        ((selected++))
                        [ $selected -ge $total ] && selected=0
                        ;;
                esac
                ;;
            '') # Enter
                return $selected
                ;;
            'b'|'B') # Back
                return 254
                ;;
            'q'|'Q') # Quit
                return 255
                ;;
        esac
    done
}

# Real installation functions
install_main_package() {
    clear_screen
    display_banner "$MSG_MAIN_BANNER"
    
    if ! packages_string=$(read_packages_from_file "$PACKAGES_MAIN"); then
        read -p "Press Enter to continue..."
        return 1
    fi
    
    # Convert string to array
    local packages=($packages_string)
    
    if [[ ${#packages[@]} -eq 0 ]]; then
        echo -e "${COLOR_RED}:: No packages found in $PACKAGES_MAIN${COLOR_RESET}"
        read -p "Press Enter to continue..."
        return 1
    fi
    
    echo -e "${COLOR_GREEN}:: Main packages to be installed${COLOR_RESET}"
    local total_packages=${#packages[@]}
    printf "%s\n" "${packages[@]}" | column
    
    if prompt_yna ":: Install these packages? - Total Package (${total_packages})"; then
        install_packages_with_paru "${packages[@]}"
        if [[ $? -eq 0 ]]; then
            echo -e "${COLOR_GREEN}✓ Main packages installed successfully!${COLOR_RESET}"
            echo -e "${COLOR_GREEN}:: [1/5] Main packages installed successfully!${COLOR_RESET}"
        else
            echo -e "${COLOR_RED}✗ Error installing main packages${COLOR_RESET}"
        fi
        read -p ":: Main packages installation completed. Press any key to keep going :)"
        clear
    else
        echo -e "${COLOR_YELLOW}:: Skipping main package installation.${COLOR_RESET}"
        read -p ":: Main packages installation skipped. Press any key to keep going :)"
        clear
    fi
}

install_gpu_package() {
    clear_screen
    
    # Check if AMD GPU is detected
    if has_amdgpu; then
        :
    else
        echo -e "${COLOR_YELLOW}:: AMD GPU not detected. Skipping GPU package installation.${COLOR_RESET}"
        read -p "Press Enter to continue..."
        return 0
    fi

    # Check if Nvidia GPU is detected
    if has_nvidia; then
        echo -e "${COLOR_YELLOW}:: Nvidia GPU detected, but unfortunatly, this script is not support Nvidia GPU.${COLOR_RESET}"
        echo -e "${COLOR_YELLOW}:: Since UmmItOS owner (UmmIt) is using AMD GPU, I dont even have Nvidia GPU to test for this script.${COLOR_RESET}"
        echo -e "${COLOR_YELLOW}:: So, feel free to contribute to this script to support Nvidia GPU XD${COLOR_RESET}"
        read -p "Press Enter to continue..."
        return 0
    else
        :
    fi
    
    if packages_string=$(read_packages_from_file "$PACKAGES_GPU"); then
        :
    else
        echo -e "${COLOR_RED}:: There's no packages can be read from $PACKAGES_GPU ????${COLOR_RESET}"
        echo -e "${COLOR_RED}:: Are you clone the repo correctly? Check the repo please!${COLOR_RESET}"
        read -p "Press Enter to continue..."
        return 1
    fi
    
    # Convert string to array
    local packages=($packages_string)
    
    if [[ ${#packages[@]} -eq 0 ]]; then
        echo -e "${COLOR_RED}:: No packages found in $PACKAGES_GPU${COLOR_RESET}"
        read -p "Press Enter to continue..."
        return 1
    fi
    
    echo -e "${COLOR_GREEN}:: GPU packages to be installed${COLOR_RESET}"
    local total_packages=${#packages[@]}
    printf "%s\n" "${packages[@]}" | column
    
    if prompt_yna ":: Install these GPU packages? - Total Package (${total_packages})"; then
        install_packages_with_paru "${packages[@]}"
        if [[ $? -eq 0 ]]; then
            echo -e "${COLOR_GREEN}✓ GPU packages installed successfully!${COLOR_RESET}"
            echo -e "${COLOR_GREEN}:: [2/5] GPU packages installed successfully!${COLOR_RESET}"
        else
            echo -e "${COLOR_RED}✗ Error installing GPU packages${COLOR_RESET}"
        fi
        read -p ":: GPU packages installation completed. Press any key to keep going :)"
        clear_screen
    else
        echo -e "${COLOR_YELLOW}:: Skipping GPU package installation.${COLOR_RESET}"
        read -p ":: GPU packages installation skipped. Press any key to keep going :)"
        clear_screen
    fi
}

install_laptop_package() {
    clear_screen
    
    if is_laptop; then
        :
    else
        echo -e "${COLOR_YELLOW}:: Laptop not detected, so the package is no need to install.${COLOR_RESET}"
        read -p "Press Enter to continue..."
        clear_screen
        return 0
    fi
    
    display_banner "$MSG_LAPTOP_BANNER"
    
    if ! packages_string=$(read_packages_from_file "$PACKAGES_LAPTOP"); then
        read -p "Press Enter to continue..."
        return 1
    fi
    
    # Convert string to array
    local packages=($packages_string)
    
    if [[ ${#packages[@]} -eq 0 ]]; then
        echo -e "${COLOR_RED}:: No packages found in $PACKAGES_LAPTOP${COLOR_RESET}"
        read -p "Press Enter to continue..."
        return 1
    fi
    
    echo -e "${COLOR_GREEN}:: Laptop packages to be installed${COLOR_RESET}"
    local total_packages=${#packages[@]}
    printf "%s\n" "${packages[@]}" | column
    
    if prompt_yna ":: Install these laptop packages? - Total Package (${total_packages})"; then
        install_packages_with_paru "${packages[@]}"
        if [[ $? -eq 0 ]]; then
            echo -e "${COLOR_GREEN}✓ Laptop packages installed successfully!${COLOR_RESET}"
            echo -e "${COLOR_GREEN}:: [3/5] Laptop packages installed successfully!${COLOR_RESET}"
        else
            echo -e "${COLOR_RED}✗ Error installing laptop packages${COLOR_RESET}"
        fi
        read -p ":: Laptop packages installation completed. Press any key to keep going :)"
        clear
    else
        echo -e "${COLOR_YELLOW}:: Skipping laptop package installation.${COLOR_RESET}"
        read -p ":: Laptop packages installation skipped. Press any key to keep going :)"
        clear
    fi
}

copy_dotfiles() {
    clear_screen
    echo -e "${COLOR_BLUE}:: Copying dotfiles...${COLOR_RESET}"
    
    # Check if the script exists
    if [[ -f "./copy-config.sh" ]]; then
        echo -e "${COLOR_GREEN}:: Running copy-config.sh script...${COLOR_RESET}"
        echo -e "${COLOR_YELLOW}:: tesing now, not running anything now.${COLOR_RESET}"
        pause
        if [[ $? -eq 0 ]]; then
            echo -e "${COLOR_GREEN}✓ Dotfiles, commands successfully!${COLOR_RESET}"
            echo -e "${COLOR_GREEN}:: [4/5] Dotfiles, commands successfully!${COLOR_RESET}"
        else
            echo -e "${COLOR_RED}✗ Error copying dotfiles${COLOR_RESET}"
        fi
    else
        echo -e "${COLOR_YELLOW}:: copy-config.sh not found, have you clone the repo correctly or you delete the script? Check the repo please.${COLOR_RESET}"
        read -p "Press Enter to continue..."
    fi

    # Check if the script run successfully
    if [[ $? -eq 0 ]]; then
        echo -e "${COLOR_GREEN}:: Copying dotfiles completed. Also sucessfully run the commands.${COLOR_RESET}"
    else
        echo -e "${COLOR_RED}:: Command run failed. try run again?${COLOR_RESET}"
    fi
}

enable_ly_service() {
    clear_screen

    # Check if ly is installed
    if ! command -v ly-dm &> /dev/null; then
        echo -e "${COLOR_RED}:: ly is not installed. turn back to main menu and install our main packages first.${COLOR_RESET}"
        read -p "Press Enter to continue..."
        return 1
    fi
    
    if systemctl is-enabled ly.service &> /dev/null; then
        echo -e "${COLOR_GREEN}:: ly service is already enabled.${COLOR_RESET}"
        echo -e "${COLOR_YELLOW}:: There's nothing to do here.${COLOR_RESET}"
    else
        echo -e "${COLOR_RED}:: ly-dm service is not enabled, now will enable it.${COLOR_RESET}"
        if prompt_yna ":: Enable ly-dm service?"; then
            sudo systemctl enable ly-dm
        else
            echo -e "${COLOR_YELLOW}:: You can enable it later by running 'sudo systemctl enable ly-dm'${COLOR_RESET}"
        fi
    fi
    
    if [[ $? -eq 0 ]]; then
        read -p "Press Enter to continue..."
        return 0
    else
        echo -e "${COLOR_RED}:: Command run failed. try run again?${COLOR_RESET}"
        read -p "Press Enter to continue..."
        return 1
    fi
}

enable_service() {
    enable_ly_service

    if [[ $? -eq 0 ]]; then
        echo -e "${COLOR_GREEN}:: [5/5] Service enabled successfully!${COLOR_RESET}"
    else
        echo -e "${COLOR_RED}:: Service enabled failed. try run again?${COLOR_RESET}"
        read -p "Press Enter to continue..."
        return 1
    fi
}

show_post_install_info() {
    clear_screen
    draw_header

    echo -e "${COLOR_GREEN}🎉 Installation Complete! 🎉${COLOR_RESET}\n"
    echo -e "${COLOR_YELLOW}Post-installation notes:${COLOR_RESET}"
    echo -e "• Reboot your system to ensure all changes take effect"
    echo -e "After reboot, run our settings script to finalize the setup of your system by executing: ${COLOR_GREEN}./post-install.sh --start-config${COLOR_RESET}"
    if has_amdgpu; then
        echo -e "• Verify AMD GPU drivers are working properly"
    fi
    echo ""
    echo -e "${COLOR_BLUE}Enjoy your new system! 🚀${COLOR_RESET}\n"
    read -p "Press Enter to exit..."
}

auto_install_all() {
    clear_screen
    echo -e "\n${COLOR_RED}🚀 AUTOMATIC INSTALLATION MODE${COLOR_RESET}"
    echo -e "${COLOR_YELLOW}This will install everything automatically...${COLOR_RESET}\n"
    
    local confirm_options=("Yes, proceed" "No, go back")
    simple_menu "Are you sure you want to auto-install everything?" "${confirm_options[@]}"
    local choice=$?
    
    if [ $choice -eq 0 ]; then
        echo -e "\n${COLOR_BLUE}Starting automatic installation...${COLOR_RESET}\n"
        
        echo -e "${COLOR_YELLOW}[1/5] Installing main packages...${COLOR_RESET}"
        pause
        install_main_package
        
        echo -e "${COLOR_YELLOW}[2/5] Installing GPU packages...${COLOR_RESET}"
        pause
        install_gpu_package
        
        echo -e "${COLOR_YELLOW}[3/5] Installing laptop packages...${COLOR_RESET}"
        pause
        install_laptop_package
        
        echo -e "${COLOR_YELLOW}[4/5] Copying dotfiles...${COLOR_RESET}"
        pause
        copy_dotfiles
        
        echo -e "${COLOR_YELLOW}[5/5] Enabling service...${COLOR_RESET}"
        pause
        enable_service
        
        echo -e "\n${COLOR_GREEN}🎉 Automatic installation completed!${COLOR_RESET}"
        pause
        show_post_install_info
        return 0
    else
        return 254  # Go back
    fi
}

# Package installation submenu
package_menu() {
    local package_options=("Main packages" "GPU packages" "Laptop packages" "Back to main menu")
    
    while true; do
        simple_menu "📦 Package Installation:" "${package_options[@]}"
        local choice=$?
        
        case $choice in
            0) install_main_package ;;
            1) install_gpu_package ;;
            2) install_laptop_package ;;
            3|254) return ;; # Back to main menu
            255) exit 0 ;; # Quit
        esac
    done
}

# Main menu
main_menu() {
    local main_options=(
        "📦 Install packages"
        "📁 Copy dotfiles" 
        "🚀 Enable service"
        "📋 Show post-install info"
        "⚡ Auto-install Process [1-5]"
        "❌ Exit the installer"
    )
    
    while true; do
        simple_menu "🔧 If you are a new user, please select auto-install everything. \nOnly you know what you are doing if you choose to manually install process.)" "${main_options[@]}"
        local choice=$?
        
        case $choice in
            0) package_menu ;;
            1) copy_dotfiles ;;
            2) enable_service ;;
            3) show_post_install_info ;;
            4) auto_install_all && exit 0 ;;
            5|255) 
                clear_screen
                echo -e "${COLOR_GREEN}Thanks for using the installer! 👋${COLOR_RESET}"
                exit 0 
                ;;
        esac
    done
}

# Trap Ctrl+C
trap 'clear_screen; echo -e "\n${COLOR_GREEN}Installation cancelled. Goodbye! 👋${COLOR_RESET}"; exit 0' INT

# Welcome message
welcome() {
    clear_screen
    draw_header
    echo -e "${COLOR_YELLOW}Welcome to the System Installation Script!${COLOR_RESET}\n"
    echo -e "This script will help you:"
    echo -e "• Install essential packages"
    echo -e "• Set up GPU drivers"
    echo -e "• Configure laptop optimizations"
    echo -e "• Copy your dotfiles"
    echo -e "• Enable display manager"
    echo -e "• Or do everything automatically!\n"
    echo -e "${COLOR_GRAY}Press Enter to continue...${COLOR_RESET}"
    read
}

# Main execution
main() {

    # Check if running as root (optional)
    if [[ $EUID -eq 0 ]]; then
        echo -e "${COLOR_RED}:: Run this script is not good idea, as like you run Hyprland as root. Are you stupid?\nSwitch to normal user :)${COLOR_RESET}"
        exit 1
    fi
    
    # Check if running on Arch Linux or Arch based distribution
    if [ -f /etc/arch-release ]; then
        welcome
        main_menu
    else
        echo ""
        echo -e "${COLOR_YELLOW}:: Hey, you need to become arch linux user to run this script xd${COLOR_RESET}"
        echo -e "${COLOR_YELLOW}:: The script is only tested on arch linux environment.${COLOR_RESET}"
        echo -e "${COLOR_YELLOW}:: Any arch based distribution is also supported. like EndeavourOS :D${COLOR_RESET}"
    fi
}

main "$@" 