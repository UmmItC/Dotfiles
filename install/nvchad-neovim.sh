#!/bin/bash

# Function to clone NvChad and run Neovim
clone_nvchad_and_run_nvim() {
    if prompt_yna ":: Clone NvChad and run neovim?"; then
        echo "${COLOR_YELLOW}:: After lazy.nvim finishes downloading plugins, execute the command :MasonInstallAll in Neovim."
        git clone https://github.com/NvChad/starter "$HOME/.config/nvim" && nvim

        sleep 1
        clear
    else
        echo "${COLOR_YELLOW}:: Skipping NvChad cloning and nvim execution.${COLOR_RESET}"
        
        sleep 1
        clear
    fi
}

# Main function
main() {
  clone_nvchad_and_run_nvim
}

main
