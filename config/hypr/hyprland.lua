-- Hyprland: this machine's niri setup, layered onto Hyprland's own config.
--
-- This file begins as a copy of /usr/share/hypr/hyprland.lua with exactly one
-- region replaced: the example binds, which would otherwise collide with this
-- machine's own (both define Super+Q, Super+V and the workspace digits). Every
-- other line of the stock file is passed through as shipped.
--
-- Starting from the shipped file is deliberate, and the reason is worth keeping.
-- An earlier version of this file set no general or decoration block at all, on
-- the assumption that Hyprland would then fall back to its defaults. It does
-- not. The compiled defaults differ from what the example config produces:
-- measured on 0.56.2 the example gives border_size 2 and rounding 10 where the
-- bare default gives 1 and 0. Inheriting the bare default would have quietly
-- changed the look of every window, which is the opposite of "leave the look
-- alone". Beginning from the example means the compositor's settings are a fresh
-- install's settings by construction.
--
-- So gaps, borders, rounding, opacity, shadow, blur, layout, input and every
-- animation are Hyprland's own, and are not restated anywhere below. Animations
-- in particular are left at Hyprland's timings rather than niri's springs, which
-- was asked for.
--
-- What this file adds is the utility integration: the autostart list from
-- local/bin/niri-startup, the keybinds from config/niri/config.kdl, and the rest
-- of niri's environment block. Waybar needs a config of its own,
-- config/waybar/config-hypr.jsonc, because its workspace module is
-- compositor-specific.
--
-- There is no palette block and no hyprland branch in theme-apply, on purpose.
-- Super+T still works here: themesw recolours the bar, rofi, kitty and the rest
-- from themes/<slug>/palette.conf, and all of those are visible in this session.
-- What it deliberately does not touch is the compositor's own colours.
--
-- Modifiers are all caps throughout. The lua parser reads lowercase "alt" as an
-- unknown keysym and drops the bind silently, with no warning.


------------------
---- MONITORS ----
------------------

-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = "auto",
})


---------------------
---- MY PROGRAMS ----
---------------------

-- Set programs that you use
local terminal    = "kitty"
local fileManager = "dolphin"
local menu        = "hyprlauncher"


-------------------
---- AUTOSTART ----
-------------------

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

-- Autostart necessary processes (like notifications daemons, status bars, etc.)
-- Or execute your favorite apps at launch like this:
--
-- hl.on("hyprland.start", function () 
--   hl.exec_cmd(terminal)
--   hl.exec_cmd("nm-applet")
--   hl.exec_cmd("waybar & hyprpaper & firefox")
-- end)


-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")


-----------------------
----- PERMISSIONS -----
-----------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Permissions/
-- Please note permission changes here require a Hyprland restart and are not applied on-the-fly
-- for security reasons

-- hl.config({
--   ecosystem = {
--     enforce_permissions = true,
--   },
-- })

-- hl.permission("/usr/(bin|local/bin)/grim", "screencopy", "allow")
-- hl.permission("/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland", "screencopy", "allow")
-- hl.permission("/usr/(bin|local/bin)/hyprpm", "plugin", "allow")


-----------------------
---- LOOK AND FEEL ----
-----------------------

-- Refer to https://wiki.hypr.land/Configuring/Basics/Variables/
hl.config({
    general = {
        gaps_in  = 5,
        gaps_out = 20,

        border_size = 2,

        col = {
            active_border   = { colors = {"rgba(33ccffee)", "rgba(00ff99ee)"}, angle = 45 },
            inactive_border = "rgba(595959aa)",
        },

        -- Set to true to enable resizing windows by clicking and dragging on borders and gaps
        resize_on_border = false,

        -- Please see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Tearing/ before you turn this on
        allow_tearing = false,

        layout = "dwindle",
    },

    decoration = {
        rounding       = 10,
        rounding_power = 2,

        -- Change transparency of focused and unfocused windows
        active_opacity   = 1.0,
        inactive_opacity = 1.0,

        shadow = {
            enabled      = true,
            range        = 4,
            render_power = 3,
            color        = 0xee1a1a1a,
        },

        blur = {
            enabled   = true,
            size      = 3,
            passes    = 1,
            vibrancy  = 0.1696,
        },
    },

    animations = {
        enabled = true,
    },
})

