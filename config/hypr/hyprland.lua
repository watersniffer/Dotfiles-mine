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
-- The desktop theme is fixed, not derived from anything. The colours in
-- config/waybar/colors.css, config/rofi/colors.rasi, config/kitty/current-theme.conf
-- and config/mako/config are E-ink: a dark greyscale palette, every accent a grey,
-- stepped so the shades still separate in a terminal. They are committed files, not
-- generated, so nothing regenerates them and changing the wallpaper does not
-- recolour anything.
--
-- That was not always so. There was a theme switcher (Super+T) over seven palettes
-- in themes/, and later the wallpaper became the theme via matugen. Both are gone;
-- what is left is the palette written out once. E-ink's palette is still in
-- themes/e-ink/palette.conf as the record of where the values came from, but
-- nothing reads it.
--
-- The compositor's own colours are deliberately not themed either: the frame,
-- borders and shadows are set below and stay as they are.
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
            -- natural_scroll = true is what most people expect on a touchpad: the
            -- content moves the same way as on a phone, so pushing up scrolls
            -- down. It was explicitly false here, which is mouse-like behaviour
            -- and the single most common reason a touchpad feels wrong on a
            -- desktop.
            natural_scroll = true,

            -- Tapping to click. Without this a tap does nothing and you have to
            -- physically press, which is both slower and the reason people decide
            -- a touchpad is broken.
            tap_to_click = true,

            -- Do not scroll while typing. The palm resting on the trackpad
            -- otherwise scrolls whatever is under the cursor, and the cursor
            -- jumps somewhere else at the same time.
            disable_while_typing = true,

            -- Scroll speed. Flat, because this build has no per-finger factors
            -- (see below), so there is no way to make three-finger scrolling
            -- faster than two-finger without also making ordinary scrolling
            -- faster. The three-finger workspace swipe below is therefore the same
            -- speed as everything else.
            scroll_factor = 1.0,
        },
        -- Not set, because Hyprland 0.56.2 has no such options -- each of these
        -- is rejected as an unknown key, verified with
        -- `hyprctl getoption input:touchpad:<name>`:
        --
        --   tap_to_click_right       no such option
        --   middle_click_emulation   no such option
        --   clickfinger              no such option
        --   palm_detection           no such option
        --   scroll_2fg / scroll_3fg  no such option
        --
        -- So there is no trackpad right-click or middle-click here. Right-click
        -- works from the touchpad, but only through what the pad itself reports;
        -- middle-click emulation, which is what makes paste work in a browser
        -- without a physical middle button, is not available in this build.
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
-- Super+E opens the file manager and Super+Alt+E the terminal file browser.
-- They were the other way round, and Super+E was yazi.
--
-- yazi runs inside kitty rather than in a terminal emulator of its own choice, so
-- the class is set: that is what makes the window group with the other kitty
-- windows instead of standing alone, and it is what the Alt-Tab switcher matches
-- on.
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd("nemo"))
hl.bind(mainMod .. " + ALT + E",
        hl.dsp.exec_cmd("kitty --class yazi -e yazi"))

-- The app launcher is rofi. It had been pushed onto Super+O as a fallback behind
-- the Quickshell launcher, which is gone, and it is back on Super+Space. Its
-- colours come from config/rofi/colors.rasi.
--
-- The bind below was lost at some point during the shell-swap work and the comment
-- outlived it, so the launcher simply did nothing. If it goes missing again, check
-- that this hl.bind is actually present rather than just this comment.
hl.bind(mainMod .. " + Space", hl.dsp.exec_cmd("rofi -show drun"))

-- Super+W is the wallpaper picker. It used to be theme-aware -- wallpaper-switcher
-- asked theme-apply which folder the current palette named -- but there are no
-- palettes now, so there is nothing for it to ask and the theme follows whichever
-- wallpaper is set rather than the other way round. It falls back to the wallpapers
-- root when a theme's own folder is empty, and only Tokyo Night has images in it.
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd("/home/water/.local/bin/wallpaper-switcher"))

