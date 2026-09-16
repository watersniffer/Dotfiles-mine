# Dotfiles

My personal Arch Linux dotfiles and setup with **Hyprland** (Wayland), **Zsh + Powerlevel10k**, **Kitty**, **Neovim**, **Waybar**, **Rofi**, **Mako** and **Matugen** dynamic theming.

## Contents

```
.
├── install.sh                    # Main install script
├── packages.txt                  # Official repo packages (pacman)
├── packages-aur.txt              # AUR packages (via yay)
├── packages-flatpak.txt          # Flatpak apps
├── home/                         # Dotfiles linked to $HOME
│   ├── .zshrc
│   ├── .p10k.zsh                 # Powerlevel10k config (Tokyo Night / rose-pine)
│   ├── .tmux.conf
│   ├── .bashrc / .bash_profile / .bash_logout
├── config/                       # Configs for ~/.config/
│   ├── hypr/                     # Hyprland (Lua config)
│   ├── kitty/                    # Terminal
│   ├── waybar/                   # Status bar (+ Waycat/Skulltype cat/skull fonts)
│   ├── nvim/                     # Neovim (lazy.nvim)
│   ├── rofi/                     # Launcher
│   ├── mako/                     # Notifications
│   ├── fastfetch/                # System fetch
│   ├── matugen/                  # Material You theming (wallpaper-driven)
│   ├── sweetbg/ sweetwall/       # Wallpaper daemon + picker
│   ├── gtk-3.0/ gtk-4.0/         # GTK theme settings
│   └── ...
├── local/bin/                    # Custom scripts (volume, screenshot, powermenu, ...)
├── systemd/user/                 # User systemd units
└── system/etc/                   # System-wide configs (SDDM, cpu-performance)
```

## Requirements

- **Arch Linux** (fresh install recommended)
- Working internet connection
- `base`, `base-devel`, `linux`, `linux-firmware`, `sudo` already present
- The target machine is expected to be an **Intel/AMD hybrid-graphics laptop** (backlight, battery, performance governor etc. are tuned for one)

## Usage

```bash
# Clone the repo (edit to your fork)
git clone https://github.com/watersniffer/Dotfiles-mine.git && cd Dotfiles-mine

chmod +x install.sh
./install.sh               # Full install (packages + configs)
./install.sh --skip-pkgs   # Only link configs, skip package installation
```

## What the installer does

1. **Enables multilib** in pacman.conf
2. **Installs official packages** from `packages.txt` via `pacman -S --needed`
3. **Installs yay** (AUR helper) from source if missing
4. **Installs AUR packages** from `packages-aur.txt` via `yay`
5. **Installs Flatpak apps** from `packages-flatpak.txt` (adds Flathub)
6. **Installs Oh My Zsh** + zsh-autosuggestions, zsh-syntax-highlighting, zsh-vi-mode + Powerlevel10k
7. **Installs TPM** (tmux plugin manager)
8. **Links / copies** all configs (old files backed up to `~/.dotfiles-backup/`)
9. **Applies system configs** (SDDM, cpu-performance.service) and enables services
10. **Sets up user services** (pipewire, wireplumber, SLSsteam guardian optional)
11. **Sets zsh as default shell**

## Post-install steps

1. Log out and back in (wayland + zsh).
2. Drop wallpapers into `~/Pictures/Wallpapers/` — Hyprland/Kitty/Waybar colors are generated from your wallpaper by **matugen**.
3. First `nvim` launch installs all plugins automatically (lazy.nvim).
4. Kitty multi-open a terminal and run `p10k configure` if you want to redo the prompt.
5. SDDM will use the gruvbox-minimal theme if `gruvbox-minimal-sddm` is installed; otherwise the default theme is used.
6. First `tmux` launch installs plugins via TPM (prefix `C-Space`, then `I`).

## Day-to-day

- `all-update` — update pacman + AUR + flatpak
- `update` — pacman update + orphan cleanup + reboot prompt
- `rand-wallpaper` / `Sweetwall` (`SUPER+N`) — change wallpaper, re-themes everything
- `powermenu` (`SUPER+P`) — shutdown/reboot/lock/suspend/logout
- `themesw` — toggle dark/light theme