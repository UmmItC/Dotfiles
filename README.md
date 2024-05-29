## Dotfiles

This repository is dedicated to my Hyprland WM Arch Linux configuration files.

### Installation

To use it, execute the following command:

> **⚠️ Warning**
> **This script is currently in beta. For added safety, it's advisable to manually copy the file to **~/.config/** rather than executing it directly.**
> **Running this script will automatically install all required packages and overwrite any existing .config files with the same filenames. Make sure to back up any important configurations before proceeding.**

```shell
bash <(curl -s https://codeberg.org/UmmIt/Dotfiles/raw/branch/main/setup.sh)
```

### Require Packages

currently, the repository contains the following configuration files:

- Neofetch (pacman) - System config
- Powerlevel10k (manually) - oh my zsh theme
- Oh my zsh (pacman) - zsh framework
- Hyprland (pacman) - Windows Manager
- waybar (pacman - Status bar)
- wlogout (yay) - Power management
- hyprshot (yay) - Screenshot
- fuzzel (pacman) - App launcher
- hyprpaper (pacman) - Wallpaper
- Neovim (NvChad) - text editor
- mako (pacman) - Simple Notification
- cliphist, clipmenu (pacman) - Clipboard manager and Clipboard menu
- Hyprlock (pacman) - Screenlock for hyprland

### Screenshots

![Hyprland Fullscreen](./screenshots/fullscreen.png)
![Hyprland Fuzzel](./screenshots/fullscreen-fuzzel.png)
![Hyprland Cliphist dmenu](./screenshots/fullscreen-cliphist-dmenu.png)
![Hyprlock](./screenshots/hyprlock.png)
