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
    echo -e "${COLOR_GRAY}---------------------------------------------------------${COLOR_RESET}"
    echo -e "${COLOR_BLUE}Part 1: Installing Required Packages${COLOR_RESET}"
    echo -e "${COLOR_BLUE}This part will install the necessary packages.${COLOR_RESET}"
    echo -e "${COLOR_BLUE}Packages are categorized into tool packages and GPU packages.${COLOR_RESET}"
    echo -e "${COLOR_BLUE}You will be prompted to choose whether to proceed with each installation.${COLOR_RESET}"
    echo -e "${COLOR_BLUE}This will be look long time to complete, since for the AUR package installation was using source code to compile instead of binary.${COLOR_RESET}"
    echo -e "${COLOR_BLUE}Type 'n' or 'no' if you wish to skip a package.${COLOR_RESET}"
    echo -e "${COLOR_GRAY}---------------------------------------------------------${COLOR_RESET}"
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
