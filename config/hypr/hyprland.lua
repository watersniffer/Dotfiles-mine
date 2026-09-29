-- Hyprland — a second session, alongside Niri.
--
-- This is not a port of config/niri/config.kdl and it cannot be. Niri is
-- scrollable: a column is a strip you consume windows from. Hyprland is a
-- conventional columns WM. What matches is everything *around* the compositor —
-- kitty, waybar, rofi, mako, wlogout, awww, the seven themes — which is already
-- palette-driven and compositor-agnostic — and the look, which is matched value
-- for value below.
--
-- Every API form used here was taken from the reference config embedded in the
-- 0.56.2 binary, and the whole file is verified by loading it into a throwaway
-- headless instance and reading back hyprctl configerrors on that instance's own
-- socket. A config-key error and a lua error are both caught that way.
--
-- Three things this format gets right that the old hyprlang one could not:
--   * animations are objects (hl.animation), not keys in a block, so none of
--     them get silently discarded;
--   * window rules take a value per field (hl.window_rule);
--   * the cursor's theme and size moved to hyprcursor, so they come from the
--     environment rather than a config block.
--
-- The three values marked THEME are rewritten by theme-apply, the same way it
-- rewrites niri's focus ring, so Super+T restyles this session too. Do not
-- reword those three lines.

local terminal = "kitty"
-- yazi is a TUI: it has to run inside a terminal, never bare.
local fileManager = "kitty --class yazi -e yazi"
local menu = "rofi -show drun"
local mainMod = "SUPER"

-- niri resizes by percentage; Hyprland's resizewindowpixel takes pixels. These
-- are the 10%-of-panel figures for this 1366x768 screen, rounded: ~136 across,
-- ~74 tall.
local widthStep = 135
local heightStep = 74

--------------------
---- WINDOW RULES --
--------------------

-- Kitty draws its own translucency (background_opacity in its kitty.conf), so
-- Hyprland must not multiply an opacity on top the way it does for everything
-- else. Same reason niri carries a kitty rule at opacity 1.0.
hl.window_rule({
    name = "kitty-keeps-its-own-transparency",
    match = { class = "^kitty$" },
    opacity = 1.0,
})

-- The emoji picker: floating, centred, fixed size, and it must not steal focus.
hl.window_rule({
    name = "smile-emoji-picker-float",
    match = { class = "^it\\.mijorus\\.smile$" },
    float = true,
    size = "500 400",
    center = true,
    stay_focused = true,
})

--------------------
---- ENVIRONMENT --
--------------------

-- SDDM starts the session directly, so .bashrc never runs and ~/.local/bin is
-- missing from PATH. Without this every bind that calls a script in there
-- (themesw, wallpaper-switcher, powerprofile, brightness-step, toggle-waybar)
-- fails with "command not found". Same list, same order, as niri-startup.
local home = os.getenv("HOME") or ""
local inherited = os.getenv("PATH") or ""
local userPath = home .. "/.local/bin:" .. home .. "/.local/share/flatpak/exports/bin"
local systemPath = "/usr/local/sbin:/usr/local/bin:/usr/bin:/var/lib/flatpak/exports/bin"

hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("GDK_BACKEND", "wayland")
-- 0.56 replaced the cursor block's image/size with hyprcursor, which takes its
-- theme and size from here rather than from config.
hl.env("XCURSOR_SIZE", "22")
hl.env("XCURSOR_THEME", "Bibata-Modern-Classic")
hl.env("HYPRCURSOR_SIZE", "22")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("QT_STYLE_OVERRIDE", "kvantum")
hl.env("QT_SCALE_FACTOR", "0.92")
hl.env("EDITOR", "nvim")
hl.env("VISUAL", "nvim")
hl.env("TERMINAL", "kitty")
hl.env("PATH", userPath .. ":" .. inherited .. ":" .. systemPath)

--------------------
---- AUTOSTART ----
--------------------