-- Animations, from end-4/dots-hyprland (dots/.config/hypr/hyprland/general.lua,
-- the "Curves" and "Configs" sections). The most widely copied Hyprland motion
-- set, and the reason it reads better than the previous set here is not any one
-- curve: it is that almost everything decelerates on the SAME curve,
-- emphasizedDecel, so a window opening, a layer appearing and a special
-- workspace sliding all have one consistent weight to them. The previous set gave
-- each leaf its own curve, which is what made the motion feel scattered.
--
-- Named curves rather than inline bezier points, so a leaf can be retuned
-- centrally. Six of end-4's nine curves are here: his three expressive* spatial
-- curves are not, because nothing references them, in his config or this one.
--
-- Verified on 0.56.2 before writing this: windowsMove and the two
-- specialWorkspace leaves are accepted, and a deliberately misspelled leaf does
-- fail (`no such animation leaf`), so this was tested rather than assumed.
hl.curve("emphasizedDecel",        { type = "bezier", points = { {0.05, 0.7},  {0.1, 1}    } })
hl.curve("emphasizedAccel",        { type = "bezier", points = { {0.3, 0},     {0.8, 0.15} } })
hl.curve("standardDecel",          { type = "bezier", points = { {0, 0},       {1, 1}      } })
hl.curve("menu_decel",             { type = "bezier", points = { {0.1, 1},     {0, 1}      } })
hl.curve("menu_accel",             { type = "bezier", points = { {0.52, 0.03}, {0.72, 0.08} } })
hl.curve("stall",                  { type = "bezier", points = { {1, -0.1},    {0.7, 0.85} } })

hl.animation({ leaf = "global",     enabled = true, speed = 10,  bezier = "emphasizedDecel" })

