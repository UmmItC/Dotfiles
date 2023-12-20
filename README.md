# Dotfiles

This repository is dedicated to my Linux configuration files and browser extensions. To use it, enter the following command:

```shell
git clone https://gitlab.com/Genlicly/dotfiles
cp dotfiles/* ~/.config/
```

>This will replace all of your current .config files with the same file name. Please be aware of this.

Thanks for using!

## Working

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

Otherwise are optional, Please set `~/.config/hypr/hyprland.conf` by yourself. There should be many people who don't need to use `fcitx5`. As i need `fcitx5` as my input method.

```shell
$terminal kitty #Default terminal
exec-once = waybar & ... & ... # Launch hyprland when started
```

And the ublock just a txt file, just copy these contain on your ublock filter list.

## Install Pacakges

Please install the necessary packages first:

## pacman

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
