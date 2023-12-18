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

- Neofetch (pacman)
- Powerlevel10k (manually)
- Oh my zsh (pacman)
- Hyprland (pacman)
- waybar (pacman)
- wlogout (yay)
- wezterm (pacman)
- hyprshot (yay)
- rofi (pacman)

Otherwise are optional, Please set `~/.config/hypr/hyprland.conf` by yourself. There should be many people who don't need to use `fcitx5`. As i need `fcitx5` as my input method.

```shell
$terminal kgx #Default terminal
$browser #Default browser
exec-once = waybar & ... & ... # Launch hyprland when started
```

And the ublock just a txt file, just copy these contain on your ublock filter list.

## Install Pacakges

Please install the necessary packages first:

## pacman

```shell
sudo pacman -S neofetch zsh hyprland waybar wezterm rofi
```

### For yay

```shell
yay -S wlogout hyprshot
```

## Screenshot

![hyprland](./hyprland.png)
