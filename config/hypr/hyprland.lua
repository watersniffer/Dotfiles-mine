-- Hyprland, written from this machine's niri setup.
--
-- Everything here is a deliberate match to config/niri/config.kdl: the same
-- look, the same keybinds, the same autostart list. Where niri is a scrolling
-- WM and Hyprland is not, binds with no counterpart are dropped rather than
-- approximated, and the dropped ones are listed in the binds section below.
--
-- Modifiers are all caps. In the hyprlang format "alt" is fine, but the lua
-- parser reads it as an unknown keysym and drops the bind silently.

------------------------
---- PALETTE -----------
------------------------
-- Rewritten by ~/.local/bin/theme-apply from themes/<slug>/palette.conf.
-- Edit the palette, not these lines; the trailing comment names the key each
-- value comes from.
local col_bg0    = "rgba(1e1e2eff)"  -- bg0
local col_bg1    = "rgba(181825ff)"  -- bg1
local col_bg3    = "rgba(45475aff)"  -- bg3
local col_fg0    = "rgba(cdd6f4ff)"  -- fg0
local col_accent = "rgba(cba6f7ff)"  -- accent
local col_urgent = "rgba(f38ba8ff)"  -- urgent

------------------------
---- ENVIRONMENT -------
------------------------
-- SDDM starts the session directly, so ~/.bashrc never runs and ~/.local/bin
-- is absent from PATH -- which would break every bind that calls a helper.
hl.env("PATH", "/home/water/.local/bin:" .. (os.getenv("PATH") or ""))
hl.env("XCURSOR_SIZE", "22")
hl.env("XCURSOR_THEME", "Bibata-Modern-Classic")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("QT_STYLE_OVERRIDE", "kvantum")
hl.env("QT_SCALE_FACTOR", "0.92")
hl.env("EDITOR", "nvim")
hl.env("VISUAL", "nvim")
hl.env("TERMINAL", "kitty")

------------------------
---- LOOK AND FEEL -----
------------------------
-- Mirrors niri's layout block. Border and focus-ring are both off in niri, so
-- border_size is 0 and nothing is drawn; the colours are still given so
-- turning borders on is a one-value change.
--
-- Blur is off because niri has none: it is the most expensive thing a
-- compositor does, and this is a 4-core Intel HD 520.
hl.config({
    general = {
        gaps_in = 5,
        gaps_out = 5,
        border_size = 0,
        layout = "master",
        col = {
            active_border = col_accent,
            inactive_border = col_bg3,
        },
        resize_on_border = false,
    },

    decoration = {
        -- niri applies geometry-corner-radius 10 to every window.
        rounding = 10,
        rounding_power = 3,
        -- niri's window rules: 0.90 generally, 1.0 for kitty.
        active_opacity = 1.0,
        inactive_opacity = 0.90,
        shadow = {
            -- niri: on, softness 7, spread 0, offset y=3, colour at 60%.
            enabled = true,
            range = 7,
            render_power = 3,
            offset = { 0, 3 },
            color = "rgba(30, 30, 46, 0.6)",
        },
        blur = {
            enabled = false,
            size = 5,
            passes = 1,
            vibrancy = 0.1696,
        },
    },
})

------------------------
---- INPUT --------------
------------------------
-- Mirrors niri's input block. natural_scroll is off there too, deliberately.
hl.config({
    input = {
        kb_layout = "us",
        follow_mouse = 1,          -- niri's focus-follows-mouse
        touchpad = {
            tap_to_click = true,    -- niri's tap
            natural_scroll = false,
        },
    },
})

------------------------
---- WINDOW RULES ------
------------------------
-- niri sets kitty to opacity 1.0 so the terminal stays readable when unfocused,
-- against the same 0.90 everything else gets.
hl.window_rule({
    name = "kitty-opaque",
    match = { class = "^kitty$" },
    opacity = 1.0,
})

------------------------
---- ANIMATIONS --------
------------------------
-- Deliberately empty: animations are left at Hyprland's own defaults.
--
-- This block used to mirror niri's animations block, converting its named
-- curves and springs into beziers and durations. That worked, but the result
-- was much faster than anything Hyprland ships -- 1.2 to 1.5 deciseconds
-- against a default set that runs from 1.21 up to 10 -- so windows and
-- workspaces snapped rather than moved.
--
-- With no animation block here, every leaf takes the shipped default, and
-- animations stay enabled because that is the default for animations.enabled
-- too. Nothing needs to be restated to keep them on.
--
-- If they ever do need to be set explicitly, /usr/share/hypr/hyprland.lua
-- carries Hyprland's own set under the heading "Default curves and
-- animations", with the curves (easeOutQuint, almostLinear, quick, linear,
-- easeInOutCubic and the easy spring) declared just above it.

