-- Hyprland, from xZepyx's hyprzepyx rice (quiet-fracture variant),
-- converted from hyprlang to lua for Hyprland 0.56.
--
-- Upstream: https://github.com/zepyxunderscore/hyprzepyx
-- Converted mechanically from conf/*.conf except for three deliberate changes,
-- each marked at the point it applies:
--   1. binds are this machine owner's own, not the upstream author's;
--   2. the repeated $image lines in colors.conf are dropped -- upstream points
--      them at the author's own home directory;
--   3. the monitor line is omitted so Hyprland auto-detects. Upstream pins
--      1920x1080 and this panel is 1366x768.
--
-- Upstream still keeps the rice at ~/.config/hyprzepyx for its wallpapers.

------------------------
---- COLOURS -----------
------------------------
-- Material Catppuccin-Latte palette, as upstream defines it. The names are
-- upstream's ($primary, $outline_variant, ...) because the look block refers to
-- them; hyprlang variables have no direct lua equivalent, so each becomes a
-- local.
local background                 = "rgba(0e1514ff)"
local error                      = "rgba(ffb4abff)"
local error_container            = "rgba(93000aff)"
local inverse_on_surface         = "rgba(2b3231ff)"
local inverse_primary            = "rgba(006a67ff)"
local inverse_surface            = "rgba(dde4e2ff)"
local on_background              = "rgba(dde4e2ff)"
local on_error                   = "rgba(690005ff)"
local on_error_container         = "rgba(ffdad6ff)"
local on_primary                 = "rgba(003735ff)"
local on_primary_container       = "rgba(9cf1edff)"
local on_primary_fixed           = "rgba(00201fff)"
local on_primary_fixed_variant   = "rgba(00504dff)"
local on_secondary               = "rgba(1b3533ff)"
local on_secondary_container     = "rgba(cce8e6ff)"
local on_secondary_fixed         = "rgba(051f1eff)"
local on_secondary_fixed_variant = "rgba(324b4aff)"
local on_surface                 = "rgba(dde4e2ff)"
local on_surface_variant         = "rgba(bec9c7ff)"
local on_tertiary                = "rgba(1a324bff)"
local on_tertiary_container      = "rgba(d1e4ffff)"
local on_tertiary_fixed          = "rgba(021d35ff)"
local on_tertiary_fixed_variant  = "rgba(314862ff)"
local outline                    = "rgba(889392ff)"
local outline_variant            = "rgba(3f4948ff)"
local primary                    = "rgba(80d5d0ff)"
local primary_container          = "rgba(00504dff)"
local primary_fixed              = "rgba(9cf1edff)"
local primary_fixed_dim          = "rgba(80d5d0ff)"
local scrim                      = "rgba(000000ff)"
local secondary                  = "rgba(b0cccaff)"
local secondary_container        = "rgba(324b4aff)"
local secondary_fixed            = "rgba(cce8e6ff)"
local secondary_fixed_dim        = "rgba(b0cccaff)"
local shadow                     = "rgba(000000ff)"
local source_color               = "rgba(869f9dff)"
local surface                    = "rgba(0e1514ff)"
local surface_bright             = "rgba(343a3aff)"
local surface_container          = "rgba(1a2120ff)"
local surface_container_high     = "rgba(252b2bff)"
local surface_container_highest  = "rgba(2f3635ff)"
local surface_container_low      = "rgba(161d1cff)"
local surface_container_lowest   = "rgba(090f0fff)"
local surface_dim                = "rgba(0e1514ff)"
local surface_tint               = "rgba(80d5d0ff)"
local surface_variant            = "rgba(3f4948ff)"
local tertiary                   = "rgba(b1c8e8ff)"
local tertiary_container         = "rgba(314862ff)"
local tertiary_fixed             = "rgba(d1e4ffff)"
local tertiary_fixed_dim         = "rgba(b1c8e8ff)"

------------------------
---- LOOK AND FEEL -----
------------------------
-- From conf/looks.conf. Two values are changed and marked: opacity, because
-- upstream's 1.0/0.7 makes unfocused windows vanish into a busy wallpaper, and
-- blur passes, which is the single most expensive thing in a compositor and was
-- removed from the niri session for exactly that reason.
hl.config({
    general = {
        gaps_in = 5,
        gaps_out = 20,
        border_size = 2,
        col = {
            active_border = primary,
            inactive_border = outline_variant,
        },
        resize_on_border = false,
        allow_tearing = false,
        layout = "master",
    },

    decoration = {
        rounding = 6,
        rounding_power = 2,
        active_opacity = 1.0,
        inactive_opacity = 0.85,   -- upstream 0.7: too faint to read against a busy wallpaper
        shadow = {
            enabled = true,
            range = 4,
            render_power = 3,
            color = shadow,
        },
        blur = {
            enabled = true,
            size = 5,
            passes = 1,             -- upstream 3; the CPU cost is not worth it here
            vibrancy = 0.1696,
        },
    },
})

------------------------
---- LAYOUT BEHAVIOUR --
------------------------
-- From conf/envvars.conf, where upstream interleaves these with the env block.
hl.config({
    -- pseudotile was removed in 0.56; preserve_split is the half that survives.
    dwindle = {
        preserve_split = true,
    },
    master = {
        new_status = "master",
    },
})

------------------------
---- INPUT -------------
------------------------
-- From conf/input.conf. natural_scroll is off, as in the niri session.
hl.config({
    input = {
        kb_layout = "us",
        kb_variant = "",
        kb_model = "",
        kb_options = "",
        kb_rules = "",
        follow_mouse = 1,
        sensitivity = 0,
        touchpad = { natural_scroll = false },
    },
    -- upstream sets gestures.workspace_swipe = true, which 0.56 replaced with
    -- per-gesture scalars (workspace_swipe_distance and friends). Not set here
    -- rather than guessed at: the defaults are what niri also runs with.
    misc = {
        force_default_wallpaper = -1,
        disable_hyprland_logo = false,
    },
})

--------------------
---- WINDOW RULES ---
--------------------
-- From conf/envvars.conf.
hl.window_rule({
    name = "suppress-maximize",
    match = { class = ".*" },
    suppress_event = "maximize",
})
-- `floating` and `pinned` are not match properties in 0.56; upstream's version
-- of this rule is from 0.54. Reduced to the three that are still valid.
hl.window_rule({
    name = "ignore-empty-xwayland-titles",
    match = { class = "^$", title = "^$", xwayland = true },
    no_focus = true,
})

------------------------
---- ANIMATIONS -------
------------------------
-- From conf/animations/Slow.conf: the "Slow" preset. The curves are declared
-- before the animations that name them, because hl.animation resolves a curve
-- by string and rejects one it has not been told about.
hl.curve("wind", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })
hl.curve("winIn", { type = "bezier", points = { { 0.1, 1.1 }, { 0.1, 1.1 } } })
hl.curve("winOut", { type = "bezier", points = { { 0.3, -0.3 }, { 0, 1 } } })
hl.curve("liner", { type = "bezier", points = { { 1, 1 }, { 1, 1 } } })

hl.animation({ leaf = "windows", enabled = true, speed = 6, bezier = "wind", style = "slide" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 6, bezier = "winIn", style = "slide" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 5, bezier = "winOut", style = "slide" })
hl.animation({ leaf = "border", enabled = true, speed = 1, bezier = "liner" })
hl.animation({ leaf = "fade", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 5, bezier = "wind" })
-- windowsMove and borderangle are dropped: neither leaf exists in 0.56's
-- animation tree, and declaring them is an error rather than a no-op.

--------------------
---- ENVIRONMENT -----
--------------------
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
-- SDDM starts the session directly, so .bashrc never runs and ~/.local/bin is
-- missing from PATH -- which would break every bind that calls a helper script.
hl.env("PATH", "/home/water/.local/bin:" .. os.getenv("PATH") or "")

--------------------
---- AUTOSTART -------
--------------------
-- Upstream starts `waybar & swww-daemon` and then calls a rofi wallpaper
-- picker from ~/.scripts/quiet-fracture/, which does not exist here. This uses
-- awww instead, which is what the niri session already uses, and sets a
-- wallpaper from the rice's own theme folder so the login is not bare.
hl.on("hyprland.start", function()
    hl.exec_cmd("mako")
    hl.exec_cmd("pkill -x dunst")
    hl.exec_cmd("awww-daemon")
    hl.exec_cmd("nm-applet &")
    hl.exec_cmd("wl-paste --watch cliphist store")
    hl.exec_cmd('waybar -c "/home/water/.config/waybar/config.jsonc" -s "/home/water/.config/waybar/style.css"')
    hl.exec_cmd('awww img set "/tmp/opencode/hyprzepyx/config/quiet-fracture/hypr/hyprzepyx/themes/Catppuccin-Latte/backgrounds/b-001.jpg"')
    hl.exec_cmd("/home/water/.local/bin/at_startup")
    hl.exec_cmd("kitty")
end)
-------------------
---- KEYBINDINGS ---
-------------------
--
-- These are the machine owner's own binds, carried across from
-- config/niri/config.kdl. They replace hyprzepyx's binds.conf, which is the
-- upstream author's set (Mod+C to close a window, Mod+S for a terminal) and
-- would silently override what is used every day.
--
-- niri is a scrolling WM and Hyprland is not, so a few of niri's have no
-- counterpart and are dropped rather than approximated: consume-or-expel and
-- expel-window-from-column, switch-preset-column-width / -back and
-- switch-preset-window-height, focus/move-column-to-first/last,
-- expand-column-to-available-width, show-hotkey-overlay, and the
-- move-column-to-workspace-N / move-column-to-monitor-* pairs.
--
-- Modifiers are all caps. "alt" is valid in the conf format but is an unknown
-- keysym to the lua parser, which drops the bind silently.

local terminal    = "kitty"
local fileManager = "kitty --class yazi -e yazi"
local menu        = "rofi -show drun"
local home_dir    = os.getenv("HOME") or "/home/water"
local mainMod     = "SUPER"

-- niri resizes by percentage; resizewindowpixel takes pixels. These are the
-- 10%-of-panel figures for this 1366x768 screen, rounded.
local widthStep  = 135
local heightStep = 74

-- --- launchers ---
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd("firefox"))
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd("nemo"))
hl.bind(mainMod .. " + Space", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + comma", hl.dsp.exec_cmd("smile"))

-- --- window management ---
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + M", hl.dsp.exit())
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + F", hl.dsp.exec_cmd("hyprctl dispatch fullscreen 0"))

-- --- focus: Left/Right walk columns, Up/Down walk windows within one ---
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))

-- --- move. Niri uses Ctrl+Arrow for this and Shift+Arrow for resize. ---
hl.bind(mainMod .. " + CTRL + left",  hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + CTRL + right", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + CTRL + up",    hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + CTRL + down",  hl.dsp.window.move({ direction = "down" }))

-- --- resize ---
hl.bind(mainMod .. " + SHIFT + left",  hl.dsp.exec_cmd("hyprctl dispatch resizewindowpixel -" .. widthStep .. " 0"))
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.exec_cmd("hyprctl dispatch resizewindowpixel "  .. widthStep .. " 0"))
hl.bind(mainMod .. " + SHIFT + up",    hl.dsp.exec_cmd("hyprctl dispatch resizewindowpixel 0 -" .. heightStep))
hl.bind(mainMod .. " + SHIFT + down",  hl.dsp.exec_cmd("hyprctl dispatch resizewindowpixel 0 "  .. heightStep))
hl.bind(mainMod .. " + minus", hl.dsp.exec_cmd("hyprctl dispatch resizewindowpixel -" .. widthStep .. " 0"))
hl.bind(mainMod .. " + equal", hl.dsp.exec_cmd("hyprctl dispatch resizewindowpixel "  .. widthStep .. " 0"))
hl.bind(mainMod .. " + SHIFT + minus", hl.dsp.exec_cmd("hyprctl dispatch resizewindowpixel 0 -" .. heightStep))
hl.bind(mainMod .. " + SHIFT + equal", hl.dsp.exec_cmd("hyprctl dispatch resizewindowpixel 0 "  .. heightStep))
-- niri: reset-window-height. Hyprland treats 0 as "unset", so this restores it.
hl.bind(mainMod .. " + CTRL + R", hl.dsp.exec_cmd("hyprctl dispatch resizewindowpixel 0 0"))

-- --- workspaces 1-10: focus, and move the window there ---
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- --- previous / next workspace: Page keys and wheel, as in niri ---
hl.bind(mainMod .. " + Page_Up",   hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + Page_Down", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mainMod .. " + CTRL + Page_Up",   hl.dsp.window.move({ workspace = "e-1" }))
hl.bind(mainMod .. " + CTRL + Page_Down", hl.dsp.window.move({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- --- monitors (niri: Mod+Alt+arrows) ---
hl.bind(mainMod .. " + ALT + left",  hl.dsp.exec_cmd("hyprctl dispatch movefocus mon_left"))
hl.bind(mainMod .. " + ALT + right", hl.dsp.exec_cmd("hyprctl dispatch movefocus mon_right"))
hl.bind(mainMod .. " + ALT + up",    hl.dsp.exec_cmd("hyprctl dispatch movefocus mon_up"))
hl.bind(mainMod .. " + ALT + down",  hl.dsp.exec_cmd("hyprctl dispatch movefocus mon_down"))

-- --- drag and resize with the mouse ---
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- --- the theme switcher and the rest of local/bin ---
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(home_dir .. "/.local/bin/themesw"))
hl.bind(mainMod .. " + U", hl.dsp.exec_cmd("wlogout"))
hl.bind(mainMod .. " + P", hl.dsp.exec_cmd(home_dir .. "/.local/bin/powerprofile"))
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd(home_dir .. "/.local/bin/wallpaper-switcher"))
hl.bind(mainMod .. " + CTRL + W", hl.dsp.exec_cmd(home_dir .. "/.local/bin/wallpaper-switcher all"))
hl.bind(mainMod .. " + SHIFT + W", hl.dsp.exec_cmd(home_dir .. "/.local/bin/toggle-waybar"))
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd(
    "cliphist list | rofi -dmenu -theme " .. home_dir ..
    "/.config/rofi/config.rasi | cliphist decode | wl-copy"))
hl.bind("SUPER + ALT + L", hl.dsp.exec_cmd("swaylock -C " .. home_dir .. "/.config/niri/lock.conf -f"))
-- niri: Mod+S opens the overview. The scratchpad is the closer everyday
-- equivalent, and it is what Hyprland's own default config binds to Super+S.
hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- --- screenshots (niri: Print, Ctrl+Print, Alt+Print) ---
hl.bind("Print", hl.dsp.exec_cmd("grim -g \"$(slurp)\" - | wl-copy"))
hl.bind("CTRL + Print", hl.dsp.exec_cmd("grim - | wl-copy"))
local winRegion = [==[grim -g "$(hyprctl -j activewindow | jq -r '"\(.size[0])x\(.size[1])+\(.at[0])+\(.at[1])"')" - | wl-copy]==]
hl.bind("ALT + Print", hl.dsp.exec_cmd(winRegion))

-- --- volume, brightness and media.
-- XF86 keys carry no modifier, so the key string is just the key name. locked
-- keeps them working on the lock screen, repeating makes a held key step. ---
hl.bind("XF86AudioRaiseVolume",
    hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume",
    hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioMute",
    hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })
hl.bind("XF86AudioMicMute",
    hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true })
hl.bind("XF86MonBrightnessUp",
    hl.dsp.exec_cmd(home_dir .. "/.local/bin/brightness-step up"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown",
    hl.dsp.exec_cmd(home_dir .. "/.local/bin/brightness-step down"), { locked = true, repeating = true })
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),        { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),    { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"),  { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"),  { locked = true })
hl.bind("XF86AudioStop",  hl.dsp.exec_cmd("playerctl stop"),        { locked = true })

-- --- 3-finger horizontal workspace swipe. One gesture only: declaring two
-- identical 3-finger horizontals makes the second get discarded as shadowed. ---
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