-- Windows. In and out deliberately use different curves: the old set used
-- "linear" to close a window, which is why closing read as dead weight next to
-- the springy open.
hl.animation({ leaf = "windowsIn",  enabled = true, speed = 3, bezier = "emphasizedDecel", style = "popin 80%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 2, bezier = "emphasizedDecel", style = "popin 90%" })
hl.animation({ leaf = "fadeIn",     enabled = true, speed = 3, bezier = "emphasizedDecel" })
hl.animation({ leaf = "fadeOut",    enabled = true, speed = 2, bezier = "emphasizedDecel" })
-- windowsMove is the slide a window does while being dragged between tiles.
-- Nothing set this before, so tiled drags were teleporting.
hl.animation({ leaf = "windowsMove", enabled = true, speed = 3, bezier = "emphasizedDecel", style = "slide" })
hl.animation({ leaf = "border",     enabled = true, speed = 10, bezier = "emphasizedDecel" })

-- Layers: the bar and the ashell dropdowns.
hl.animation({ leaf = "layersIn",   enabled = true, speed = 2.7, bezier = "emphasizedDecel", style = "popin 93%" })
hl.animation({ leaf = "layersOut",  enabled = true, speed = 2.4, bezier = "menu_accel",      style = "popin 94%" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true, speed = 0.5, bezier = "menu_decel" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 2.7, bezier = "stall" })

-- Workspaces. This is the change you will notice most: speed 7 on a snappy
-- menu_decel, against 1.94 on almostLinear before. That is 3.6x faster and it is
-- why switching felt unhurried.
--
-- Note the lua spelling rather than the hyprlang one. The hyprlang form is
--   animation = workspace, 7, 7, menu_decel, slide
-- and this file is lua, so the same setting is the hl.animation table below.
-- Only "workspaces" is set, not workspacesIn/workspacesOut: end-4 does the same,
-- and setting all three separately fights the single global slide.
hl.animation({ leaf = "workspaces", enabled = true, speed = 7, bezier = "menu_decel", style = "slide" })

-- Special workspaces: nothing currently opens one (no togglespecialworkspace
-- bind), so these two are inert until something does. end-4 sets them and they
-- cost nothing; leaving them out would be a decision to revisit later.
hl.animation({ leaf = "specialWorkspaceIn",  enabled = true, speed = 2.8, bezier = "emphasizedDecel", style = "slidevert" })
hl.animation({ leaf = "specialWorkspaceOut", enabled = true, speed = 1.2, bezier = "emphasizedAccel", style = "slidevert" })

hl.animation({ leaf = "zoomFactor", enabled = true, speed = 3, bezier = "standardDecel" })

-- Ref https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/
-- "Smart gaps" / "No gaps when only"
-- uncomment all if you wish to use that.
-- hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
-- hl.workspace_rule({ workspace = "f[1]",   gaps_out = 0, gaps_in = 0 })
-- hl.window_rule({
--     name  = "no-gaps-wtv1",
--     match = { float = false, workspace = "w[tv1]" },
--     border_size = 0,
--     rounding    = 0,
-- })
-- hl.window_rule({
--     name  = "no-gaps-f1",
--     match = { float = false, workspace = "f[1]" },
--     border_size = 0,
--     rounding    = 0,
-- })

-- See https://wiki.hypr.land/Configuring/Layouts/Dwindle-Layout/ for more
hl.config({
    dwindle = {
        preserve_split = true, -- You probably want this
    },
})

-- See https://wiki.hypr.land/Configuring/Layouts/Master-Layout/ for more
hl.config({
    master = {
        new_status = "master",
    },
})

-- See https://wiki.hypr.land/Configuring/Layouts/Scrolling-Layout/ for more
hl.config({
    scrolling = {
        fullscreen_on_one_column = true,
    },
})

----------------
----  MISC  ----
----------------

hl.config({
    misc = {
        force_default_wallpaper = -1,    -- Set to 0 or 1 to disable the anime mascot wallpapers
        disable_hyprland_logo   = false, -- If true disables the random hyprland logo / anime girl background. :(
    },
})


---------------
---- INPUT ----
---------------

hl.config({
    input = {
        kb_layout  = "us",
        kb_variant = "",
        kb_model   = "",
        kb_options = "",
        kb_rules   = "",

        follow_mouse = 1,

        sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.

        touchpad = {
            natural_scroll = false,
        },
    },
})

hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace"
})

-- Example per-device config
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Devices/ for more
hl.device({
    name        = "epic-mouse-v1",
    sensitivity = -0.5,
})


---------------------
---- KEYBINDINGS ----
---------------------



-- The stock config above sets XCURSOR_SIZE to 24. These are the rest of niri's
-- environment block, so the same programs behave the same way in both sessions.
--
-- PATH matters more than it looks. SDDM starts the session directly, so
-- ~/.bashrc never runs and ~/.local/bin is missing from PATH -- which would
-- break every bind below that calls a helper script from ~/.local/bin.
hl.env("PATH", "/home/water/.local/bin:" .. (os.getenv("PATH") or ""))
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("QT_STYLE_OVERRIDE", "kvantum")
hl.env("QT_SCALE_FACTOR", "0.92")
hl.env("EDITOR", "nvim")
hl.env("VISUAL", "nvim")
hl.env("TERMINAL", "kitty")

------------------------
---- KEYBINDINGS --------
------------------------
-- Niri's binds, translated to what 0.56 can express.
--
-- Dropped, because niri is a scrolling WM and these have no counterpart here
-- rather than merely a different name: consume-or-expel-window-left/right,
-- expel-window-from-column, switch-preset-column-width / -back /
-- -window-height, reset-window-height, expand-column-to-available-width,
-- center-visible-columns, focus-column-first/last, move-column-to-first/last,
-- move-column-to-workspace-N (a window is not a column here, so it would only
-- duplicate Mod+Shift+N), move-column-to-monitor-*, move-workspace-up/down,
-- toggle-overview, switch-focus-between-floating-and-tiling,
-- show-hotkey-overlay and toggle-keyboard-shortcuts-inhibit.
--
-- Dropped because 0.56's config API cannot express them, which is a different
-- reason and was checked rather than assumed: `hyprctl dispatch` evaluates Lua
-- instead of the old argument string, hl.focus and hl.window.move take no
-- monitor field, setprop has no monitor request, and there is no DPMS
-- dispatcher. So focus-monitor (Mod+Alt+Arrow) and power-off-monitors
-- (Mod+Shift+P) are unreachable, and brightness-step cannot black the panel the
-- way it does under niri. It stays safe: it only marks the display off when the
-- niri call succeeded, so here it just leaves the backlight at 0. Alt+Tab is
-- gone too, having no recent-window dispatcher.
--
-- The utilities below are the reason this file exists at all.

local mainMod = "SUPER" -- the stock declaration lived in the block replaced above

local stepW = 136 -- 10% of this 1366x768 panel, rounded
local stepH = 76

-- --- launchers; the app launcher is Super+Space, as in niri ---
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + E",     hl.dsp.exec_cmd("kitty --class yazi -e yazi"))
hl.bind(mainMod .. " + Space", hl.dsp.exec_cmd("rofi -show drun"))
hl.bind(mainMod .. " + comma", hl.dsp.exec_cmd("smile"))
hl.bind(mainMod .. " + B",     hl.dsp.exec_cmd("firefox"))
hl.bind(mainMod .. " + D",     hl.dsp.exec_cmd("nemo"))

-- --- window management ---
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
-- internal and client are integers, not the strings the error message suggests:
-- 0 none, 1 fullscreen, 2 maximise. With no action given it toggles, which is
-- what niri's fullscreen-window does.
hl.bind(mainMod .. " + F",
    hl.dsp.window.fullscreen_state({ internal = 1, client = 1 }))

-- --- focus: Left/Right walk columns, Up/Down walk windows inside one ---
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))