------------------------
---- KEYBINDINGS --------
------------------------
-- Niri's binds, translated. Niri's column actions with no Hyprland counterpart
-- are dropped rather than faked:
--   consume-or-expel-window-left/right, expel-window-from-column,
--   switch-preset-column-width / -back / -window-height, reset-window-height,
--   expand-column-to-available-width, center-visible-columns,
--   focus-column-first/last, move-column-to-first/last,
--   move-column-to-workspace-N (a window is not a column here, so it would
--   only duplicate Mod+Shift+N), move-column-to-monitor-*,
--   move-workspace-up/down, toggle-overview,
--   switch-focus-between-floating-and-tiling, show-hotkey-overlay and
--   toggle-keyboard-shortcuts-inhibit.
--
-- Two are dropped because Hyprland 0.56's config API cannot express them at
-- all, which is a different reason from the WM difference:
--   Mod+Alt+Arrow, focus-monitor. hl.focus and hl.window.move accept no monitor
--   field in 0.56 and `hyprctl setprop` has no monitor request. Niri's own
--   comment notes these are no-ops on a single-output machine.
--   Mod+Shift+P, power-off-monitors. Same reason: no DPMS dispatcher. So
--   brightness-step cannot black the panel the way it does under niri. It stays
--   safe -- it only marks the display off when the niri call succeeded, so
--   under Hyprland it simply leaves the backlight at 0.
--
-- Also dropped: Alt+Tab (focus-window-previous). 0.56 has no recent-window
-- dispatcher, so there is nothing to bind it to without writing a helper.
--
-- Mod+Wheel moves focus and Mod+Ctrl+Wheel moves the window, matching niri,
-- which only works because natural_scroll is off in both.

local mainMod = "SUPER"
local home    = "/home/water"

-- Niri resizes by percentage; hl.dsp.window.resize takes pixels in x/y. These
-- are 10% of this 1366x768 panel, rounded.
local stepW = 136
local stepH = 76

-- launchers
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd("kitty"))
hl.bind(mainMod .. " + E",     hl.dsp.exec_cmd("kitty --class yazi -e yazi"))
hl.bind(mainMod .. " + B",     hl.dsp.exec_cmd("firefox"))
hl.bind(mainMod .. " + D",     hl.dsp.exec_cmd("nemo"))
hl.bind(mainMod .. " + Space", hl.dsp.exec_cmd("rofi -show drun"))
hl.bind(mainMod .. " + comma", hl.dsp.exec_cmd("smile"))

-- window management
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + M", hl.dsp.exit())
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
-- internal and client are integers here, not the strings the error message
-- suggests: 1 is the fullscreen state, and omitting action leaves it a toggle,
-- which is what niri's fullscreen-window does.
hl.bind(mainMod .. " + F",
    hl.dsp.window.fullscreen_state({ internal = 1, client = 1 }))

-- focus: Left/Right walk columns, Up/Down walk windows inside one, as in niri
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))

-- move (niri: Mod+Ctrl+Arrow)
hl.bind(mainMod .. " + CTRL + left",  hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + CTRL + right", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + CTRL + up",    hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + CTRL + down",  hl.dsp.window.move({ direction = "down" }))

-- resize (niri: Mod+Shift+Arrow, and Mod+Minus/Equal for width)
hl.bind(mainMod .. " + SHIFT + left",  hl.dsp.window.resize({ x = -stepW, y = 0 }))
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.resize({ x =  stepW, y = 0 }))
hl.bind(mainMod .. " + SHIFT + up",    hl.dsp.window.resize({ x = 0, y = -stepH }))
hl.bind(mainMod .. " + SHIFT + down",  hl.dsp.window.resize({ x = 0, y =  stepH }))
hl.bind(mainMod .. " + minus",          hl.dsp.window.resize({ x = -stepW, y = 0 }))
hl.bind(mainMod .. " + equal",          hl.dsp.window.resize({ x =  stepW, y = 0 }))
hl.bind(mainMod .. " + SHIFT + minus",  hl.dsp.window.resize({ x = 0, y = -stepH }))
hl.bind(mainMod .. " + SHIFT + equal",  hl.dsp.window.resize({ x = 0, y =  stepH }))

