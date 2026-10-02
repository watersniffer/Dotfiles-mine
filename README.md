# Dotfiles

My personal Arch Linux dotfiles. **Hyprland**, **Bash + Starship**, **Kitty**,
**Neovim**, **Waybar**, **Rofi**, **Mako**, **Matuwall** and **Fastfetch**, on a
single fixed greyscale palette: **E-ink**.

This repository is **config only**. There is no installer and no package list —
nothing here runs, patches or provisions your system. Copy or symlink what you want.

## Contents

```
.
├── config/                    # ~/.config/*
│   ├── hypr/                   # Hyprland: hyprland.lua, hyprlock.conf,
│   │                           #   hypridle.conf, hyprpaper.conf
│   ├── waybar/                 # Status bar: config-hypr.jsonc, style.css, colors.css
│   ├── kitty/                  # Terminal
│   ├── rofi/                   # Launcher
│   ├── mako/                   # Notifications
│   ├── matuwall/               # Wallpaper picker
│   ├── fastfetch/  btop/       # System fetch, process viewer
│   └── gtk-3.0/ gtk-4.0/ qt6ct/  # App colours
├── local/bin/                  # Scripts on $PATH, plus its own README
├── home/                       # Dotfiles linked to $HOME
│   ├── .bashrc / .bash_profile / .bash_logout
│   ├── .tmux.conf  .inputrc  .gtkrc-2.0
│   ├── .vimrc  .vim/           # monochrome.vim, the fallback colourscheme
│   └── .config/xdg-terminal-exec.conf
├── systemd/user/               # A user unit
├── themes/e-ink/               # palette.conf — provenance only, nothing reads it
└── README.md
```

`config/hypr`, `config/waybar`, `config/rofi`, `config/kitty`, `config/mako`,
`config/matuwall` and `config/fastfetch` are symlinked into `~/.config`, so editing
them here changes the running session. The rest are real directories copied in both
directions.

## The theme is fixed

There is no theme switcher and no palette generator. The e-ink greys are committed
directly as static values in `waybar/colors.css`, `rofi/colors.rasi`,
`kitty/themes/e-ink.conf`, `qt6ct/colors/Eink.conf` and `mako/config.toml`.

`themes/e-ink/palette.conf` is kept only as the record of where those values came
from. Nothing reads it.

## Waybar

The bar is drawn as a **floating island**, not a full-width strip. Two things about
that are not obvious and are commented in the files themselves:

- The inset goes on an inner container box, **not** on `window#waybar`. A layer-shell
  surface always spans the full output width, so `margin` on the bar window is
  silently ignored. This was measured, not assumed.
- Workspaces render as **diamonds** — filled for the active one, hollow otherwise.
  Colour and `font-size` are set on `#workspaces button label`, not on the button:
  GTK ignores both on a `GtkButton`, because it does not draw its own text. This was
  also measured, with a probe appended as the last rule in the stylesheet.

## Keybinds

| Key | Action |
|---|---|
| `Super+Space` | rofi launcher |
| `Super+Return` | terminal |
| `Super+E` | nemo |
| `Super+Alt+E` | yazi |
| `Super+D` | dankcalendar |
| `Super+B` | zen-browser |
| `Super+comma` | smile |
| `Super+S` | scratchpad (slides down from the top; empty shell by default) |
| `Super+V` | clipboard history |
| `Super+P` | power mode: performance → balanced → power saver |
| `Super+L` | hyprlock |
| `Super+U` | wlogout |
| `Super+F` | fullscreen |
| `Super+Alt+F` | float / unfloat |
| `Super+Q` | close window |
| `Super+W` | wallpaper picker (matuwall) |
| `Super+Shift+W` | hide / show the bar |
| `Super+1`…`9`, `Super+0` | switch workspace |
| `Super+Shift+1`…`9` | move the window to that workspace |
| `Super+←↑↓→` | move focus |
| `Super+Shift+←↑↓→` | resize the window |
| `XF86MonBrightness*` | backlight |
| `XF86Audio*` | volume and media |
| `Print` / `Ctrl+Print` / `Alt+Print` | screenshot, full screen, focused window |
| 3-finger horizontal swipe | change workspace |

## Locking and idling

`hyprlock` on `Super+L`, and `hypridle` turns the panel off after 15 minutes with the
first input after that raising the lock screen. Both are in `config/hypr/`.

hyprlock has no usable defaults — it exits 1 with `Config path error` if no config
exists, which is why `hyprlock.conf` is here. Its options were found by running it:
colours are `rgba(r,g,b,a)` and **not** hex, and the background colour key is `color`.

To check that file without locking the screen:

```sh
WAYLAND_DISPLAY=definitely-not-a-socket hyprlock -c ~/.config/hypr/hyprlock.conf
```

Do not test it by running `hyprlock`. It daemonises, so killing the foreground
process leaves the real locker holding the session lock.

## Clipboard

`Super+V` opens a rofi list of `cliphist` history. Two separate bugs lived here and
both are described in `local/bin/clipboard-history` and `clipboard-watcher`: the
feeder had died unsupervised, and pressing Escape in the picker used to **wipe** the
clipboard.

## Host-based blocking

Not in this repository, because it cannot be: the list is deliberately unreadable by
your own account. It lives in `/etc/dnsmasq-blocklist` (`root:dnsmasq`, mode 640) and
is served by dnsmasq on `127.0.0.1`, which also makes Cloudflare the upstream resolver.

`/etc/hosts` cannot be used for this. Making it mode 600 does not hide the list, it
removes it from service — glibc cannot open the file and falls through to DNS, and
every blocked domain resolves again.

Regenerate with `sudo update-hosts-blocklist`, which is `local/bin/update-hosts-blocklist`.
