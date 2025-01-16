#!/bin/bash

# Function to install main packages
install_main_packages() {
    local main_packages=()

    # Read packages from the packages_main file, skipping empty lines
    while IFS= read -r package; do
        # Check if the line is not empty
        if [[ -n "$package" ]]; then
            main_packages+=("$package")
        fi
    done < "./install/packages_main"

    echo "${COLOR_GREEN}:: Main packages to be installed${COLOR_RESET}"

    local total_main_packages=${#main_packages[@]}
    printf "${COLOR_GREY}%s${COLOR_RESET}\n" "${main_packages[@]}" | column

    if prompt_yna ":: Install these packages? - Total Package (${total_main_packages})"; then
        paru -S "${main_packages[@]}"
        
        read -p ":: Main packages installed completed. Press any key to keep going :)"
        clear
    else
        echo "${COLOR_YELLOW}:: Skipping main package installation.${COLOR_RESET}"
 
        read -p ":: Main packages installed skipped. Press any key to keep going :)"
        clear
    fi
}

# Function to install GPU packages
install_gpu_package() {
    local gpu_packages=()

    # Read packages from the packages_gpu file, skipping empty lines
    while IFS= read -r package; do
        # Check if the line is not empty
        if [[ -n "$package" ]]; then
            gpu_packages+=("$package")
        fi
    done < "./install/packages_gpu"

    if lsmod | grep -q '^amdgpu\s'; then
        local total_packages=${#gpu_packages[@]}

        echo "${COLOR_GREEN}:: GPU packages to be installed${COLOR_RESET}"

        printf "${COLOR_GREY}%s${COLOR_RESET}\n" "${gpu_packages[@]}" | column

        if prompt_yna ":: Install these GPU  packages? - Total Package (${total_packages})"; then
            paru -S "${gpu_packages[@]}"

            read -p ":: GPU packages installed completed. Press any key to keep going :)"
            clear
        else
            echo "${COLOR_YELLOW}:: Skipping GPU package installation.${COLOR_RESET}"

            read -p ":: GPU packages installed skipped. Press any key to keep going :)"
            clear
        fi
    fi
}

install_laptop_packages (){
    local laptop_packages=()

    while IFS= read -r package; do
        if [[ -n "$package" ]]; then
            laptop_packages+=("$package")
        fi
    done < "./install/packages_laptop"

    echo "${COLOR_GREEN}:: Laptop packages to be installed${COLOR_RESET}"

    local total_packages=${#laptop_packages[@]}

    printf "${COLOR_GREY}%s${COLOR_RESET}\n" "${laptop_packages[@]}" | column

    if prompt_yna ":: Install these laptop packages? - Total Package (${total_packages})"; then
        paru -S "${laptop_packages[@]}"

        read -p ":: Laptop packages installed completed. Press any key to keep going :)"
        clear
    else
        echo "${COLOR_YELLOW}:: Skipping laptop package installation.${COLOR_RESET}"

        read -p ":: Laptop packages installed skipped. Press any key to keep going :)"
        clear
    fi
}

# Function to display the banner
display_banner() {
    cat <<EOF
${COLOR_GRAY}---------------------------------------------------------${COLOR_RESET}
${COLOR_BLUE}Part 1: Installing Main Packages

This section will install the main packages listed in the packages_main file.
These packages are essential for ensuring that my dotfiles function properly.
The installation process will utilize paru to manage all package installations.
Please note that the installation of AUR packages may take some time, as they will be compiled from source.

The packages will be sourced from the official Arch Linux repositories, including:

- Extra repository
- Multilib repository
- AUR repository${COLOR_RESET}
${COLOR_GRAY}---------------------------------------------------------${COLOR_RESET}
EOF
}

display_banner_laptop() {
    cat <<EOF
${COLOR_GRAY}---------------------------------------------------------${COLOR_RESET}
${COLOR_BLUE}You saw this banner because you were detected as a laptop user.
This script will install brightnessctl and playerctl packages.
Which is useful for controlling screen brightness and media players.
and my dotfiles also use these tools.${COLOR_RESET}
${COLOR_GRAY}---------------------------------------------------------${COLOR_RESET}
EOF
}

main() {
    clear
    # Display the banner
    display_banner

    # Install main packages
    install_main_packages

    # Install GPU packages
    install_gpu_package

    # Install laptop packages
    if [[ -f /sys/class/power_supply/BAT0/capacity ]]; then
        display_banner_laptop
        install_laptop_packages
    fi
}

# Run the main function
main
