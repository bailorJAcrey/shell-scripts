#!/usr/bin/env luajit

function get_cursor_position()
    local handle =  io.popen("hyprctl cursorpos", "r")
    local output
    if handle ~= nil then
        output = handle:read()
        handle:close()
    else
        os.exit(69)
    end

    local idx = 1
    local ret = {}
    for substr in string.gmatch(output, "[%d]+") do
        ret[idx] = substr
        idx = idx + 1
    end
    return tonumber(ret[1]), tonumber(ret[2])
end

pos_x, pos_y = get_cursor_position()
window_width = 250
handle = io.popen(
    string.format(
        "rofi -dmenu -location 1 -theme-str 'window { width: %d; x-offset: %d; y-offset: %d; }'",
        window_width, pos_x - window_width, pos_y
    ),
    "w"
)
handle:write(io.read("*a"))
handle:close()