-- workspaces 1-10, and move the focused window to one
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key,         hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- workspace paging (niri: Mod+Page_Up/Down, and the wheel)
hl.bind(mainMod .. " + Page_Up",   hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + Page_Down", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mainMod .. " + CTRL + Page_Up",   hl.dsp.window.move({ workspace = "e-1" }))
hl.bind(mainMod .. " + CTRL + Page_Down", hl.dsp.window.move({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mainMod .. " + CTRL + mouse_down",  hl.dsp.window.move({ workspace = "e+1" }))
hl.bind(mainMod .. " + CTRL + mouse_up",    hl.dsp.window.move({ workspace = "e-1" }))
hl.bind(mainMod .. " + CTRL + mouse_right", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + CTRL + mouse_left",  hl.dsp.window.move({ direction = "left" }))

-- drag and resize with the mouse
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- the local/bin helpers
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(home .. "/.local/bin/themesw"))
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd(home .. "/.local/bin/wallpaper-switcher"))
hl.bind(mainMod .. " + CTRL + W", hl.dsp.exec_cmd(home .. "/.local/bin/wallpaper-switcher all"))
hl.bind(mainMod .. " + SHIFT + W", hl.dsp.exec_cmd(home .. "/.local/bin/toggle-chillpill"))
hl.bind(mainMod .. " + P", hl.dsp.exec_cmd(home .. "/.local/bin/powerprofile"))
hl.bind(mainMod .. " + U", hl.dsp.exec_cmd("wlogout"))
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd(
    "cliphist list | rofi -dmenu -theme " .. home ..
    "/.config/rofi/config.rasi | cliphist decode | wl-copy"))
hl.bind("SUPER + ALT + L",
    hl.dsp.exec_cmd("swaylock -C " .. home .. "/.config/niri/lock.conf -f"))

-- screenshots, into the folder niri's screenshot-path points at
local shotDir = home .. "/Pictures/Screenshots"
hl.bind("Print", hl.dsp.exec_cmd(
    'grim -g "$(slurp)" "' .. shotDir .. '/screenshot_%Y-%m-%d_%H-%M-%S.png"'))
hl.bind("CTRL + Print", hl.dsp.exec_cmd(
    'grim "' .. shotDir .. '/screen_%Y-%m-%d_%H-%M-%S.png"'))
-- region-of-the-focused-window, copied to the clipboard. The jq filter is in a
-- long-bracket string so its own single quotes need no escaping.
local winRegion = [==[hyprctl -j activewindow | jq -r 'if .size then "\(.size[0])x\(.size[1])+\(.at[0])+\(.at[1])" else "" end']==]
hl.bind("ALT + Print", hl.dsp.exec_cmd('grim -g "$(echo ' .. winRegion .. ')" - | wl-copy'))

-- volume, brightness and media. XF86 keys carry no modifier, so the key string
-- is the bare key name; locked keeps them working on the lock screen, and
-- repeating makes a held key step instead of firing once.
hl.bind("XF86AudioRaiseVolume",
    hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume",
    hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioMute",
    hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })
hl.bind("XF86AudioMicMute",
    hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true })
hl.bind("XF86MonBrightnessUp",
    hl.dsp.exec_cmd(home .. "/.local/bin/brightness-step up"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown",
    hl.dsp.exec_cmd(home .. "/.local/bin/brightness-step down"), { locked = true, repeating = true })
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })
hl.bind("XF86AudioStop",  hl.dsp.exec_cmd("playerctl stop"),       { locked = true })

------------------------
---- AUTOSTART ---------
------------------------
-- Mirrors local/bin/niri-startup, with the bar swapped for ChillPill-Shell.
--
-- The niri session still uses waybar; this is the Hyprland session's bar, and
-- ChillPill needs no stylesheet or generated colour file of its own -- it reads
-- config/chillpill-shell/config.jsonc.
--
-- mako is deliberately NOT started here, unlike in niri. Only one process can
-- own org.freedesktop.Notifications, and ChillPill registers itself as the
-- notification server and draws its own popups. Leaving mako running means it
-- wins the name and ChillPill's notification module stays permanently dead.
hl.on("hyprland.start", function()
    hl.exec_cmd("pkill -x dunst 2>/dev/null; true")
    hl.exec_cmd("systemctl --user restart xdg-desktop-portal.service")
    hl.exec_cmd("chillpill-shell")
    hl.exec_cmd(home .. "/.local/bin/at_startup")
    hl.exec_cmd("awww-daemon")
    hl.exec_cmd("awww restore")
    -- ChillPill has no system-tray module, so nm-applet is the only way to
    -- reach tray apps here. Without a bar to host it its icon floats.
    hl.exec_cmd("nm-applet")
    hl.exec_cmd("wl-paste --watch cliphist store")
    hl.exec_cmd("/usr/lib/polkit-kde-authentication-agent-1")
    hl.exec_cmd("kitty")
end)