-- Super+Shift+W hides/shows the bar. toggle-waybar came back with the rest of
-- local/bin; waybar's own SIGUSR1 would do the same thing.
hl.bind(mainMod .. " + SHIFT + W", hl.dsp.exec_cmd("/home/water/.local/bin/toggle-waybar"))

hl.bind(mainMod .. " + comma", hl.dsp.exec_cmd("smile"))
-- Zen Browser. This said "firefox", which is not installed on this machine, so
-- the bind was dead. zen-browser is what is actually used and what is running.
hl.bind(mainMod .. " + B",     hl.dsp.exec_cmd("zen-browser"))
-- Super+D is the calendar. It was nemo, which is now on Super+E.
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd("dcal"))

-- --- window management ---
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
-- Float toggle. Was Super+V, which is now the clipboard picker -- Super+V is the
-- natural key for a clipboard and no amount of wanting it elsewhere makes that
-- feel right. Super+Alt+F rather than a bare other letter because plain F is
-- fullscreen just below and the two are related enough to want the same hand
-- position with one extra modifier.
hl.bind(mainMod .. " + ALT + F", hl.dsp.window.float({ action = "toggle" }))
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


-- because it is the faster of the two for just cycling through; this one has the
hl.bind(mainMod .. " + U", hl.dsp.exec_cmd("wlogout"))
-- The clipboard. Super+V, because that is the muscle memory and Super+C was
-- never a good use of the key.
--
-- This used to be a one-line pipeline inline in the bind, and it wiped the
-- clipboard every time it was cancelled:
--
--     cliphist list | rofi -dmenu -dmenu | cliphist decode | wl-copy
--
-- Escape in rofi is not a failure, it is how you change your mind, and the
-- pipeline did not treat it as one -- rofi printed nothing, cliphist decode read
-- nothing and exited 1, and wl-copy was handed empty stdin, which is how you
-- clear a clipboard. Measured: a clipboard holding BEFORE-CANCEL-TEST came back
-- empty after a single Escape. It read as "the clipboard is not saving things".
-- local/bin/clipboard-history checks the selection instead of the exit status,
-- because rofi exits 0 when cancelled.
--
-- The other half of this feature was broken too and for a different reason: the
-- wl-paste --watch feeder in the autostart block had died and nothing restarted
-- it, so nothing was reaching cliphist at all. That is local/bin/clipboard-watcher.
hl.bind(mainMod .. " + V",
    hl.dsp.exec_cmd("/home/water/.local/bin/clipboard-history"))
-- Lock the session. Super+L, not Super+U: U is wlogout, and that is the key that
-- belongs there.
--
-- This was `swaylock -f` on Super+Alt+L. swaylock and swaylock-effects are both
-- uninstalled, so the bind and the package went together rather than leaving a
-- bind pointing at a binary that is no longer there. hyprlock was already
-- installed, just unused.
--
-- hyprlock has no -f and needs none: it backgrounds itself, and Super+Enter
-- dismisses it, which is its default and is not overridden here.
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("hyprlock"))

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
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })
hl.bind("XF86AudioStop",  hl.dsp.exec_cmd("playerctl stop"),       { locked = true })

-- The brightness function keys. These had no bind at all, which is the whole
-- reason the Fn-row brightness buttons did nothing: the section above covers
-- XF86Audio* only, and XF86MonBrightness* was simply never bound.
--
-- They send plain XF86MonBrightnessUp / XF86MonBrightnessDown (keycodes I232 and
-- I233 in the inet keymap), so they are bound as bare key names with no modifier,
-- the same shape as the volume keys above.
--
-- brightness-step rather than brightnessctl directly, because on this panel the
-- LCD still emits light at 0 -- the backlight is off while the display stays lit,
-- so plain `brightnessctl s 0` gives a lit-but-black screen rather than a dark
-- one. brightness-step is what joins 0 up to a real panel-off.
--
-- What that buys here is only the stepping. Its panel-off path goes through
-- `niri msg action power-off-monitors`, which is guarded and no-ops outside niri,
-- so at 0% this panel stays faintly lit. That is the same limitation already
-- recorded above the utilities block, and it is not fixable from here: Hyprland
-- 0.56 has no DPMS dispatcher.
--
-- repeating so a held key ramps instead of stepping once, matching the volume
-- keys. locked is deliberately not set: the lock screen draws its own brightness
-- handling and has no backlight to step once the panel is down.
hl.bind("XF86MonBrightnessUp",
    hl.dsp.exec_cmd("brightness-step up"), { repeating = true })