-- Same list, same order, as local/bin/niri-startup. Duplicated rather than
-- shared because the marker file keys on the compositor's own identifier:
-- niri's on NIRI_SOCKET, Hyprland's on HYPRLAND_INSTANCE_SIGNATURE. One script
-- serving both would let whichever session logged in first suppress the other.
hl.on("hyprland.start", function()
    -- Dunst owns org.freedesktop.Notifications; while it holds that name mako
    -- refuses to start, so clear it before launching the notifier.
    hl.exec_cmd("pkill -x dunst")
    hl.exec_cmd("mako")
    hl.exec_cmd("systemctl --user restart xdg-desktop-portal.service")
    -- config-hypr.jsonc, not config-niri.jsonc: the workspace module differs
    -- (hyprland/workspaces). style.css and colors.css are the same shared,
    -- theme-driven files, so the bar is themed identically to niri's.
    hl.exec_cmd('waybar -c "' .. home .. '/.config/waybar/config-hypr.jsonc" -s "' ..
        home .. '/.config/waybar/style.css"')
    hl.exec_cmd(home .. "/.local/bin/at_startup")
    -- awww owns the wallpaper and must be listening before one can be set.
    hl.exec_cmd("awww-daemon")
    hl.exec_cmd("nm-applet &")
    hl.exec_cmd("wl-paste --watch cliphist store")
    hl.exec_cmd(terminal)
end)

--------------------------
---- LOOK AND FEEL --------
--------------------------

-- No monitor rule. Hyprland auto-detects, and the old monitors.conf was empty
-- in git, so a pinned mode line would only be a thing to go stale.
hl.config({
    general = {
        border_size = 0,                -- niri: no border
        gaps_in = 5,                    -- niri: gaps 5
        gaps_out = 5,                   -- niri: gaps 5
        resize_on_border = false,
        allow_tearing = false,
        layout = "dwindle",

        -- THEME (accent) — niri's focus-ring colour, and (fg3) the inactive
        -- one. These live INSIDE general: in the lua config the border colours
        -- are general.col.*, and a top-level col = {} is rejected as an
        -- unknown key. border_size is 0 so nothing is drawn; these are what a
        -- layout that does draw a border would use, and what theme-apply
        -- rewrites.
        col = {
            active_border = "rgba(cba6f7ff)",     -- THEME (accent)
            inactive_border = "rgba(6c7086ff)",   -- THEME (fg3)
        },
    },

    decoration = {
        rounding = 10,                  -- niri: geometry-corner-radius 10
        rounding_power = 2.0,
        active_opacity = 0.90,          -- niri: opacity 0.90
        inactive_opacity = 0.90,

        shadow = {
            enabled = true,
            range = 7,                  -- niri: shadow softness 7
            render_power = 6,
            color = "0x1e1e2e99",       -- THEME (bg0 at 60%)
        },

        -- No blur. niri has none either: it was the most expensive thing in
        -- the compositor on this HD 520 and never looked right, so opacity
        -- alone carries the transparency in both sessions.
    },

    cursor = {
        hotspot_padding = 1,
        min_refresh_rate = 0,
    },

    misc = {
        force_default_wallpaper = 0,     -- awww owns the wallpaper
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
        enable_swallow = true,
        focus_on_activate = true,
    },

    input = {
        kb_layout = "us",
        follow_mouse = 1,
        -- natural_scroll is deliberately off, matching niri. input.touchdevice
        -- is spelled as one word and holds only coordinate transforms, so this
        -- is the only place it can go.
        touchpad = { natural_scroll = false },
    },
})

---------------------
---- ANIMATIONS ------
---------------------

-- These are Hyprland's own defaults, copied verbatim from the reference config
-- in the 0.56.2 binary -- nothing tuned, no custom curves, so this animates
-- exactly as a fresh install does.
--
-- The curve definitions are not decoration: hl.animation names a curve by
-- string, so every curve referenced below has to be declared first or the
-- animation is rejected. "default" is the only one that exists undeclared.
--
-- `speed` is a DURATION in deciseconds, not a rate -- speed = 1 is 100ms.
hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 },    { 0.32, 1 } } })
hl.curve("linear",       { type = "bezier", points = { { 0, 0 },       { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 },   { 0.75, 1 } } })
hl.curve("quick",        { type = "bezier", points = { { 0.15, 0 },    { 0.1, 1 } } })
hl.curve("easy",         { type = "spring", mass = 1, stiffness = 238.1191, dampening = 24.21279333 })

