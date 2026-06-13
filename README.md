# Dotfiles

Personal Linux desktop dotfiles for Sway, i3, Waybar, kitty, rofi, GTK/XFCE
theming, shell setup, helper scripts, and Neovim.

## Layout

The repository mirrors paths under `$HOME`, so a file like
`.config/sway/config` is installed as `~/.config/sway/config`.

Included:

- `.config/nvim`
- `.config/sway`
- `.config/i3`
- `.config/waybar`
- `.config/kitty`
- `.config/rofi`
- `.config/gtk-3.0` and `.config/gtk-4.0`
- selected `.config/xfce4` terminal/theme settings
- `.zshrc`, `.bashrc`, `.profile`, `.gitconfig`
- `.local/bin/sway-nvidia` and `.local/bin/hyprland-nvidia`

## Install

Required font packages on Arch/EndeavourOS:

```sh
sudo pacman -S --needed ttf-jetbrains-mono-nerd ttf-nerd-fonts-symbols
```

Clone and run the installer:

```sh
git clone https://github.com/Berger-Stefan/nvim.git ~/dotfiles
cd ~/dotfiles
./install.sh --dry-run
./install.sh
```

The installer symlinks every tracked config file into `$HOME`. Existing files
are moved to `~/.dotfiles-backup-YYYYMMDD-HHMMSS` before linking.

## Notes

- Dated backup files from the workstation are intentionally not tracked.
- Neovim now lives under `.config/nvim` in this all-in-one layout.
- The repository currently uses the existing `Berger-Stefan/nvim` remote. If
  you rename it to `dotfiles` on GitHub, update the clone URL above.
