## Dotfiles

This repository is dedicated to my Hyprland WM Arch Linux configuration files.

### Installation instructions

To use it, execute the following command in your new environment:

***Tips: You can simplify the installation process by leveraging archinstall for easy installation of Arch Linux.***

> **⚠️ Warning**
> **This script is currently in beta. For added safety, it's advisable to manually copy the file to **~/.config/** rather than executing it directly.**
> **Running this script will automatically install all required packages and overwrite any existing .config files with the same filenames. Make sure to back up any important configurations before proceeding.**

```shell
bash <(curl -s https://codeberg.org/UmmIt/Dotfiles/raw/branch/main/setup.sh)
```

### Require Packages

| Module Type              | Module Name   | Package Manager |
|--------------------------|---------------|-----------------|
| System Information       | Fastfetch     | Pacman          |
| Prompt Theme             | Powerlevel10k | Manually (Git)  |
| Terminal                 | Kitty         | Pacman          |
| Shell                    | Oh my zsh     | Pacman          |
| Window Manager           | Hyprland      | Pacman          |
| Power Management         | Wlogout       | AUR             |
| Status Bar               | waybar        | Pacman          |
| Application Launcher     | Fuzzel        | Pacman          |
| Wallpaper Engine         | Hyprpaper     | Pacman          |
| Text Editor              | Neovim        | Pacman          |
| Notification System      | Swaync        | Pacman          |
| Clipboard Utility        | cliphist      | Pacman          |
| Clipboard Manager        | clipmenu      | Pacman          |
| Screenlock Management    | Hyprlock      | Pacman          |
| Screenshot               | Hyprshot      | AUR             |

### Screenshots

![Hyprland Fullscreen](./screenshots/fullscreen.png)
![Hyprland Fuzzel](./screenshots/fullscreen-fuzzel.png)
![Hyprland Cliphist dmenu](./screenshots/fullscreen-cliphist-dmenu.png)
![Hyprlock](./screenshots/hyprlock.png)