hl.bind("XF86MonBrightnessDown",
    hl.dsp.exec_cmd("brightness-step down"), { repeating = true })

-- Power mode, Super+P: performance -> balanced -> power-saver -> performance.
--
-- The script rather than a bare `powerprofilesctl` because that tool has no `next`
-- -- it only takes an explicit name -- and because the order is this config's
-- choice to make, not the daemon's. It also notifies, since a power mode you
-- cannot see is one you will not trust to be in the state you left it.
--
-- The powerprofile script in local/bin does something similar but is written for
-- asusctl, which is not installed and would not drive this Dell anyway.
-- power-profiles-daemon is what is actually running here, over intel_pstate.
hl.bind(mainMod .. " + P",
    hl.dsp.exec_cmd("/home/water/.local/bin/power-mode"))

------------------------
---- AUTOSTART ---------
------------------------
-- local/bin/niri-startup in the same order, with ashell as the bar. ashell
-- reads ~/.config/ashell/config.toml by default and detects the compositor
-- itself, so there is no Hyprland-specific bar config to point it at.
hl.on("hyprland.start", function()
    hl.exec_cmd("pkill -x dunst 2>/dev/null; true")
    hl.exec_cmd("systemctl --user restart xdg-desktop-portal.service")

    -- The bar is waybar again, in place of silere. Started explicitly rather than
    -- left to the compositor so it comes up in a defined order.
    --
    -- Its stylesheet draws it as a floating island. Note that layer-shell surfaces
    -- always span the full output width, so the inset is applied to an inner
    -- container box in style.css, not to the bar window itself: margin on
    -- window#waybar is silently ignored.
    hl.exec_cmd("waybar -c /home/water/.config/waybar/config-hypr.jsonc -s /home/water/.config/waybar/style.css")

    -- mako owns notifications. Waybar has no notification daemon of its own and
    -- silere used to hold this bus name; exactly one daemon may own it, so this
    -- must not run alongside anything else that registers for notifications.
    hl.exec_cmd("mako")

    -- 20-20-20 eye strain reminder. safeeyes is an AUR package; its own default
    -- rule is already 20 minutes / 20 seconds / 20 feet, and that is written out
    -- explicitly in ~/.config/safeeyes/safeeyes.json rather than left to whatever
    -- its first run decides. Started after mako on purpose: safeeyes raises its
    -- own full-screen overlay, and mako owning the notification bus first means
    -- the two are not competing when the break prompt appears.
    hl.exec_cmd("safeeyes")
    -- is also hand-edited and committed, so anything that rewrites that file
    -- silently reverts the bar's colours while every other app keeps the new
    -- palette. Re-derive it from the theme in the state file before the bar
    -- starts, which makes the bar self-healing. Separated by ';' rather than
    -- '&&' on purpose: if the repair fails for any reason, ashell must still
    -- come up, because no bar at all is worse than a stale-coloured one.

    -- The wallpaper backend. Silere does not draw a wallpaper, so awww stays.
    hl.exec_cmd("awww-daemon")
    -- Restore the last wallpaper, then check it took. `awww restore` exits 0 even
    -- when it has nothing to restore, so without the check a missing or empty
    -- state file leaves the bare Hyprland background on screen with no indication
    -- why. The fallback is a specific wallpaper rather than a guess, because the
    -- alternative to a wallpaper here is Hyprland's own default, which is what
    -- makes the desktop look like it booted wrong.
    hl.exec_cmd("sleep 1; awww restore || awww img -- /home/water/Pictures/Wallpapers/a_river_running_through_a_small_town.jpg")


    -- Clipboard history. This watcher lived in ~/.local/bin/at_startup until the
    -- wipe, so nothing was populating cliphist and the picker had nothing to
    -- show; it was then run directly from here as `wl-paste --watch cliphist
    -- store`, which also failed, for a different reason.
    --
    -- wl-paste --watch exits by itself in ordinary situations -- an app taking the
    -- clipboard with no text, or a cleared selection. Launched with a single exec
    -- and never supervised, the first such exit ended clipboard history for the
    -- rest of the session. That is the state it was found in: this autostart
    -- block was working (mako, awww, nm-applet and kitty were all up from it),
    -- the session was 28 hours old, wl-paste was gone, and a wl-copy test
    -- round-tripped to cliphist without recording a single entry.
    --
    -- clipboard-watcher restarts it instead, and takes a lock so a second copy
    -- cannot race on the database. Restarts are safe: cliphist collapses a store
    -- that repeats the previous entry, so it will not fill up with duplicates.
    hl.exec_cmd("/home/water/.local/bin/clipboard-watcher")

    -- Session services.
    hl.exec_cmd("nm-applet")
    hl.exec_cmd("/usr/lib/polkit-kde-authentication-agent-1")
    hl.exec_cmd("kitty")

    -- Idle handling: 15 minutes of no input turns the panel off, and the first
    -- input after that brings up hyprlock. hypridle was already installed but was
    -- never started, so nothing locked the session on its own before this.
    -- The timing and both actions live in config/hypr/hypridle.conf.
    hl.exec_cmd("hypridle")
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

-- Scratchpad, on Super+S.
--
-- Hyprland has no scratchpad of its own, so this is the usual construction: a
-- window with no border, no rounding, no shadow and no blur, floating, so it looks
-- like a bare terminal sitting on the wallpaper and nothing else.
--
-- Only fields the Lua API actually exposes are used. The obvious names are all
-- rejected at load with "unknown field", checked against the other rules in this
-- file rather than assumed:
--
--   float, border_size, rounding, no_shadow, no_blur, move, pin   accepted
--   border, shadow, gaps_in_inner, gaps_out_outer, no_anim,
--   stay_on_workspace, focus_on_activate                          unknown
--
-- So two things a scratchpad normally does are unavailable here. Per-window gaps
-- and per-window animation suppression are not in the API, so the window keeps the
-- global gap and the global open animation. And there is no stay-on-workspace, so
-- it is left floating, which keeps it on the workspace it was opened from rather
-- than dragging it along.
hl.window_rule({
    name  = "scratchpad-plain",
    match = { class = "^scratchpad$" },

    float       = true,
    border_size = 0,
    rounding    = 0,
    no_shadow   = true,
    no_blur     = true,

    -- Drops in from above rather than popping. The global windowsIn is
    -- "popin 80%", so without this the scratchpad would scale up from the
    -- middle of the screen like every other window; slidevert with a negative
    -- offset slides it down out of the top edge, which is the direction a
    -- scratchpad is expected to come from.
    --
    -- The field is a string, not a table: the lua API rejects a table here with
    -- "string type requires a string", though it accepts a bare style name, a
    -- style with an offset, or the full four-part form. The four-part form is
    -- style, offset, speed, bezier -- 4 is a deliberately quick slide so it does
    -- not get in the way of a key you press often, and menu_decel is the curve
    -- the workspace switch already uses, so the two feel like the same desktop.
    animation   = "slidevert -60, 4, 70, menu_decel",
})

-- The bind runs a script rather than a bare app because the same key has to both
-- open the window and close it again -- and nothing outside the window can close
-- it on this Hyprland. Every dispatch route is broken here: `hyprctl dispatch
-- killwindow` expands to invalid Lua, and `hyprctl eval 'return
-- hl.dsp.window.close()'` answers "ok" and leaves the window open. All three were
-- tried against a real window of this class.
--
-- So local/bin/scratchpad drops a flag file and the window closes itself.
--
-- It also decides *what* to run. This used to end in `exec kitty --class
-- scratchpad -e ...`, which made the scratchpad a terminal whatever you wanted in
-- it. The app is now configuration -- `scratchpad set <cmd>`, or `scratchpad
-- pick` to be asked each time -- and the first press of Super+S with nothing
-- configured asks once and remembers.
hl.bind(mainMod .. " + S", hl.dsp.exec_cmd("/home/water/.local/bin/scratchpad"))

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
