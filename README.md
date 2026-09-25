# Dotfiles

My personal Arch Linux dotfiles: **Hyprland** (Wayland, Lua config), **Bash + Starship**, **Kitty**, **Neovim** (lazy.nvim), **Waybar**, **Rofi**, **Mako** and **Matugen** — all themed **Monochrome** (white accent `#ffffff`) with a static palette that never changes with the wallpaper.

## Contents

```
.
├── install.sh                    # Main install script
├── packages.txt                  # Official repo packages (pacman)
├── packages-aur.txt              # AUR packages (via yay)
├── packages-flatpak.txt          # Flatpak apps
├── home/                         # Dotfiles linked to $HOME
│   ├── .bashrc / .bash_profile / .bash_logout
│   ├── .tmux.conf  .vimrc
│   └── .vim/                     # colorschemes (monochrome)
├── config/                       # Configs for ~/.config/ (symlinked)
│   ├── hypr/                     # Hyprland (Lua config + HyprMod gui lua)
│   ├── kitty/                    # Terminal
│   ├── waybar/                   # Status bar (+ Waycat/Skulltype cat/skull fonts)
│   ├── nvim/                     # Neovim (real dir, copy-if-missing)
│   ├── rofi/                     # Launcher
│   ├── mako/                     # Notifications
│   ├── fastfetch/                # System fetch
│   ├── matugen/                  # Theming (pinned to Monochrome hex)
│   ├── matuwall/                 # Wallpaper picker (no theming hooks)
│   ├── gtk-3.0/ gtk-4.0/         # GTK theme settings (Kripton)
│   ├── btop/ Kvantum/ qt6ct/     # App themes
│   ├── xsettingsd/               # GTK icon/theme propagation
│   └── ...
├── local/bin/                    # Custom scripts (startup/, powermenu, ...)
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
./install.sh --skip-pkgs   # Skip packages; still apply configs/system settings
```

## What the installer does

1. **Leaves multilib configuration unchanged** (no multilib-only packages are required)
2. **Installs official packages** from `packages.txt` via `pacman -S --needed`
3. **Installs yay** from source if missing
4. **Installs AUR packages** from `packages-aur.txt` (Graphite GTK, Kripton, Kvantum, smile, ...)
5. **Installs Flatpak apps** from `packages-flatpak.txt` (adds Flathub)
6. **Installs TPM** (tmux plugin manager)
7. **Links configs** (old files backed up to `~/.dotfiles-backup/`); nvim and qt6ct stay real dirs (copy-if-missing); `local/bin` is **merged**, never
   wiped, so machine-local tools (uv, tree-sitter, uv shims) survive
8. **Applies system configs** (SDDM conf + a pinned, root-owned `gruvbox-minimal-sddm` clone,
   cpu-performance.service, zram) and enables services
9. **Sets up user services** (pipewire, wireplumber)
10. **Sets the GTK/icon/cursor theme in dconf** (GNOME + Cinnamon/Nemo:
    Kripton / Papirus / Bibata-Modern-Classic)
11. **Sets bash as default shell**

Re-running the installer is safe: already-correct symlinks are left untouched.

## Post-install steps

1. Log out and back in (wayland + bash).
2. The installer copies the tracked wallpapers to `~/Pictures/Wallpapers/`; add more there if desired, then press `Super+W` (**Matuwall**). The theme is a static monochrome palette and does **not** change with the wallpaper; `~/.config/matugen/apply.sh <wallpaper>` re-publishes application colors manually, while SDDM remains static and root-owned.
3. First `nvim` launch installs all plugins automatically (lazy.nvim).
4. `starship config` tweaks the prompt.
5. First `tmux` launch installs plugins via TPM (prefix `C-Space`, then `I`).
6. SDDM theme `gruvbox-minimal-sddm` (GitHub-only, not in AUR) is pinned and installed root-owned automatically; the font it needs (`ttf-fantasque-nerd`) comes from `packages.txt`.

### Not managed by the installer (machine-local)

- **uv** (`curl -LsSf https://astral.sh/uv/install.sh | sh`) and its tools:
  `uv tool install hyprmod`
  (HyprMod regenerates `config/hypr/hyprland-gui.lua` from its GUI — if you
  change opacity there, keep it in sync with `hyprland.lua`)
- **tree-sitter CLI** at `~/.local/bin/tree-sitter`
- Browser profiles (Zen `zen-themes.json` + Transparent Zen mod + Zen Internet,
  Firefox): themed in place on this machine, not shipped in the repo

## Keybinds (extra)

| Bind | Action |
|------|--------|
| `Super+E` | yazi file manager in kitty |
| `Super+B` | Helium browser |
| `Super+D` | nemo |
| `Super+,` | smile emoji picker (floating, centered) |
| `Super+C` | clipboard history via rofi (cliphist) |
| `Super+W` | matuwall wallpaper picker |
| `Super+Shift+W` | hide/show Waybar |
| `XF86MonBrightnessUp/Down` | adjust screen brightness |
| Waybar backlight module | toggle Night Light |
| `Super+P` | wlogout |
| `Super+Space` | rofi launcher |

## Day-to-day

- `update` — pacman update + stale desktop-file cleanup + orphan removal + reboot prompt
- `all-update` — pacman + AUR (yay) + flatpak in one go
- `wlogout` (`Super+P`) — shutdown/reboot/lock/suspend/logout
- Startup scripts run once per login via `at_startup`
  (`~/.local/bin/startup/*.sh`: auto-caffeine, bluetooth reconnect, keyboard backlight, …)
