-- Hyprland Lua config (converted from hyprland.conf)

--------------------
---- MY PROGRAMS ----
--------------------

local terminal    = "kitty"
local fileManager = "thunar"
local menu        = "rofi -show drun"

--------------------
---- MONITORS -------
--------------------

hl.monitor({
    output = "",                  -- Keeps this rule active for any monitor plugged in
    mode = "1366x768@60",         -- Explicitly sets your native resolution at 60Hz
    position = "0x0",             -- Keeps the workspace anchored at the coordinates origin
    scale = 1.0,                  -- Force scale to 1 to make things smaller and crisp
})


------------------------
---- ENVIRONMENT --------
------------------------

hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("GDK_BACKEND", "wayland")
hl.env("XCURSOR_SIZE", "24")
hl.env("XCURSOR_THEME", "Bibata-Material-Noir")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("QT_STYLE_OVERRIDE", "kvantum")

--------------------
---- AUTOSTART ------
--------------------

hl.on("hyprland.start", function()
    hl.exec_cmd("mako")
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=Hyprland")
    hl.exec_cmd("waybar")
    hl.exec_cmd("sweetbgd")
    hl.exec_cmd("nm-applet &")
    hl.exec_cmd("wl-paste --watch cliphist store")
    hl.exec_cmd(terminal)
end)

--------------------------
---- LOOK AND FEEL --------
--------------------------

hl.config({
    general = {
        gaps_in  = 4,
        gaps_out = 8,

        border_size = 0,

        col = {
            active_border   = { colors = { "rgba(eaeaeaff)" }, angle = 0 },
            inactive_border = "rgba(2b2b2bff)",
        },

        resize_on_border = false,

        allow_tearing = false,
    },

    decoration = {
        rounding       = 10,
        rounding_power = 2.0,

        active_opacity   = 0.90,
        inactive_opacity = 0.90,

        shadow = {
            enabled      = true,
            range        = 7,
            render_power = 6,
            color        = 0x00000099,
        },

        blur = {
            enabled           = true,
            size              = 8,
            passes            = 2,
            new_optimizations = true,
            vibrancy          = 1,
        },
    },

    animations = {
        enabled = true,
    },
})

-- Curves
hl.curve("quick",  { type = "bezier", points = { {0.4, 1.2}, {0.6, 1} } })
hl.curve("snap",   { type = "bezier", points = { {0.3, 1},   {0.4, 1} } })
hl.curve("bounce", { type = "bezier", points = { {0.2, 0},   {0.1, 1} } })

hl.animation({ leaf = "global",         enabled = true,  speed = 10,   bezier = "default" })
hl.animation({ leaf = "border",         enabled = true,  speed = 6,    bezier = "quick" })
hl.animation({ leaf = "windows",        enabled = true,  speed = 4,    bezier = "bounce" })
hl.animation({ leaf = "windowsIn",      enabled = true,  speed = 3.5,  bezier = "bounce" })
hl.animation({ leaf = "windowsOut",     enabled = true,  speed = 4,    bezier = "bounce" })
hl.animation({ leaf = "fadeIn",         enabled = true,  speed = 0.25, bezier = "quick" })
hl.animation({ leaf = "fadeOut",        enabled = true,  speed = 0.2,  bezier = "quick" })
hl.animation({ leaf = "fade",           enabled = true,  speed = 0.6,  bezier = "quick" })
hl.animation({ leaf = "layers",         enabled = true,  speed = 2.8,  bezier = "snap" })
hl.animation({ leaf = "layersIn",       enabled = true,  speed = 2.5,  bezier = "snap",  style = "slide" })
hl.animation({ leaf = "layersOut",      enabled = true,  speed = 2.5,  bezier = "snap",  style = "slide" })
hl.animation({ leaf = "fadeLayersIn",   enabled = true,  speed = 0.18, bezier = "quick" })
hl.animation({ leaf = "fadeLayersOut",  enabled = true,  speed = 0.15, bezier = "quick" })
hl.animation({ leaf = "workspaces",         enabled = true,  speed = 4,    bezier = "bounce", style = "slide" })
hl.animation({ leaf = "workspacesIn",       enabled = true,  speed = 4,    bezier = "bounce", style = "slide" })
hl.animation({ leaf = "workspacesOut",      enabled = true,  speed = 3,    bezier = "quick",  style = "slide" })
hl.animation({ leaf = "specialWorkspace",   enabled = true,  speed = 4,    bezier = "bounce", style = "slidefadevert -50%" })
hl.animation({ leaf = "specialWorkspaceIn", enabled = true,  speed = 4,    bezier = "bounce", style = "slidefadevert -50%" })
hl.animation({ leaf = "specialWorkspaceOut",enabled = true,  speed = 3,    bezier = "quick",  style = "slidefadevert -50%" })
hl.animation({ leaf = "zoomFactor",         enabled = true,  speed = 6,    bezier = "quick" })

--------------------
---- LAYOUTS -------
--------------------

hl.config({
    master = {
        new_status = "master",
    },
})

---------------
---- MISC -----
---------------

hl.config({
    misc = {
        force_default_wallpaper = 1,
        disable_hyprland_logo   = false,
    },
})

----------------
---- INPUT ----
----------------

hl.config({
    input = {
        kb_layout  = "us",
        kb_variant = "",
        kb_model   = "",
        kb_options = "",
        kb_rules   = "",

        follow_mouse = 1,

        sensitivity = 0,

        touchpad = {
            natural_scroll = false,
        },
    },
})

hl.gesture({
    fingers   = 3,
    direction = "horizontal",
    action    = "workspace",
})

----------------------
---- KEYBINDINGS -----
----------------------

local mainMod = "SUPER"

hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + Space", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + comma", hl.dsp.exec_cmd("rofi -modi emoji -show emoji"))
 hl.bind(mainMod .. " + C", hl.dsp.exec_cmd("cliphist list | rofi -dmenu -theme ~/.config/rofi/config.rasi | cliphist decode | wl-copy"))
 hl.bind(mainMod .. " + W", hl.dsp.exec_cmd("sweetwall"))
 hl.bind(mainMod .. " + SHIFT + W", hl.dsp.exec_cmd("random-wallpaper"))
 hl.bind(mainMod .. " + P", hl.dsp.exec_cmd("powermenu"))

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key,         hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Special workspace (scratchpad)
hl.bind(mainMod .. " + S",         hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Laptop multimedia keys for volume and LCD brightness
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                  { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                  { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })

