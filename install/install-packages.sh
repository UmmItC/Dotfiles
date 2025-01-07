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

        sleep 1
        clear
    else
        echo "${COLOR_YELLOW}:: Skipping main package installation.${COLOR_RESET}"
        
        sleep 1
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

            sleep 1
            clear
        else
            echo "${COLOR_YELLOW}:: Skipping GPU package installation.${COLOR_RESET}"

            sleep 1
            clear
        fi
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

main() {
    clear
    # Display the banner
    display_banner

    # Install main packages
    install_main_packages

    # Install GPU packages
    install_gpu_package
}

# Run the main function
main
