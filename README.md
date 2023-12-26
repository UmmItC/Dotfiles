# Dotfiles

This repository is dedicated to my Hyprland WM Arch Linux configuration files. To use it, enter the following command:

```shell
chmod +x install.sh
./install.sh
```

>This script will automatically installing all the Necessary packages. and Relace all of your current .config files with the same filename. Please be aware of this.

## Require Packages

currently, the repository contains the following configuration files:

- Neofetch (pacman) - System confi
- Powerlevel10k (manually) - oh my zsh theme
- Oh my zsh (pacman) - zsh framework
- Hyprland (pacman) - Windows Manager
- waybar (pacman - Status bar)
- wlogout (yay) - Power management
- hyprshot (yay) - Screenshot
- rofi (pacman) - App launcher
- hyprpaper (pacman) - Wallpaper
- Neovim (NvChad) - text editor

## Necessary Packages

Please install the necessary packages first:

### pacman

```shell
sudo pacman -S neofetch zsh hyprland hyprpaper waybar rofi ttf-jetbrains-mono kitty
```

### For yay

```shell
yay -S wlogout hyprshot
```

## Screenshot

![hyprland](./hyprland.png)
![hyprland-2](./hyprland-2.png)

## Useful tools

If you like to use the terminal for all things, i have some recommend pacakges for you!

- viu (terminal view image) 