hl.animation({ leaf = "global",        enabled = true, speed = 10,   bezier = "default" })
hl.animation({ leaf = "border",        enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows",       enabled = true, speed = 4.79, spring = "easy" })
hl.animation({ leaf = "windowsIn",     enabled = true, speed = 4.1,  spring = "easy",         style = "popin 87%" })
hl.animation({ leaf = "windowsOut",    enabled = true, speed = 1.49, bezier = "linear",       style = "popin 87%" })
hl.animation({ leaf = "fadeIn",        enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",       enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade",          enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers",        enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",      enabled = true, speed = 4,    bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true, speed = 1.5,  bezier = "linear",       style = "fade" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces",    enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn",  enabled = true, speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear", style = "slide" })
hl.animation({ leaf = "zoomFactor",    enabled = true, speed = 7,    bezier = "quick" })

-------------------
---- KEYBINDINGS ---
-------------------
--
-- One-to-one with config/niri/config.kdl wherever the concept exists in both.
-- The niri-only binds are dropped rather than approximated, because a wrong
-- approximation is worse than an absent key: consume-or-expel and
-- expel-window-from-column (scrolling columns), switch-preset-* (preset
-- cycling), focus/move column first/last, toggle-keyboard-shortcuts-inhibit,
-- switch-focus-between-floating-and-tiling, power-off-monitors (niri now uses
-- brightness 0% to blank, so this has an equivalent already bound),
-- expand-column-to-available-width, show-hotkey-overlay, move-column-to-workspace-N
-- and move-column-to-monitor-*.
--
-- Modifiers are all caps: SUPER, CTRL, SHIFT, ALT. Lowercase "alt" is accepted
-- by the conf format but is an unknown keysym to the lua parser, which silently
-- drops the bind.

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
hl.bind(mainMod .. " + CTRL + left", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + CTRL + right", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + CTRL + up", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + CTRL + down", hl.dsp.window.move({ direction = "down" }))

-- --- resize (niri: Shift+Arrow and Minus/Equal) ---
hl.bind(mainMod .. " + SHIFT + left", hl.dsp.exec_cmd("hyprctl dispatch resizewindowpixel -" .. widthStep .. " 0"))
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.exec_cmd("hyprctl dispatch resizewindowpixel " .. widthStep .. " 0"))
hl.bind(mainMod .. " + SHIFT + up", hl.dsp.exec_cmd("hyprctl dispatch resizewindowpixel 0 -" .. heightStep))
hl.bind(mainMod .. " + SHIFT + down", hl.dsp.exec_cmd("hyprctl dispatch resizewindowpixel 0 " .. heightStep))
hl.bind(mainMod .. " + minus", hl.dsp.exec_cmd("hyprctl dispatch resizewindowpixel -" .. widthStep .. " 0"))
hl.bind(mainMod .. " + equal", hl.dsp.exec_cmd("hyprctl dispatch resizewindowpixel " .. widthStep .. " 0"))
hl.bind(mainMod .. " + SHIFT + minus", hl.dsp.exec_cmd("hyprctl dispatch resizewindowpixel 0 -" .. heightStep))
hl.bind(mainMod .. " + SHIFT + equal", hl.dsp.exec_cmd("hyprctl dispatch resizewindowpixel 0 " .. heightStep))
-- niri: reset-window-height. Hyprland treats 0 as "unset", so this restores it.
hl.bind(mainMod .. " + CTRL + R", hl.dsp.exec_cmd("hyprctl dispatch resizewindowpixel 0 0"))

-- --- workspaces 1-10: focus, and move the window there ---
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- --- previous / next workspace: Page keys and wheel, as in niri ---
hl.bind(mainMod .. " + Page_Up", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + Page_Down", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mainMod .. " + CTRL + Page_Up", hl.dsp.window.move({ workspace = "e-1" }))
hl.bind(mainMod .. " + CTRL + Page_Down", hl.dsp.window.move({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- --- monitors (niri: Mod+Alt+arrows) ---
hl.bind(mainMod .. " + ALT + left", hl.dsp.exec_cmd("hyprctl dispatch movefocus mon_left"))
hl.bind(mainMod .. " + ALT + right", hl.dsp.exec_cmd("hyprctl dispatch movefocus mon_right"))
hl.bind(mainMod .. " + ALT + up", hl.dsp.exec_cmd("hyprctl dispatch movefocus mon_up"))
hl.bind(mainMod .. " + ALT + down", hl.dsp.exec_cmd("hyprctl dispatch movefocus mon_down"))

-- --- drag and resize with the mouse ---
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- --- the theme switcher, and the rest of local/bin ---
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(home .. "/.local/bin/themesw"))
hl.bind(mainMod .. " + U", hl.dsp.exec_cmd("wlogout"))
hl.bind(mainMod .. " + P", hl.dsp.exec_cmd(home .. "/.local/bin/powerprofile"))
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd(home .. "/.local/bin/wallpaper-switcher"))
hl.bind(mainMod .. " + CTRL + W", hl.dsp.exec_cmd(home .. "/.local/bin/wallpaper-switcher all"))
hl.bind(mainMod .. " + SHIFT + W", hl.dsp.exec_cmd(home .. "/.local/bin/toggle-waybar"))
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd(
    "cliphist list | rofi -dmenu -theme " .. home .. "/.config/rofi/config.rasi | cliphist decode | wl-copy"))
hl.bind("SUPER + ALT + L", hl.dsp.exec_cmd("swaylock -C " .. home .. "/.config/niri/lock.conf -f"))
-- niri: Mod+S opens the overview. The scratchpad is the closer everyday
-- equivalent, and it is what Hyprland's own default config binds to Super+S.
hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- --- screenshots (niri: Print, Ctrl+Print, Alt+Print) ---
hl.bind("Print", hl.dsp.exec_cmd("grim -g \"$(slurp)\" - | wl-copy"))
hl.bind("CTRL + Print", hl.dsp.exec_cmd("grim - | wl-copy"))
-- niri's screenshot-window has no direct equivalent: Hyprland has no
-- "screenshot the active window" dispatcher, so this asks the compositor for
-- the focused window's geometry and hands it to grim.
local winRegion = [==[grim -g "$(hyprctl -j activewindow | jq -r '"\(.size[0])x\(.size[1])+\(.at[0])+\(.at[1])"')" - | wl-copy]==]
hl.bind("ALT + Print", hl.dsp.exec_cmd(winRegion))

-- --- volume, brightness and media.
-- XF86 keys carry no modifier, so the key string is just the key name -- there
-- is no empty leading field. locked keeps them working on the lock screen,
-- repeating makes a held key step instead of firing once, matching niri's
-- allow-when-locked / repeat=false pairs. ---
hl.bind("XF86AudioRaiseVolume",
    hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume",
    hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioMute",
    hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })
hl.bind("XF86AudioMicMute",
    hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true })
-- brightness-step, not brightnessctl: it blanks the panel properly at 0% via
-- niri's power-off-monitors equivalent, which is the behaviour niri has.
hl.bind("XF86MonBrightnessUp",
    hl.dsp.exec_cmd(home .. "/.local/bin/brightness-step up"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown",
    hl.dsp.exec_cmd(home .. "/.local/bin/brightness-step down"), { locked = true, repeating = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioStop", hl.dsp.exec_cmd("playerctl stop"), { locked = true })

-- --- 3-finger horizontal workspace swipe. Niri is a scrolling WM and has no
-- gesture equivalent, so this is the one thing Hyprland gets that niri cannot.
-- One gesture only: declaring two identical 3-finger horizontals makes the
-- second get discarded as shadowed by the first. ---
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
