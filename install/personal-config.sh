#!/bin/bash

# Function to display the banner
display_banner() {
    echo -e "${COLOR_GRAY}---------------------------------------------------------${COLOR_RESET}"
    echo -e "${COLOR_BLUE}This section is tailored to my personal setup.\n${COLOR_RESET}"
    echo -e "${COLOR_YELLOW}If you prefer to skip it, you can simply type 'n'.${COLOR_RESET}"
    echo -e "${COLOR_YELLOW}However, if you want to install packages like:${COLOR_RESET}"
    echo -e "${COLOR_YELLOW}  - LibreWolf${COLOR_RESET}"
    echo -e "${COLOR_YELLOW}  - Mullvad${COLOR_RESET}"
    echo -e "${COLOR_YELLOW}and other programs for building from source—please proceed with this section.${COLOR_RESET}"
    echo -e "${COLOR_YELLOW}Note that this is the final step and may take some time${COLOR_RESET}"
    echo -e "${COLOR_YELLOW}as it involves building from source code. [Y/N]${COLOR_RESET}"
    echo -e "${COLOR_GRAY}---------------------------------------------------------${COLOR_RESET}"
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

    echo -e "${COLOR_GREEN}:: Packages to be installed - Total (${total_packages})${COLOR_RESET}"

    echo -e "${COLOR_GREEN}Pacman Packages:${COLOR_RESET}"
    for package in "${packages_pacman[@]}"; do
        echo -e "${COLOR_GREY}$package${COLOR_RESET}"
    done

    echo -e "${COLOR_GREEN}AUR Packages:${COLOR_RESET}"
    for package in "${packages_aur[@]}"; do
        echo -e "${COLOR_GREY}$package${COLOR_RESET}"
    done

    if prompt_yna ":: Install these packages?"; then
        echo -e "${COLOR_YELLOW}Installing Pacman packages...${COLOR_RESET}"
        sudo pacman -S "${packages_pacman[@]}"

        sleep 1
        clear

        echo -e "${COLOR_YELLOW}Installing AUR packages...${COLOR_RESET}"
        for package in "${packages_aur[@]}"; do
            yay -S "$package"

            sleep 1
            clear
        done
    fi
}

prompt_copy() {
    if prompt_yna ":: Run it?"; then
      install_addition_setup
    else
      echo "${COLOR_YELLOW}:: Skipping dotfiles and configurations installation.${COLOR_RESET}"

      sleep 2
      clear
    fi
}

# Main function
main() {
    # Display the banner
    display_banner

    # Start the configuration of Ly
    prompt_copy
}

main
