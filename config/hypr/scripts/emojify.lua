#!/usr/bin/env lua

-- Settings
local terminal_cmd = "kitty --class emojify_term -e emojify"
local window_class = "emojify_term"
local width = 600
local height = 400

-- Helper function to execute hyprctl dispatch commands via shell
local function hyprctl_dispatch(command)
    local handle = io.popen("hyprctl dispatch " .. command)
    if handle then
        handle:close()
    end
end

-- 1. Apply instant window rules for the specific terminal class via hyprctl
hyprctl_dispatch(string.format("windowrulev2 float, class:^(%s)$", window_class))
hyprctl_dispatch(string.format("windowrulev2 size %d %d, class:^(%s)$", width, height, window_class))
hyprctl_dispatch(string.format("windowrulev2 center, class:^(%s)$", window_class))

-- 2. Launch the terminal process running emojify
os.execute(terminal_cmd .. " &")