-- --- move, as niri's Mod+Ctrl+Arrow ---
hl.bind(mainMod .. " + CTRL + left",  hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + CTRL + right", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + CTRL + up",    hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + CTRL + down",  hl.dsp.window.move({ direction = "down" }))

-- --- resize, as niri's Mod+Shift+Arrow. Niri resizes by percentage;
-- hl.dsp.window.resize takes pixels in x/y instead. ---
hl.bind(mainMod .. " + SHIFT + left",  hl.dsp.window.resize({ x = -stepW, y = 0 }))
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.resize({ x =  stepW, y = 0 }))
hl.bind(mainMod .. " + SHIFT + up",    hl.dsp.window.resize({ x = 0, y = -stepH }))
hl.bind(mainMod .. " + SHIFT + down",  hl.dsp.window.resize({ x = 0, y =  stepH }))

-- --- workspaces 1-10, and move the focused window to one ---
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key,         hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- --- the ~/.local/bin helpers: theme, wallpaper, clipboard, power, lock ---
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd("/home/water/.local/bin/themesw"))
-- Super+W opens the picker on ~/Pictures/Wallpapers. wallpaper-switcher no longer
-- maps folders through themes/<slug>/palette.conf: it points at that one folder,
-- which is where hand-picked wallpapers go.
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd("/home/water/.local/bin/wallpaper-switcher"))
hl.bind(mainMod .. " + SHIFT + W", hl.dsp.exec_cmd("/home/water/.local/bin/toggle-waybar"))
hl.bind(mainMod .. " + P", hl.dsp.exec_cmd("/home/water/.local/bin/powerprofile"))
hl.bind(mainMod .. " + U", hl.dsp.exec_cmd("wlogout"))
-- The clipboard: the wl-paste watcher in autostart records history into
-- cliphist, rofi picks an entry, and it goes back onto the clipboard.
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd(
    "cliphist list | rofi -dmenu -theme /home/water/.config/rofi/config.rasi"
    .. " | cliphist decode | wl-copy"))
hl.bind("SUPER + ALT + L",
    hl.dsp.exec_cmd("swaylock -C /home/water/.config/niri/lock.conf -f"))

-- --- drag and resize with the mouse ---
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- --- screenshots, into the folder niri's screenshot-path points at ---
local shotDir = "/home/water/Pictures/Screenshots"
hl.bind("Print", hl.dsp.exec_cmd(
    'grim -g "$(slurp)" "' .. shotDir .. '/screenshot_%Y-%m-%d_%H-%M-%S.png"'))
hl.bind("CTRL + Print", hl.dsp.exec_cmd(
    'grim "' .. shotDir .. '/screen_%Y-%m-%d_%H-%M-%S.png"'))
-- Region of the focused window, copied to the clipboard. The jq filter sits in a
-- long-bracket string so its own single quotes need no escaping.
local winRegion = [==[hyprctl -j activewindow | jq -r 'if .size then "\(.size[0])x\(.size[1])+\(.at[0])+\(.at[1])" else "" end']==]
hl.bind("ALT + Print", hl.dsp.exec_cmd('grim -g "$(echo ' .. winRegion .. ')" - | wl-copy'))

-- --- volume, brightness and media. XF86 keys carry no modifier, so the key
-- string is the bare key name; locked keeps them working on the lock screen and
-- repeating makes a held key step instead of firing once. ---
hl.bind("XF86AudioRaiseVolume",
    hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume",
    hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioMute",
    hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })
hl.bind("XF86AudioMicMute",
    hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true })
hl.bind("XF86MonBrightnessUp",
    hl.dsp.exec_cmd("/home/water/.local/bin/brightness-step up"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown",
    hl.dsp.exec_cmd("/home/water/.local/bin/brightness-step down"), { locked = true, repeating = true })
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })
hl.bind("XF86AudioStop",  hl.dsp.exec_cmd("playerctl stop"),       { locked = true })

------------------------
---- AUTOSTART ---------
------------------------
-- local/bin/niri-startup in the same order, with ashell as the bar. ashell
-- reads ~/.config/ashell/config.toml by default and detects the compositor
-- itself, so there is no Hyprland-specific bar config to point it at.
hl.on("hyprland.start", function()
    hl.exec_cmd("pkill -x dunst 2>/dev/null; true")
    -- mako is deliberately not started here. It used to be, but there is only
    -- one org.freedesktop.Notifications bus name and ashell needs it for the
    -- notification dropdown in the bar. Launching both means ashell logs
    -- "Bus name already owned" and silently receives no notifications, so the
    -- dropdown stays empty while mako does the popping -- the two features are
    -- mutually exclusive, not additive. ashell does both jobs now, toasts
    -- included. Verified: with mako running, ashell never gets the name; with
    -- mako stopped, mako then fails with "Failed to acquire service name".
    hl.exec_cmd("systemctl --user restart xdg-desktop-portal.service")
    -- ashell's palette lives in the [appearance] section of a config.toml that
    -- is also hand-edited and committed, so anything that rewrites that file
    -- silently reverts the bar's colours while every other app keeps the new
    -- palette. Re-derive it from the theme in the state file before the bar
    -- starts, which makes the bar self-healing. Separated by ';' rather than
    -- '&&' on purpose: if the repair fails for any reason, ashell must still
    -- come up, because no bar at all is worse than a stale-coloured one.
    hl.exec_cmd("/home/water/.local/bin/theme-apply --ashell-only >/dev/null 2>&1")
    -- the bar is waybar since the rice switch; --config picks the session's
    -- file, and SIGUSR2 restyles without dropping the layer under niri.
    hl.exec_cmd("waybar -c /home/water/.config/waybar/config-hypr.jsonc -s /home/water/.config/waybar/style.css")
    -- hyprpaper paints the wallpaper and renders animated ones, which awww
    -- and matuwall's own backends do not.
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("/home/water/.local/bin/at_startup")
    hl.exec_cmd("awww-daemon")
    hl.exec_cmd("awww restore")
    hl.exec_cmd("nm-applet")
    hl.exec_cmd("wl-paste --watch cliphist store")
    hl.exec_cmd("/usr/lib/polkit-kde-authentication-agent-1")
    hl.exec_cmd("kitty")
end)

---- WINDOWS AND WORKSPACES ----
--------------------------------

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- and https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

-- Example window rules that are useful

local suppressMaximizeRule = hl.window_rule({
    -- Ignore maximize requests from all apps. You'll probably like this.
    name  = "suppress-maximize-events",
    match = { class = ".*" },

    suppress_event = "maximize",
})
-- suppressMaximizeRule:set_enabled(false)

hl.window_rule({
    -- Fix some dragging issues with XWayland
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },

    no_focus = true,
})

-- Layer rules also return a handle.
-- local overlayLayerRule = hl.layer_rule({
--     name  = "no-anim-overlay",
--     match = { namespace = "^my-overlay$" },
--     no_anim = true,
-- })
-- overlayLayerRule:set_enabled(false)

-- Hyprland-run windowrule
hl.window_rule({
    name  = "move-hyprland-run",
    match = { class = "hyprland-run" },

    move  = "20 monitor_h-120",
    float = true,
})

-- kitty is excluded from blur rather than relying on decoration.blur being off
-- globally. That setting lives in config/hypr/hyprland-gui.lua, which hyprmod
-- rewrites from its own state and has twice left blur enabled on a machine
-- where the committed config has it off; when that happens every window goes
-- frosted again. A rule here cannot be undone by that, and it also keeps the
-- blur off kitty specifically without costing any other window the effect.
hl.window_rule({
    name     = "kitty-no-blur",
    match    = { class = "^(kitty|kitty-wayland)$" },
    no_blur  = true,
    no_shadow = true,
})

-- HyprMod managed settings
require("hyprland-gui")
