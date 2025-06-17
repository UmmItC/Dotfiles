# Dotfiles

[![Ask DeepWiki](https://deepwiki.com/badge.svg)](https://deepwiki.com/UmmItC/Dotfiles)
[![Arch Linux](https://img.shields.io/badge/Arch_Linux-1793D1?logo=arch-linux&logoColor=fff)](https://archlinux.org)
[![Hyprland](https://img.shields.io/badge/Hyprland-1A1B26?logo=hyprland&logoColor=fff)](https://hyprland.org)

This repository is dedicated to my Hyprland DWM Arch Linux configuration files.

[Watch this video on YouTube](https://www.youtube.com/watch?v=sjeKlj8mTjE)

## Screenshots

<details>
<summary>Click to expand/collapse screenshots</summary>

![App Launcher](https://dl.ummit.dev/dotfiles-20250217/app-launcher.png)
![Clipboard](https://dl.ummit.dev/dotfiles-20250217/clipboard.png)
![Color Picker](https://dl.ummit.dev/dotfiles-20250217/color-picker.png)
![Neovim 2](https://dl.ummit.dev/dotfiles-20250217/neovim-2.png)
![Neovim](https://dl.ummit.dev/dotfiles-20250217/neovim.png)
![Panel](https://dl.ummit.dev/dotfiles-20250217/panel.png)
![Power Management 2](https://dl.ummit.dev/dotfiles-20250217/power-management-2.png)
![Power Management](https://dl.ummit.dev/dotfiles-20250217/power-management.png)
![Upgrade](https://dl.ummit.dev/dotfiles-20250217/upgrade.png)
![Wallpaper Picker](https://dl.ummit.dev/dotfiles-20250217/wallpaper-picker.png)
![Windows 2](https://dl.ummit.dev/dotfiles-20250217/windows-2.png)
![Windows](https://dl.ummit.dev/dotfiles-20250217/windows.png)

</details>

# Installation Instructions

We offer multiple installation methods for UmmItOS. Choose the one that best fits your needs:

## Quick Remote Installation (Recommended)

The fastest way to get started! This method automatically downloads and runs the setup script without requiring manual cloning. The script uses shallow cloning for optimal performance.

```bash
bash <(curl -s https://raw.githubusercontent.com/UmmItC/Dotfiles/main/setup.sh)
```

## CLI Installation

If you prefer to have CLI installation:

```bash
git clone --depth 1 --shallow-submodules --recursive https://github.com/UmmItC/Dotfiles.git
cd Dotfiles
./install.sh
```

## Experimental TUI Installation (Not finish.)

Try our new Terminal User Interface for a more interactive experience:

```bash
./install-menu.sh
```

> **Note:** The TUI installation is currently in experimental phase. Copying file still be under development.

## Usage packages

Here's a list of the packages I used.

>Note: The list is not exhaustive, and I may have missed some packages. For a complete list, you can refer to the `./configs/hypr/hyprland/plugins.conf` file. and for the laptop configuration, you can refer to the `./configs/hypr/hyprland/laptop.conf` file.

| Module Type              | Module Name     | Package Manager |
|--------------------------|-----------------|-----------------|
| System Information       | Fastfetch       | Pacman          |
| Prompt Theme             | Starship        | Pacman          |
| Terminal Emulator        | Kitty           | Pacman          |
| Shell                    | Nushell         | Pacman          |
| Text Editor              | Neovim          | Pacman          |
| Text Editor              | Vim             | Pacman          |
| Window Manager           | Hyprland        | Pacman          |
| XDG Portal               | xdg-desktop-portal-hyprland | Pacman |
| Power Management         | Wlogout         | AUR             |
| Status Bar               | Waybar          | Pacman          |
| Application Launcher     | Rofi            | Pacman          |
| Wallpaper Engine         | Swww            | Pacman          |
| Notification Daemon      | Swaync          | Pacman          |
| Clipboard Utility        | Cliphist        | Pacman          |
| Clipboard Manager        | Clipmenu        | Pacman          |
| Screenlock Management    | Hyprlock        | Pacman          |
| Screenshot Tool          | Hyprshot        | AUR             |
| Screenshot Tool          | Grim            | Pacman          |
| Display Manager          | Ly              | Pacman          |
| Sound Server             | Pipewire        | Pacman          |
| Audio Control            | Pavucontrol     | Pacman          |
| Audio Control            | Qjackctl        | Pacman          |
| Audio Session Manager   | Wireplumber     | Pacman          |
| Graphics Drivers         | Mesa            | Pacman          |
| Vulkan Drivers           | Vulkan-radeon   | Pacman          |
| Image Processing         | ImageMagick     | Pacman          |
| JSON Processor           | JQ              | Pacman          |
| File Manager             | Yazi            | Pacman          |
| AUR Helper               | Paru            | Manually (Git)  |
| Icon Theme               | Papirus         | Pacman          |
| GTK Theme                | Orchis          | Pacman          |
| Cursor Theme             | Bibata          | AUR             |
| IDLE Management          | Hypridle        | Pacman          |
| Screen Recorder          | wf-recorder     | Pacman          |
| Font                     | JetBrains Mono  | Pacman          |
| Font                     | JetBrains Nerd  | Pacman          |
| Font                     | Overpass        | Pacman          |
| Font                     | GNU Free Fonts  | Pacman          |
| Font                     | Apple font (SF Pro)          | AUR             |
| Windows Management       | Hyprswitch      | AUR             |
| Video Player             | MPV             | Pacman          |
| Emoji Picker             | Smile           | AUR             |
| Color Picker             | Hyprpicker      | Pacman          |
| Zoomer                   | Woomer          | AUR             |
| Brightness Control       | Brightnessctl   | Pacman (Laptop) |
| Media Control            | Playerctl       | Pacman (Laptop) |
    
## Keybindings

The hotkeys for managing your windows and launching tools are configured in the Hyprland configuration file located at `./configs/hypr/hyprland/launcher.conf`. and for the laptop configuration, you can refer to the `./configs/hypr/hyprland/laptop.conf` file.

| Key Combination   | Action                     |
|-------------------|----------------------------|
| `Superkey + T`    | Launch Kitty               |
| `Superkey + C`    | Kill Windows               |
| `Superkey + V`    | Toggle Floating Windows    |
| `Superkey + J`    | Swap Windows               |
| `Superkey + X`    | Launch Wlogout             |
| `Superkey + L`    | Lock Screen (Hyprlock)     |
| `ALT_L + V`       | Launch Clipboard Manager   |
| `ALT_L + W`       | Launch Wallpaper Picker    |
| `ALT_L + E`       | Launch Emoji Picker        |
| `ALT_L + TAB`     | Switch Windows             |
| `ALT_L + P`       | Launch Color Picker        |
| `ALT_L + O`       | Launch Zoomer              |

## Contributing

See the [contributing guidelines](./CONTRIBUTING.md) for more information.

## More information

For more information of my dotfiles, please refer to my blog post [here](https://short.ummit.dev/blog-old-dotsfile-guide)